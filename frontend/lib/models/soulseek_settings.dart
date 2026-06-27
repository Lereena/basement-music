import 'package:json_annotation/json_annotation.dart';

part 'soulseek_settings.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SoulseekSettings {
  final int disconnectAfterMinutes;

  const SoulseekSettings({required this.disconnectAfterMinutes});

  factory SoulseekSettings.fromJson(Map<String, dynamic> json) => _$SoulseekSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SoulseekSettingsToJson(this);
}
