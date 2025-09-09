part of 'player_bloc.dart';

@immutable
sealed class PlayerEvent {}

final class PlayerPlayStarted extends PlayerEvent {
  final Track track;
  final Playlist? playlist;

  PlayerPlayStarted({required this.track, this.playlist});
}

final class PlayerPaused extends PlayerEvent {}

final class PlayerPausedExternally extends PlayerEvent {}

final class PlayerPlayedByExternalControls extends PlayerEvent {}

final class PlayerPlayedByShortcut extends PlayerEvent {}

final class PlayerPreviousStarted extends PlayerEvent {}

final class PlayerNextStarted extends PlayerEvent {}

final class PlayerTracksUpdated extends PlayerEvent {
  final Track track;

  PlayerTracksUpdated(this.track);
}
