part of 'playlist_bloc.dart';

@immutable
sealed class PlaylistState {}

final class PlaylistInitial extends PlaylistState {}

final class PlaylistLoadingState extends PlaylistState {}

final class PlaylistEmptyState extends PlaylistState {
  final String title;

  PlaylistEmptyState({required this.title});
}

final class PlaylistLoadedState extends PlaylistState {
  final Playlist playlist;

  PlaylistLoadedState(this.playlist);
}

final class PlaylistErrorState extends PlaylistState {}
