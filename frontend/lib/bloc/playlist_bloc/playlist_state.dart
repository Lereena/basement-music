part of 'playlist_bloc.dart';

@immutable
sealed class PlaylistState extends Equatable {
  @override
  List<Object> get props => [];
}

final class PlaylistInitial extends PlaylistState {}

final class PlaylistLoadInProgress extends PlaylistState {}

final class PlaylistLoadedEmpty extends PlaylistState {
  final String title;

  PlaylistLoadedEmpty({required this.title});
}

final class PlaylistLoaded extends PlaylistState {
  final Playlist playlist;

  PlaylistLoaded(this.playlist);

  @override
  List<Object> get props => playlist.props;
}

final class PlaylistError extends PlaylistState {}
