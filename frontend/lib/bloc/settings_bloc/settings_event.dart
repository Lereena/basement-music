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

class SetThemeMode extends SettingsEvent {
  final ThemeMode themeModeValue;

  const SetThemeMode(this.themeModeValue);
}
