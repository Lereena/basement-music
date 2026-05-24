// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationCode _$RegistrationCodeFromJson(Map<String, dynamic> json) =>
    RegistrationCode(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      usedByEmail: json['used_by_email'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$RegistrationCodeToJson(RegistrationCode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'used_by_email': instance.usedByEmail,
      'created_at': instance.createdAt.toIso8601String(),
    };
