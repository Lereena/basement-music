part of 'playlist_bloc.dart';

@immutable
sealed class PlaylistEvent {}

class PlaylistLoadEvent extends PlaylistEvent {
  final String playlistId;

  PlaylistLoadEvent(this.playlistId);
}

class PlaylistsUpdatedEvent extends PlaylistEvent {}
