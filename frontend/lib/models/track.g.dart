// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) => Track(
      id: json['Id'] as String,
      title: json['Title'] as String,
      artist: json['Artist'] as String,
      url: json['Url'] as String? ?? '',
      duration: json['Duration'] as int? ?? 111,
      cover: json['Cover'] == null
          ? 'assets/cover_placeholder.png'
          : Track._coverFromJson(json['Cover'] as String),
    );

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
      'Id': instance.id,
      'Url': instance.url,
      'Title': instance.title,
      'Artist': instance.artist,
      'Duration': instance.duration,
      'Cover': instance.cover,
    };
