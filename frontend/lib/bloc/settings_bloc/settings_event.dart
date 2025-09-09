part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

final class RetrieveSettings extends SettingsEvent {}

final class SetShuffle extends SettingsEvent {
  final bool shuffleValue;

  const SetShuffle(this.shuffleValue);
}

final class SetRepeat extends SettingsEvent {
  final bool repeatValue;

  const SetRepeat(this.repeatValue);
}

final class SetThemeMode extends SettingsEvent {
  final ThemeMode themeModeValue;

  const SetThemeMode(this.themeModeValue);
}
