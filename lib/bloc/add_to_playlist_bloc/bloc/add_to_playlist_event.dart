part of 'add_to_playlist_bloc.dart';

abstract class AddToPlaylistEvent extends Equatable {
  const AddToPlaylistEvent();

  @override
  List<Object> get props => [];
}

class TrackChoosen extends AddToPlaylistEvent {
  final String trackId;

  TrackChoosen(this.trackId);
}

class PlaylistChoosen extends AddToPlaylistEvent {
  final String trackId;
  final String playlistId;

  PlaylistChoosen(this.trackId, this.playlistId);
}
