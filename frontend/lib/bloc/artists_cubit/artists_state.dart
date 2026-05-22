part of 'artists_cubit.dart';

@freezed
abstract class ArtistsState with _$ArtistsState {
  const factory ArtistsState.initial() = _Initial;
  const factory ArtistsState.loading() = _Loading;
  const factory ArtistsState.empty() = _Empty;
  const factory ArtistsState.loaded({required List<Artist> artists}) = _Loaded;
  const factory ArtistsState.error({required String message}) = _Error;
}
