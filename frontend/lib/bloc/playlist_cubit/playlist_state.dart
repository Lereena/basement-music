part of 'playlist_cubit.dart';

@freezed
abstract class PlaylistState with _$PlaylistState {
  const factory PlaylistState.initial() = _Initial;
  const factory PlaylistState.loadInProgress() = _LoadInProgress;
  const factory PlaylistState.loadedEmpty({required String title}) = _LoadedEmpty;
  const factory PlaylistState.loaded({required Playlist playlist}) = _Loaded;
  const factory PlaylistState.error() = _Error;
}
