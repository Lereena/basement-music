import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:basement_music/models/artist.dart';
import 'package:basement_music/models/track.dart';

part 'album.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Album extends Equatable {
  final String id;
  final String title;
  final int? year;
  final String? cover;
  final String? updatedAt;
  final List<Artist>? artists;
  @JsonKey(defaultValue: [])
  final List<Track> tracks;

  const Album({
    required this.id,
    required this.title,
    this.year,
    this.cover,
    this.updatedAt,
    this.artists,
    this.tracks = const [],
  });

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);

  @override
  List<Object?> get props => [id, title, year, cover, updatedAt, artists, tracks];

  Album copyWith({
    String? title,
    int? year,
    String? cover,
    String? updatedAt,
    List<Artist>? artists,
    List<Track>? tracks,
  }) {
    return Album(
      id: id,
      title: title ?? this.title,
      year: year ?? this.year,
      cover: cover ?? this.cover,
      updatedAt: updatedAt ?? this.updatedAt,
      artists: artists ?? this.artists,
      tracks: tracks ?? this.tracks,
    );
  }
}
