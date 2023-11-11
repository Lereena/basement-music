part of 'playlists_bloc.dart';

sealed class PlaylistsEvent {}

final class PlaylistsLoadStarted extends PlaylistsEvent {}

final class PlaylistsUpdated extends PlaylistsEvent {
  final List<Playlist> playlists;

  PlaylistsUpdated(this.playlists);
}
