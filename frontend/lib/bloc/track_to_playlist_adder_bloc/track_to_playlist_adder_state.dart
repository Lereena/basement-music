part of 'track_to_playlist_adder_bloc.dart';

abstract class TrackToPlaylistAdderState extends Equatable {
  const TrackToPlaylistAdderState();

  @override
  List<Object> get props => [];
}

class TrackToPlaylistAdderPlaylistSelectInProgress
    extends TrackToPlaylistAdderState {
  final List<Playlist> playlists;

  const TrackToPlaylistAdderPlaylistSelectInProgress(this.playlists);
}

class TrackToPlaylistAdderLoad extends TrackToPlaylistAdderState {}

class TrackToPlaylistAdderSuccess extends TrackToPlaylistAdderState {}

class TrackToPlaylistAdderError extends TrackToPlaylistAdderState {}
