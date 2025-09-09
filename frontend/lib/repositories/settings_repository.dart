import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

const _repeatKey = 'repeat_key';
const _shuffleKey = 'shuffle_key';
const _themeModeKey = 'theme_mode_key';

class SettingsRepository {
  final Box<Object> settingsBox;

  SettingsRepository(this.settingsBox) {
    _repeat = settingsBox.get(_repeatKey) as bool? ?? false;
    _shuffle = settingsBox.get(_shuffleKey) as bool? ?? false;
    _themeMode =
        settingsBox.get(_themeModeKey) as ThemeMode? ?? ThemeMode.system;
  }

  bool _repeat = false;
  bool _shuffle = false;
  ThemeMode _themeMode = ThemeMode.system;

  bool get shuffle => _shuffle;

  set shuffle(bool shuffle) {
    _shuffle = shuffle;

    settingsBox.put(_shuffleKey, shuffle);
  }

  bool get repeat => _repeat;

  set repeat(bool repeat) {
    _repeat = repeat;

    settingsBox.put(_repeatKey, repeat);
  }

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;

    settingsBox.put(_themeModeKey, themeMode);
  }
}
