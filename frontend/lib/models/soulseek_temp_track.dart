import 'package:json_annotation/json_annotation.dart';

part 'soulseek_temp_track.g.dart';

@JsonSerializable()
class SoulseekTempTrack {
  final String id;
  final String artist;
  final String title;
  final int duration;

  const SoulseekTempTrack({
    required this.id,
    required this.artist,
    required this.title,
    required this.duration,
  });

  factory SoulseekTempTrack.fromJson(Map<String, dynamic> json) => _$SoulseekTempTrackFromJson(json);

  Map<String, dynamic> toJson() => _$SoulseekTempTrackToJson(this);
}
