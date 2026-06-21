import 'package:basement_music/bloc/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

const _repeatKey = 'repeat_key';
const _shuffleKey = 'shuffle_key';
const _themeModeKey = 'theme_mode_key';
const _homePageKey = 'home_page_key';

class SettingsRepository {
  final Box<Object> settingsBox;

  SettingsRepository(this.settingsBox) {
    _repeat = settingsBox.get(_repeatKey) as bool? ?? false;
    _shuffle = settingsBox.get(_shuffleKey) as bool? ?? false;
    _themeMode =
        settingsBox.get(_themeModeKey) as ThemeMode? ?? ThemeMode.system;
    _homePage = HomePage.values[settingsBox.get(_homePageKey) as int? ?? 0];
  }

  bool _repeat = false;
  bool _shuffle = false;
  ThemeMode _themeMode = ThemeMode.system;
  HomePage _homePage = HomePage.allTracks;

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

  HomePage get homePage => _homePage;

  set homePage(HomePage homePage) {
    _homePage = homePage;

    settingsBox.put(_homePageKey, homePage.index);
  }
}
