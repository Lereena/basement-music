/// Minimal LRC parsing/serialization for the lyrics timing editor.
///
/// The server decides synced-vs-plain with the regex
/// `(?m)^\s*\[\d{1,2}:\d{2}(?:[.:]\d{1,3})?\]`, so [LrcDocument.serialize]
/// must emit timestamps that regex matches, and [LrcDocument.parse] accepts
/// the same shapes back ([m:ss], [mm:ss.x]..[mm:ss.xxx], [mm:ss:xx]).
library;

// Line timestamps. Fraction group meaning depends on the separator:
// '.5'→500ms, '.50'→500ms, '.500'→500ms; ':50' (colon) → centiseconds.
final _timestampRegExp = RegExp(r'\[(\d{1,3}):(\d{2})(?:([.:])(\d{1,3}))?\]');

// Meta tags like [ar:...], [ti:...], [offset:+250]. First char after '[' is
// not a digit, which is what distinguishes them from timestamps.
final _metaTagRegExp = RegExp(r'^\[([a-zA-Z#][^\]:]*):(.*)\]$');

class LrcLine {
  final String text;
  final Duration? time;

  const LrcLine({required this.text, this.time});

  LrcLine copyWith({String? text, Duration? time, bool clearTime = false}) =>
      LrcLine(text: text ?? this.text, time: clearTime ? null : (time ?? this.time));
}

class LrcDocument {
  /// Meta tags preserved verbatim (e.g. '[ar:Artist]'), except [offset:]
  /// which parse() folds into line times and drops.
  final List<String> metaTags;
  final List<LrcLine> lines;

  const LrcDocument({this.metaTags = const [], this.lines = const []});

  bool get allTimed => lines.isNotEmpty && lines.every((line) => line.time != null);
  int get timedCount => lines.where((line) => line.time != null).length;

  /// Parses either LRC or plain text: lines without a leading timestamp
  /// become untimed [LrcLine]s, so plain lyrics are timeable from scratch.
  static LrcDocument parse(String source) {
    final metaTags = <String>[];
    final lines = <LrcLine>[];
    var offset = Duration.zero;

    for (final rawLine in source.split('\n')) {
      final line = rawLine.trimRight();
      if (line.trim().isEmpty) continue;

      final metaMatch = _metaTagRegExp.firstMatch(line.trim());
      if (metaMatch != null) {
        if (metaMatch.group(1)!.toLowerCase() == 'offset') {
          // LRC offset: positive shifts lyrics earlier (subtract from times).
          offset = Duration(milliseconds: int.tryParse(metaMatch.group(2)!.trim()) ?? 0);
        } else {
          metaTags.add(line.trim());
        }
        continue;
      }

      final timestamps = <Duration>[];
      var textStart = 0;
      for (final match in _timestampRegExp.allMatches(line)) {
        if (match.start != textStart) break; // timestamps must be a leading run
        timestamps.add(_toDuration(match));
        textStart = match.end;
      }

      final text = line.substring(textStart).trim();
      if (timestamps.isEmpty) {
        lines.add(LrcLine(text: text));
      } else {
        // Multi-timestamp lines ([00:12][00:24]text) repeat for each time.
        for (final time in timestamps) {
          final shifted = time - offset;
          lines.add(LrcLine(text: text, time: shifted.isNegative ? Duration.zero : shifted));
        }
      }
    }

    lines.sortByTimeKeepingUntimedOrder();
    return LrcDocument(metaTags: metaTags, lines: lines);
  }

  static Duration _toDuration(RegExpMatch match) {
    final minutes = int.parse(match.group(1)!);
    final seconds = int.parse(match.group(2)!);
    final separator = match.group(3);
    final fraction = match.group(4);

    var milliseconds = 0;
    if (fraction != null) {
      milliseconds = separator == ':'
          ? int.parse(fraction) * 10 // [mm:ss:xx] — colon fraction is centiseconds
          : int.parse(fraction.padRight(3, '0').substring(0, 3));
    }

    return Duration(minutes: minutes, seconds: seconds, milliseconds: milliseconds);
  }

  /// Emits `[mm:ss.xx]` (centiseconds) — matches the server's synced-lyrics
  /// detection regex. Untimed lines are emitted bare (callers should not
  /// serialize partially-timed documents for saving).
  String serialize() {
    final buffer = StringBuffer();
    for (final tag in metaTags) {
      buffer.writeln(tag);
    }
    for (final line in lines) {
      final time = line.time;
      if (time == null) {
        buffer.writeln(line.text);
      } else {
        buffer.writeln('${formatLrcTimestamp(time)}${line.text}');
      }
    }
    return buffer.toString().trimRight();
  }
}

String formatLrcTimestamp(Duration time) {
  final minutes = time.inMinutes;
  final seconds = time.inSeconds % 60;
  final centiseconds = (time.inMilliseconds % 1000) ~/ 10;
  String pad(int value) => value.toString().padLeft(2, '0');
  return '[${pad(minutes)}:${pad(seconds)}.${pad(centiseconds)}]';
}

extension on List<LrcLine> {
  /// Stable sort by time; untimed lines keep their relative position by
  /// inheriting the previous timed line's time as a sort key.
  void sortByTimeKeepingUntimedOrder() {
    if (every((line) => line.time == null)) return;

    final keyed = <(Duration, int, LrcLine)>[];
    var lastTime = Duration.zero;
    for (var i = 0; i < length; i++) {
      lastTime = this[i].time ?? lastTime;
      keyed.add((lastTime, i, this[i]));
    }
    keyed.sort((a, b) {
      final byTime = a.$1.compareTo(b.$1);
      return byTime != 0 ? byTime : a.$2.compareTo(b.$2);
    });
    for (var i = 0; i < length; i++) {
      this[i] = keyed[i].$3;
    }
  }
}
