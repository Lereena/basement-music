// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
  id: json['Id'] as String,
  title: json['Title'] as String,
  year: (json['Year'] as num?)?.toInt(),
  cover: json['Cover'] as String?,
  artists: (json['Artists'] as List<dynamic>?)
      ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
      .toList(),
  tracks:
      (json['Tracks'] as List<dynamic>?)
          ?.map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
  'Id': instance.id,
  'Title': instance.title,
  'Year': instance.year,
  'Cover': instance.cover,
  'Artists': instance.artists,
  'Tracks': instance.tracks,
};
