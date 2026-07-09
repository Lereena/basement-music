import 'package:basement_music/utils/lrc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LrcDocument.parse', () {
    test('parses standard synced lyrics', () {
      final doc = LrcDocument.parse('[00:01.00]First line\n[00:05.50]Second line');

      expect(doc.lines, hasLength(2));
      expect(doc.lines[0].text, 'First line');
      expect(doc.lines[0].time, const Duration(seconds: 1));
      expect(doc.lines[1].time, const Duration(seconds: 5, milliseconds: 500));
      expect(doc.allTimed, isTrue);
    });

    test('parses plain lyrics as untimed lines, skipping blanks', () {
      final doc = LrcDocument.parse('First line\n\nSecond line\n');

      expect(doc.lines.map((l) => l.text), ['First line', 'Second line']);
      expect(doc.lines.every((l) => l.time == null), isTrue);
      expect(doc.allTimed, isFalse);
      expect(doc.timedCount, 0);
    });

    test('accepts all server-regex timestamp shapes', () {
      final doc = LrcDocument.parse('[0:05]a\n[00:05.5]b\n[00:05.50]c\n[00:05.500]d\n[00:05:50]e');

      expect(doc.lines.map((l) => l.time), [
        const Duration(seconds: 5),
        const Duration(seconds: 5, milliseconds: 500),
        const Duration(seconds: 5, milliseconds: 500),
        const Duration(seconds: 5, milliseconds: 500),
        const Duration(seconds: 5, milliseconds: 500),
      ]);
    });

    test('expands multi-timestamp lines and sorts by time', () {
      final doc = LrcDocument.parse('[00:24.00][00:12.00]Chorus\n[00:18.00]Verse');

      expect(doc.lines.map((l) => '${l.time!.inSeconds} ${l.text}'), [
        '12 Chorus',
        '18 Verse',
        '24 Chorus',
      ]);
    });

    test('preserves meta tags, folds offset into times and drops it', () {
      final doc = LrcDocument.parse('[ar:Artist]\n[ti:Title]\n[offset:+500]\n[00:01.00]First');

      expect(doc.metaTags, ['[ar:Artist]', '[ti:Title]']);
      expect(doc.lines.single.time, const Duration(milliseconds: 500));
    });

    test('clamps offset-shifted times at zero', () {
      final doc = LrcDocument.parse('[offset:2000]\n[00:01.00]First');

      expect(doc.lines.single.time, Duration.zero);
    });

    test('keeps untimed lines in place among timed ones', () {
      final doc = LrcDocument.parse('[00:10.00]a\nuntimed\n[00:05.00]b');

      expect(doc.lines.map((l) => l.text), ['b', 'a', 'untimed']);
    });
  });

  group('LrcDocument.serialize', () {
    test('emits [mm:ss.xx] with meta tags first', () {
      const doc = LrcDocument(
        metaTags: ['[ar:Artist]'],
        lines: [
          LrcLine(text: 'First', time: Duration(seconds: 1)),
          LrcLine(text: 'Second', time: Duration(minutes: 1, seconds: 5, milliseconds: 550)),
        ],
      );

      expect(doc.serialize(), '[ar:Artist]\n[00:01.00]First\n[01:05.55]Second');
    });

    test('round-trips through parse', () {
      const source = '[ar:Artist]\n[00:01.00]First line\n[00:05.50]Second line';
      expect(LrcDocument.parse(source).serialize(), source);
    });

    test('serialized output matches server synced-lyrics detection regex', () {
      const doc = LrcDocument(lines: [LrcLine(text: 'Line', time: Duration(seconds: 3))]);
      final serverRegex = RegExp(r'^\s*\[\d{1,2}:\d{2}(?:[.:]\d{1,3})?\]', multiLine: true);

      expect(serverRegex.hasMatch(doc.serialize()), isTrue);
    });
  });

  test('formatLrcTimestamp pads and truncates to centiseconds', () {
    expect(formatLrcTimestamp(Duration.zero), '[00:00.00]');
    expect(formatLrcTimestamp(const Duration(minutes: 2, seconds: 3, milliseconds: 456)), '[02:03.45]');
  });
}
