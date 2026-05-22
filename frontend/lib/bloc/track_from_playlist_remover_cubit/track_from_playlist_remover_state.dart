part of 'track_from_playlist_remover_cubit.dart';

@freezed
abstract class TrackFromPlaylistRemoverState
    with _$TrackFromPlaylistRemoverState {
  const factory TrackFromPlaylistRemoverState.initial() = _Initial;
  const factory TrackFromPlaylistRemoverState.loadInProgress() = _LoadInProgress;
  const factory TrackFromPlaylistRemoverState.success() = _Success;
  const factory TrackFromPlaylistRemoverState.error() = _Error;
}
