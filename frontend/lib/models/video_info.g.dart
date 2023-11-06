// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoInfo _$VideoInfoFromJson(Map<String, dynamic> json) => VideoInfo(
      artist: VideoInfo._urlDecode(json['artist'] as String),
      title: VideoInfo._urlDecode(json['title'] as String),
    );

Map<String, dynamic> _$VideoInfoToJson(VideoInfo instance) => <String, dynamic>{
      'artist': instance.artist,
      'title': instance.title,
    };
