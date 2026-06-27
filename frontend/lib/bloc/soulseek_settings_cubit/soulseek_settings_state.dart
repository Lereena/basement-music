part of 'soulseek_settings_cubit.dart';

@freezed
abstract class SoulseekSettingsState with _$SoulseekSettingsState {
  const factory SoulseekSettingsState({
    @Default(10) int minutes,
    @Default(false) bool loading,
  }) = _SoulseekSettingsState;
}
