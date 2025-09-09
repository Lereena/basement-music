part of 'track_from_playlist_remover_bloc.dart';

@immutable
sealed class TrackFromPlaylistRemoverEvent {
  const TrackFromPlaylistRemoverEvent();
}

final class TrackFromPlaylistRemoverConfirmed
    extends TrackFromPlaylistRemoverEvent {
  final String trackId;
  final String? playlistId;

  const TrackFromPlaylistRemoverConfirmed(this.trackId, this.playlistId);
}
