part of 'track_from_playlist_remover_bloc.dart';

abstract class TrackFromPlaylistRemoverEvent {
  const TrackFromPlaylistRemoverEvent();
}

class TrackFromPlaylistRemoverConfirmed extends TrackFromPlaylistRemoverEvent {
  final String trackId;
  final String? playlistId;

  const TrackFromPlaylistRemoverConfirmed(this.trackId, this.playlistId);
}
