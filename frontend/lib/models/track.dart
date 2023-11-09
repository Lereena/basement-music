import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/time.dart';

part 'track.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Track extends Equatable {
  final String id;
  final String url;
  final String title;
  final String artist;
  final int duration;
  @JsonKey(fromJson: _coverFromJson)
  final String cover;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    this.url = '',
    this.duration = 111,
    this.cover = 'assets/cover_placeholder.png',
  });

  static String _coverFromJson(String json) =>
      json.isEmpty ? 'assets/cover_placeholder.png' : json;

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  Map<String, dynamic> toJson() => _$TrackToJson(this);

  @override
  List<Object> get props => [id];

  factory Track.empty() => const Track(
        artist: '',
        title: 'No current track',
        id: '',
      );

  String get durationStr => durationString(duration);

  Track copyWith({
    String? title,
    String? artist,
    String? cover,
  }) {
    return Track(
      id: id,
      url: url,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      duration: duration,
      cover: cover ?? this.cover,
    );
  }

  bool matchesQuery(String query) {
    final lcaseQuery = query.toLowerCase();
    final lcaseTitle = title.toLowerCase();
    final lcaseArtist = artist.toLowerCase();

    return lcaseTitle.contains(lcaseQuery) ||
        lcaseArtist.contains(lcaseQuery) ||
        '$lcaseArtist - $lcaseTitle'.contains(lcaseQuery);
  }
}
