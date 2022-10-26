part of 'add_to_playlist_bloc.dart';

abstract class AddToPlaylistEvent extends Equatable {
  const AddToPlaylistEvent();

  @override
  List<Object> get props => [];
}

class TrackChoosen extends AddToPlaylistEvent {
  final String trackId;

  const TrackChoosen(this.trackId);
}

class PlaylistChoosen extends AddToPlaylistEvent {
  final String trackId;
  final String playlistId;

  const PlaylistChoosen(this.trackId, this.playlistId);
}
