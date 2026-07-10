import 'package:basement_music/models/album.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/models/favourite_type.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/rest_client.dart';

class FavouritesRepository {
  FavouritesRepository(this._restClient, {required String baseUrl}) : _baseUrl = baseUrl;

  final RestClient _restClient;
  final String _baseUrl;

  Future<List<Track>> getFavourites() => _restClient.getFavourites();

  Future<List<Playlist>> getFavouritePlaylists() async {
    final playlists = await _restClient.getFavouritePlaylists();
    return playlists.map(_resolvePlaylistImage).toList();
  }

  Future<List<Artist>> getFavouriteArtists() async {
    final artists = await _restClient.getFavouriteArtists();
    return artists.map(_resolveArtistImage).toList();
  }

  Future<List<Album>> getFavouriteAlbums() async {
    final albums = await _restClient.getFavouriteAlbums();
    return albums.map(_resolveAlbumCover).toList();
  }

  Future<void> addFavourite(FavouriteType type, String id) =>
      _restClient.addFavourite(type.name, id);

  Future<void> removeFavourite(FavouriteType type, String id) =>
      _restClient.removeFavourite(type.name, id);

  Playlist _resolvePlaylistImage(Playlist p) {
    if (p.image == null || p.image!.startsWith('http')) return p;
    return p.copyWith(image: '$_baseUrl${p.image!}');
  }

  Artist _resolveArtistImage(Artist a) => a.copyWith(
    image: imageUrlWithVersion(a.image, _baseUrl, a.updatedAt),
    albums: a.albums?.map(_resolveAlbumCover).toList(),
  );

  Album _resolveAlbumCover(Album a) => a.copyWith(cover: imageUrlWithVersion(a.cover, _baseUrl, a.updatedAt));
}
