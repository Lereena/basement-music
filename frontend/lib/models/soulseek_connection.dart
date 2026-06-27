import 'package:json_annotation/json_annotation.dart';

part 'soulseek_connection.g.dart';

@JsonSerializable()
class SoulseekConnection {
  final String state;
  final String username;
  final String? reason;

  const SoulseekConnection({
    required this.state,
    required this.username,
    this.reason,
  });

  bool get isConnected => state == 'connected';
  bool get isConnecting => state == 'connecting';
  bool get isFailed => state == 'failed';

  factory SoulseekConnection.fromJson(Map<String, dynamic> json) => _$SoulseekConnectionFromJson(json);

  Map<String, dynamic> toJson() => _$SoulseekConnectionToJson(this);
}
