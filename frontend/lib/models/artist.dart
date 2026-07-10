import 'package:json_annotation/json_annotation.dart';

import 'package:basement_music/models/album.dart';
import 'package:basement_music/models/track.dart';

part 'artist.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Artist {
  final String id;
  final String name;
  final String? image;
  final String? description;
  final List<Track>? tracks;
  final List<Album>? albums;

  Artist({
    required this.id,
    required this.name,
    required this.image,
    this.description,
    this.tracks,
    this.albums,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistToJson(this);

  Artist copyWith({String? name, String? image, String? description, List<Track>? tracks, List<Album>? albums}) {
    return Artist(
      id: id,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      tracks: tracks ?? this.tracks,
      albums: albums ?? this.albums,
    );
  }
}
