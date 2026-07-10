part of 'favourites_cubit.dart';

@freezed
abstract class FavouritesState with _$FavouritesState {
  const factory FavouritesState.initial() = _Initial;
  const factory FavouritesState.loadInProgress() = _LoadInProgress;
  const factory FavouritesState.loaded({
    required List<Track> tracks,
    required List<Playlist> playlists,
    required List<Artist> artists,
    required List<Album> albums,
  }) = _Loaded;
  const factory FavouritesState.error() = _Error;
}
