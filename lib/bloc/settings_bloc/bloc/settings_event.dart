part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SetShuffle extends SettingsEvent {
  final bool shuffleValue;

  SetShuffle(this.shuffleValue);
}

class SetRepeat extends SettingsEvent {
  final bool repeatValue;

  SetRepeat(this.repeatValue);
}

class SetDarkTheme extends SettingsEvent {
  final bool darkThemeValue;

  SetDarkTheme(this.darkThemeValue);
}
