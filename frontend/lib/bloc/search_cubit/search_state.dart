part of 'search_cubit.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.loadInProgress({required String query}) = _LoadInProgress;
  const factory SearchState.success({
    required String query,
    required List<Artist> artists,
    required List<Playlist> playlists,
    required List<Track> tracks,
  }) = _Success;
  const factory SearchState.successEmpty({required String query}) = _SuccessEmpty;
  const factory SearchState.error() = _Error;
}
