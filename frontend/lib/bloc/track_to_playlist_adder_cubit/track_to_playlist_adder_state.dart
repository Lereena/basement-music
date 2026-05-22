part of 'track_to_playlist_adder_cubit.dart';

@freezed
abstract class TrackToPlaylistAdderState with _$TrackToPlaylistAdderState {
  const factory TrackToPlaylistAdderState.selectInProgress({required List<Playlist> playlists}) = _SelectInProgress;
  const factory TrackToPlaylistAdderState.loading() = _Loading;
  const factory TrackToPlaylistAdderState.success() = _Success;
  const factory TrackToPlaylistAdderState.error() = _Error;
}
