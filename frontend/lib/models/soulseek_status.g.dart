// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soulseek_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoulseekStatus _$SoulseekStatusFromJson(Map<String, dynamic> json) =>
    SoulseekStatus(
      connected: json['connected'] as bool,
      username: json['username'] as String,
    );

Map<String, dynamic> _$SoulseekStatusToJson(SoulseekStatus instance) =>
    <String, dynamic>{
      'connected': instance.connected,
      'username': instance.username,
    };
