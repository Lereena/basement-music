// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soulseek_temp_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoulseekTempTrack _$SoulseekTempTrackFromJson(Map<String, dynamic> json) =>
    SoulseekTempTrack(
      id: json['id'] as String,
      artist: json['artist'] as String,
      title: json['title'] as String,
      duration: (json['duration'] as num).toInt(),
    );

Map<String, dynamic> _$SoulseekTempTrackToJson(SoulseekTempTrack instance) =>
    <String, dynamic>{
      'id': instance.id,
      'artist': instance.artist,
      'title': instance.title,
      'duration': instance.duration,
    };
