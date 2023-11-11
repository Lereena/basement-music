part of 'playlist_bloc.dart';

@immutable
sealed class PlaylistEvent {}

final class PlaylistLoadStarted extends PlaylistEvent {}

final class PlaylistUpdated extends PlaylistEvent {
  final Playlist playlist;

  PlaylistUpdated(this.playlist);
}
