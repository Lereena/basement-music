import 'package:json_annotation/json_annotation.dart';

part 'soulseek_status.g.dart';

@JsonSerializable()
class SoulseekStatus {
  final bool connected;
  final String username;

  const SoulseekStatus({required this.connected, required this.username});

  factory SoulseekStatus.fromJson(Map<String, dynamic> json) => _$SoulseekStatusFromJson(json);

  Map<String, dynamic> toJson() => _$SoulseekStatusToJson(this);
}
