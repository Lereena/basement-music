import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AppUser {
  final int id;
  final String firebaseUid;
  final String email;
  final String role;

  const AppUser({required this.id, required this.firebaseUid, required this.email, required this.role});

  bool get isAdmin => role == 'admin';

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
