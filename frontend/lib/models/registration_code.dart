import 'package:json_annotation/json_annotation.dart';

part 'registration_code.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RegistrationCode {
  final int id;
  final String code;
  final String? usedByEmail;
  final DateTime createdAt;

  const RegistrationCode({required this.id, required this.code, this.usedByEmail, required this.createdAt});

  bool get isUsed => usedByEmail != null;

  factory RegistrationCode.fromJson(Map<String, dynamic> json) => _$RegistrationCodeFromJson(json);
  Map<String, dynamic> toJson() => _$RegistrationCodeToJson(this);
}
