part of 'tracks_search_cubit.dart';

@freezed
abstract class TracksSearchState with _$TracksSearchState {
  const factory TracksSearchState.initial() = _Initial;
  const factory TracksSearchState.loadInProgress({required String searchQuery}) = _LoadInProgress;
  const factory TracksSearchState.success({required String searchQuery, required List<Track> tracks}) = _Success;
  const factory TracksSearchState.successEmpty({required String searchQuery}) = _SuccessEmpty;
  const factory TracksSearchState.error() = _Error;
}
