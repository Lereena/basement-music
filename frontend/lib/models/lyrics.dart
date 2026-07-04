import 'package:json_annotation/json_annotation.dart';

part 'lyrics.g.dart';

@JsonSerializable(createToJson: false)
class Lyrics {
  final int id;
  final String trackName;
  final String artistName;
  final bool instrumental;
  final double? duration;
  final String? plainLyrics;
  final String? syncedLyrics;

  const Lyrics({
    required this.id,
    required this.trackName,
    required this.artistName,
    this.instrumental = false,
    this.duration,
    this.plainLyrics,
    this.syncedLyrics,
  });

  factory Lyrics.fromJson(Map<String, dynamic> json) => _$LyricsFromJson(json);

  // lrclib may return "" instead of null for missing lyrics.
  bool get hasSynced => syncedLyrics?.trim().isNotEmpty ?? false;

  bool get hasPlain => plainLyrics?.trim().isNotEmpty ?? false;

  bool get isEmpty => !hasSynced && !hasPlain && !instrumental;
}
