part of 'player_bloc.dart';

@immutable
sealed class PlayerState {
  final Track currentTrack;

  const PlayerState(this.currentTrack);
}

final class PlayerInitial extends PlayerState {
  const PlayerInitial(super.currentTrack);
}

final class PlayerPlay extends PlayerState {
  const PlayerPlay(super.currentTrack);
}

final class PlayerPause extends PlayerState {
  const PlayerPause(super.currentTrack);
}
