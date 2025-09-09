part of 'track_to_playlist_adder_bloc.dart';

@immutable
sealed class TrackToPlaylistAdderState extends Equatable {
  const TrackToPlaylistAdderState();

  @override
  List<Object> get props => [];
}

final class TrackToPlaylistAdderPlaylistSelectInProgress
    extends TrackToPlaylistAdderState {
  final List<Playlist> playlists;

  const TrackToPlaylistAdderPlaylistSelectInProgress(this.playlists);
}

final class TrackToPlaylistAdderLoad extends TrackToPlaylistAdderState {}

final class TrackToPlaylistAdderSuccess extends TrackToPlaylistAdderState {}

final class TrackToPlaylistAdderError extends TrackToPlaylistAdderState {}
