part of 'playlist_bloc.dart';

@immutable
sealed class PlaylistEvent {}

class PlaylistLoadStarted extends PlaylistEvent {}

class PlaylistUpdated extends PlaylistEvent {
  final Playlist playlist;

  PlaylistUpdated(this.playlist);
}
