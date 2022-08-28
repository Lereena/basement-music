import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../api_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  final ApiService apiService;

  SettingsBloc(this.apiService) : super(const SettingsState()) {
    on<SetShuffle>(_onSetShuffle);
    on<SetRepeat>(_onSetRepeat);
    on<SetDarkTheme>(_onSetDarkTheme);
    on<SetServerAddress>(_onSetServerAddress);
    apiService.setHost(state.serverAddress);
  }

  FutureOr<void> _onSetShuffle(SetShuffle event, Emitter<SettingsState> emit) {
    emit(state.copyWith(shuffle: event.shuffleValue));
  }

  FutureOr<void> _onSetRepeat(SetRepeat event, Emitter<SettingsState> emit) {
    emit(state.copyWith(repeat: event.repeatValue));
  }

  FutureOr<void> _onSetDarkTheme(SetDarkTheme event, Emitter<SettingsState> emit) {
    emit(state.copyWith(darkTheme: event.darkThemeValue));
  }

  FutureOr<void> _onSetServerAddress(SetServerAddress event, Emitter<SettingsState> emit) {
    apiService.setHost(state.serverAddress);
    emit(state.copyWith(serverAddress: event.serverAddressValue));
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
