import 'package:basement_music/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsCubit(this.settingsRepository) : super(const SettingsState());

  void retrieveSettings() {
    emit(
      SettingsState(
        repeat: settingsRepository.repeat,
        shuffle: settingsRepository.shuffle,
        themeMode: settingsRepository.themeMode,
        homePage: settingsRepository.homePage,
      ),
    );
  }

  void setShuffle(bool value) {
    settingsRepository.shuffle = value;
    emit(state.copyWith(shuffle: value));
  }

  void setRepeat(bool value) {
    settingsRepository.repeat = value;
    emit(state.copyWith(repeat: value));
  }

  void setThemeMode(ThemeMode value) {
    settingsRepository.themeMode = value;
    emit(state.copyWith(themeMode: value));
  }

  void setHomePage(HomePage value) {
    settingsRepository.homePage = value;
    emit(state.copyWith(homePage: value));
  }
}
