part of 'playlists_cubit.dart';

@freezed
abstract class PlaylistsState with _$PlaylistsState {
  const factory PlaylistsState.loading() = _Loading;
  const factory PlaylistsState.empty() = _Empty;
  const factory PlaylistsState.loaded({required List<Playlist> playlists}) = _Loaded;
  const factory PlaylistsState.error() = _Error;
}
