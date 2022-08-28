// ignore_for_file: avoid_positional_boolean_parameters

part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SetShuffle extends SettingsEvent {
  final bool shuffleValue;

  const SetShuffle(this.shuffleValue);
}

class SetRepeat extends SettingsEvent {
  final bool repeatValue;

  const SetRepeat(this.repeatValue);
}

class SetDarkTheme extends SettingsEvent {
  final bool darkThemeValue;

  const SetDarkTheme(this.darkThemeValue);
}

class SetServerAddress extends SettingsEvent {
  final String serverAddressValue;

  const SetServerAddress(this.serverAddressValue);
}
