part of 'settings_cubit.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool repeat,
    @Default(false) bool shuffle,
    @Default(ThemeMode.system) ThemeMode themeMode,
  }) = _SettingsState;
}
