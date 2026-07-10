import 'package:json_annotation/json_annotation.dart';

part 'metadata_candidates.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class ArtistCandidate {
  final String id;
  final String name;
  final String disambiguation;
  final String type;
  final String country;
  final String begin;

  ArtistCandidate({
    required this.id,
    required this.name,
    this.disambiguation = '',
    this.type = '',
    this.country = '',
    this.begin = '',
  });

  factory ArtistCandidate.fromJson(Map<String, dynamic> json) => _$ArtistCandidateFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistCandidateToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class ArtistMetadataPreview {
  final String? description;
  final String? imageUrl;

  ArtistMetadataPreview({this.description, this.imageUrl});

  factory ArtistMetadataPreview.fromJson(Map<String, dynamic> json) => _$ArtistMetadataPreviewFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistMetadataPreviewToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class ReleaseGroupCandidate {
  final String id;
  final String title;
  final String year;
  final String? coverUrl;

  ReleaseGroupCandidate({required this.id, required this.title, this.year = '', this.coverUrl});

  factory ReleaseGroupCandidate.fromJson(Map<String, dynamic> json) => _$ReleaseGroupCandidateFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseGroupCandidateToJson(this);
}
