part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool repeat;
  final bool shuffle;
  final bool darkTheme;

  const SettingsState({
    this.repeat = false,
    this.shuffle = false,
    this.darkTheme = false,
  });

  @override
  List<Object> get props => [repeat, shuffle, darkTheme];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'repeat': repeat,
      'shuffle': shuffle,
      'darkTheme': darkTheme,
    };
  }

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      repeat: map['repeat'] as bool,
      shuffle: map['shuffle'] as bool,
      darkTheme: map['darkTheme'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsState.fromJson(String source) =>
      SettingsState.fromMap(json.decode(source) as Map<String, dynamic>);

  SettingsState copyWith({
    bool? repeat,
    bool? shuffle,
    bool? darkTheme,
    String? serverAddress,
  }) {
    return SettingsState(
      repeat: repeat ?? this.repeat,
      shuffle: shuffle ?? this.shuffle,
      darkTheme: darkTheme ?? this.darkTheme,
    );
  }
}
