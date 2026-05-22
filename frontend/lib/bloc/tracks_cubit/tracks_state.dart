part of 'tracks_cubit.dart';

@freezed
abstract class TracksState with _$TracksState {
  const factory TracksState.loadInProgress() = _LoadInProgress;
  const factory TracksState.empty() = _Empty;
  const factory TracksState.loaded({required List<Track> tracks}) = _Loaded;
  const factory TracksState.error() = _Error;
}
