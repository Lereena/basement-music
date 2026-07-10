part of 'album_cubit.dart';

@freezed
abstract class AlbumState with _$AlbumState {
  const factory AlbumState.initial() = _Initial;
  const factory AlbumState.loading() = _Loading;
  const factory AlbumState.loaded({required Album album}) = _Loaded;
  const factory AlbumState.error() = _Error;
}
