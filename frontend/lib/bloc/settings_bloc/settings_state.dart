part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool repeat;
  final bool shuffle;
  final ThemeMode themeMode;

  const SettingsState({
    this.repeat = false,
    this.shuffle = false,
    this.themeMode = ThemeMode.system,
  });

  @override
  List<Object> get props => [repeat, shuffle, themeMode];

  SettingsState copyWith({
    bool? repeat,
    bool? shuffle,
    ThemeMode? themeMode,
    String? serverAddress,
  }) {
    return SettingsState(
      repeat: repeat ?? this.repeat,
      shuffle: shuffle ?? this.shuffle,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
