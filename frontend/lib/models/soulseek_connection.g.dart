// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soulseek_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoulseekConnection _$SoulseekConnectionFromJson(Map<String, dynamic> json) =>
    SoulseekConnection(
      state: json['state'] as String,
      username: json['username'] as String,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$SoulseekConnectionToJson(SoulseekConnection instance) =>
    <String, dynamic>{
      'state': instance.state,
      'username': instance.username,
      'reason': instance.reason,
    };
