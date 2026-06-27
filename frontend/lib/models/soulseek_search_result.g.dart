// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soulseek_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoulseekSearchResult _$SoulseekSearchResultFromJson(
  Map<String, dynamic> json,
) => SoulseekSearchResult(
  peerUsername: json['username'] as String,
  filename: json['filename'] as String,
  extension: json['extension'] as String,
  bitrate: (json['bitrate'] as num).toInt(),
  size: (json['size'] as num).toInt(),
  freeSlots: json['free_slots'] as bool,
  speed: (json['speed'] as num).toInt(),
);

Map<String, dynamic> _$SoulseekSearchResultToJson(
  SoulseekSearchResult instance,
) => <String, dynamic>{
  'username': instance.peerUsername,
  'filename': instance.filename,
  'extension': instance.extension,
  'bitrate': instance.bitrate,
  'size': instance.size,
  'free_slots': instance.freeSlots,
  'speed': instance.speed,
};
