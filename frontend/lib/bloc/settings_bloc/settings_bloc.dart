import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../repositories/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc(this.settingsRepository) : super(const SettingsState()) {
    on<RetrieveSettings>(_onRetrieveSettings);
    on<SetShuffle>(_onSetShuffle);
    on<SetRepeat>(_onSetRepeat);
    on<SetThemeMode>(_onSetThemeMode);
  }

  FutureOr<void> _onRetrieveSettings(
    RetrieveSettings event,
    Emitter<SettingsState> emit,
  ) {
    final state = SettingsState(
      repeat: settingsRepository.repeat,
      shuffle: settingsRepository.shuffle,
      themeMode: settingsRepository.themeMode,
    );

    emit(state);
  }

  FutureOr<void> _onSetShuffle(SetShuffle event, Emitter<SettingsState> emit) {
    settingsRepository.shuffle = event.shuffleValue;

    emit(state.copyWith(shuffle: event.shuffleValue));
  }

  FutureOr<void> _onSetRepeat(SetRepeat event, Emitter<SettingsState> emit) {
    settingsRepository.repeat = event.repeatValue;

    emit(state.copyWith(repeat: event.repeatValue));
  }

  FutureOr<void> _onSetThemeMode(
    SetThemeMode event,
    Emitter<SettingsState> emit,
  ) {
    settingsRepository.themeMode = event.themeModeValue;

    emit(state.copyWith(themeMode: event.themeModeValue));
  }
}
