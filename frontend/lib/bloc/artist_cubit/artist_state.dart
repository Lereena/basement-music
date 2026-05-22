part of 'artist_cubit.dart';

@freezed
abstract class ArtistState with _$ArtistState {
  const factory ArtistState.initial() = _Initial;
  const factory ArtistState.loadInProgress() = _LoadInProgress;
  const factory ArtistState.loaded({required Artist artist}) = _Loaded;
  const factory ArtistState.loadedEmpty({required String name}) = _LoadedEmpty;
  const factory ArtistState.error() = _Error;
}
