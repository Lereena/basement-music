// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_candidates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistCandidate _$ArtistCandidateFromJson(Map<String, dynamic> json) =>
    ArtistCandidate(
      id: json['Id'] as String,
      name: json['Name'] as String,
      disambiguation: json['Disambiguation'] as String? ?? '',
      type: json['Type'] as String? ?? '',
      country: json['Country'] as String? ?? '',
      begin: json['Begin'] as String? ?? '',
    );

Map<String, dynamic> _$ArtistCandidateToJson(ArtistCandidate instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Disambiguation': instance.disambiguation,
      'Type': instance.type,
      'Country': instance.country,
      'Begin': instance.begin,
    };

ArtistMetadataPreview _$ArtistMetadataPreviewFromJson(
  Map<String, dynamic> json,
) => ArtistMetadataPreview(
  description: json['Description'] as String?,
  imageUrl: json['ImageUrl'] as String?,
);

Map<String, dynamic> _$ArtistMetadataPreviewToJson(
  ArtistMetadataPreview instance,
) => <String, dynamic>{
  'Description': instance.description,
  'ImageUrl': instance.imageUrl,
};

ReleaseGroupCandidate _$ReleaseGroupCandidateFromJson(
  Map<String, dynamic> json,
) => ReleaseGroupCandidate(
  id: json['Id'] as String,
  title: json['Title'] as String,
  year: json['Year'] as String? ?? '',
  coverUrl: json['CoverUrl'] as String?,
);

Map<String, dynamic> _$ReleaseGroupCandidateToJson(
  ReleaseGroupCandidate instance,
) => <String, dynamic>{
  'Id': instance.id,
  'Title': instance.title,
  'Year': instance.year,
  'CoverUrl': instance.coverUrl,
};
