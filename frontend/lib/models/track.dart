import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:basement_music/utils/time.dart';

part 'track.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Track extends Equatable {
  final String id;
  final String url;
  final String title;
  final String artist;
  final int duration;

  /// Raw server path ('/api/track/{id}/cover' or '/api/album/{id}/image'),
  /// an asset path, or empty. Resolved to a displayable image by [Cover].
  final String cover;
  final bool hasLyrics;
  final String? albumId;

  /// Bumped by the server when the cover bytes change — used to bust image caches.
  final String? updatedAt;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    this.url = '',
    this.duration = 111,
    this.cover = '',
    this.hasLyrics = false,
    this.albumId,
    this.updatedAt,
  });

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
    bool? hasLyrics,
    String? albumId,
    String? updatedAt,
  }) {
    return Track(
      id: id,
      url: url,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      duration: duration,
      cover: cover ?? this.cover,
      hasLyrics: hasLyrics ?? this.hasLyrics,
      albumId: albumId ?? this.albumId,
      updatedAt: updatedAt ?? this.updatedAt,
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
