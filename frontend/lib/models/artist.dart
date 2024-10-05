import 'package:json_annotation/json_annotation.dart';

import 'track.dart';

part 'artist.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Artist {
  final String id;
  final String name;
  final String image;
  final List<Track>? tracks;

  Artist({required this.id, required this.name, required this.image, this.tracks});

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}
