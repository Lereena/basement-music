part of 'track_artists_setter_cubit.dart';

@freezed
abstract class TrackArtistsSetterState with _$TrackArtistsSetterState {
  const factory TrackArtistsSetterState.loading() = _Loading;
  const factory TrackArtistsSetterState.loaded({required List<Artist> artists}) = _Loaded;
  const factory TrackArtistsSetterState.saving() = _Saving;
  const factory TrackArtistsSetterState.success() = _Success;
  const factory TrackArtistsSetterState.error() = _Error;
}
