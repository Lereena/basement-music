import 'package:basement_music/models/playlist.dart';

abstract class PlaylistsState {}

class PlaylistsEmptyState extends PlaylistsState {}

class PlaylistsLoadingState extends PlaylistsState {}

class PlaylistsLoadedState extends PlaylistsState {
  final List<Playlist> playlists;

  PlaylistsLoadedState(this.playlists);
}

class PlaylistsErrorState extends PlaylistsState {}
