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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'repeat': repeat,
      'shuffle': shuffle,
      'darkTheme': themeMode.name,
    };
  }

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      repeat: map['repeat'] as bool,
      shuffle: map['shuffle'] as bool,
      themeMode: map['darkTheme'] as ThemeMode,
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsState.fromJson(String source) =>
      SettingsState.fromMap(json.decode(source) as Map<String, dynamic>);

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
