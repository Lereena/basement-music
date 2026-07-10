// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
  id: json['Id'] as String,
  name: json['Name'] as String,
  image: json['Image'] as String?,
  description: json['Description'] as String?,
  tracks: (json['Tracks'] as List<dynamic>?)
      ?.map((e) => Track.fromJson(e as Map<String, dynamic>))
      .toList(),
  albums: (json['Albums'] as List<dynamic>?)
      ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
  'Id': instance.id,
  'Name': instance.name,
  'Image': instance.image,
  'Description': instance.description,
  'Tracks': instance.tracks,
  'Albums': instance.albums,
};
