// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soulseek_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoulseekSettings _$SoulseekSettingsFromJson(Map<String, dynamic> json) =>
    SoulseekSettings(
      disconnectAfterMinutes: (json['disconnect_after_minutes'] as num).toInt(),
    );

Map<String, dynamic> _$SoulseekSettingsToJson(SoulseekSettings instance) =>
    <String, dynamic>{
      'disconnect_after_minutes': instance.disconnectAfterMinutes,
    };
