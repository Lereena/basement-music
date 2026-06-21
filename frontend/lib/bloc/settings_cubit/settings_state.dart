part of 'settings_cubit.dart';

enum HomePage { allTracks, favourites }

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool repeat,
    @Default(false) bool shuffle,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(HomePage.allTracks) HomePage homePage,
  }) = _SettingsState;
}
