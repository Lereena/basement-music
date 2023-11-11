part of 'player_bloc.dart';

sealed class PlayerState {
  final Track currentTrack;

  PlayerState(this.currentTrack);
}

final class PlayerInitial extends PlayerState {
  PlayerInitial(super.currentTrack);
}

final class PlayerPlay extends PlayerState {
  PlayerPlay(super.currentTrack);
}

final class PlayerPause extends PlayerState {
  PlayerPause(super.currentTrack);
}

final class PlayerResume extends PlayerState {
  PlayerResume(super.currentTrack);
}
