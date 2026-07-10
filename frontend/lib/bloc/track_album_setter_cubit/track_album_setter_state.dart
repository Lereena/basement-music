part of 'track_album_setter_cubit.dart';

@freezed
abstract class TrackAlbumSetterState with _$TrackAlbumSetterState {
  const factory TrackAlbumSetterState.loading() = _Loading;
  const factory TrackAlbumSetterState.selectInProgress({required List<Album> albums}) = _SelectInProgress;
  const factory TrackAlbumSetterState.success() = _Success;
  const factory TrackAlbumSetterState.error() = _Error;
}
