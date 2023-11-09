part of 'playlist_bloc.dart';

@immutable
sealed class PlaylistState extends Equatable {
  @override
  List<Object> get props => [];
}

final class PlaylistInitial extends PlaylistState {}

final class PlaylistLoadingState extends PlaylistState {}

final class PlaylistEmptyState extends PlaylistState {
  final String title;

  PlaylistEmptyState({required this.title});
}

final class PlaylistLoadedState extends PlaylistState {
  final Playlist playlist;

  PlaylistLoadedState(this.playlist);

  @override
  List<Object> get props => playlist.props;
}

final class PlaylistErrorState extends PlaylistState {}
