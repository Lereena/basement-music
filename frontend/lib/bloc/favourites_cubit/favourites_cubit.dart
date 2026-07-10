import 'package:basement_music/models/album.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/models/favourite_type.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/favourites_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favourites_cubit.freezed.dart';
part 'favourites_state.dart';

class FavouritesCubit extends Cubit<FavouritesState> {
  FavouritesCubit(this._repo) : super(const FavouritesState.initial());

  final FavouritesRepository _repo;

  Future<void> loadFavourites() async {
    emit(const FavouritesState.loadInProgress());
    await _refresh();
  }

  Future<void> _refresh() async {
    try {
      final (tracks, playlists, artists, albums) = await (
        _repo.getFavourites(),
        _repo.getFavouritePlaylists(),
        _repo.getFavouriteArtists(),
        _repo.getFavouriteAlbums(),
      ).wait;
      emit(FavouritesState.loaded(tracks: tracks, playlists: playlists, artists: artists, albums: albums));
    } catch (_) {
      emit(const FavouritesState.error());
    }
  }

  bool isFavourite(String trackId) => state.maybeWhen(
    loaded: (tracks, _, _, _) => tracks.any((t) => t.id == trackId),
    orElse: () => false,
  );

  bool isFavouritePlaylist(String id) => state.maybeWhen(
    loaded: (_, playlists, _, _) => playlists.any((p) => p.id == id),
    orElse: () => false,
  );

  bool isFavouriteArtist(String id) => state.maybeWhen(
    loaded: (_, _, artists, _) => artists.any((a) => a.id == id),
    orElse: () => false,
  );

  bool isFavouriteAlbum(String id) => state.maybeWhen(
    loaded: (_, _, _, albums) => albums.any((a) => a.id == id),
    orElse: () => false,
  );

  Future<void> toggleFavourite(String trackId) =>
      _toggle(FavouriteType.track, trackId, isFavourite(trackId));

  Future<void> toggleFavouritePlaylist(String id) =>
      _toggle(FavouriteType.playlist, id, isFavouritePlaylist(id));

  Future<void> toggleFavouriteArtist(String id) =>
      _toggle(FavouriteType.artist, id, isFavouriteArtist(id));

  Future<void> toggleFavouriteAlbum(String id) =>
      _toggle(FavouriteType.album, id, isFavouriteAlbum(id));

  Future<void> _toggle(FavouriteType type, String id, bool isFavourite) async {
    if (isFavourite) {
      await _repo.removeFavourite(type, id);
    } else {
      await _repo.addFavourite(type, id);
    }
    await _refresh();
  }
}
