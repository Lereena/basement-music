part of 'remove_from_playlist_cubit.dart';

abstract class RemoveFromPlaylistEvent {
  const RemoveFromPlaylistEvent();
}

class TrackChoosen extends RemoveFromPlaylistEvent {
  final String trackId;
  final String? playlistId;

  const TrackChoosen(this.trackId, this.playlistId);
}

class ConfirmationReceived extends RemoveFromPlaylistEvent {
  final String trackId;
  final String? playlistId;

  const ConfirmationReceived(this.trackId, this.playlistId);
}
