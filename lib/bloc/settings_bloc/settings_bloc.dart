import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SetShuffle>(_onSetShuffle);
    on<SetRepeat>(_onSetRepeat);
    on<SetDarkTheme>(_onSetDarkTheme);
  }

  FutureOr<void> _onSetShuffle(SetShuffle event, Emitter<SettingsState> emit) {
    emit(
      SettingsState(
        repeat: state.repeat,
        shuffle: event.shuffleValue,
        darkTheme: state.darkTheme,
      ),
    );
  }

  FutureOr<void> _onSetRepeat(SetRepeat event, Emitter<SettingsState> emit) {
    emit(
      SettingsState(
        repeat: event.repeatValue,
        shuffle: state.shuffle,
        darkTheme: state.darkTheme,
      ),
    );
  }

  FutureOr<void> _onSetDarkTheme(SetDarkTheme event, Emitter<SettingsState> emit) {
    emit(
      SettingsState(
        repeat: state.repeat,
        shuffle: state.shuffle,
        darkTheme: event.darkThemeValue,
      ),
    );
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState.fromJson(json['settings']);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return {'settings': state.toJson()};
  }
}
