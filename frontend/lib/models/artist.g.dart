// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      id: json['Id'] as String,
      name: json['Name'] as String,
      image: json['Image'] as String?,
      tracks: (json['Tracks'] as List<dynamic>?)
          ?.map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Image': instance.image,
      'Tracks': instance.tracks,
    };
