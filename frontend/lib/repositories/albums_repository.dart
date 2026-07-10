import 'package:dio/dio.dart';

import 'package:basement_music/models/album.dart';
import 'package:basement_music/models/metadata_candidates.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/rest_client.dart';

class AlbumsRepository {
  final _items = <Album>[];

  final RestClient _restClient;
  final String _baseUrl;
  final ArtistsRepository _artistsRepository;

  AlbumsRepository(this._restClient, {required String baseUrl, required ArtistsRepository artistsRepository})
    : _baseUrl = baseUrl,
      _artistsRepository = artistsRepository;

  List<Album> get items => _items;

  // Refresh the artist list after an album mutation so any artist view showing
  // this album (album strip, counts) reflects the change via artistsSubject.
  Future<void> _refreshArtists() => _artistsRepository.getAllArtists();

  Future<List<Album>> getAllAlbums() async {
    final result = await _restClient.getAllAlbums();
    _items.clear();
    _items.addAll(result.map(_resolveCoverUrl));
    return _items;
  }

  Future<Album> getAlbum(String albumId) async {
    final album = await _restClient.getAlbum(albumId);
    return _resolveCoverUrl(album);
  }

  Future<Album> createAlbum(String title, List<String> artistIds) async {
    final album = await _restClient.createAlbum(title: title, artistIds: artistIds);
    await _refreshArtists();
    return _resolveCoverUrl(album);
  }

  Future<Album> editAlbum({required String id, required String title, String year = ''}) async {
    final album = await _restClient.editAlbum(id: id, title: title, year: year);
    await _refreshArtists();
    return _resolveCoverUrl(album);
  }

  Future<void> deleteAlbum(String albumId) async {
    await _restClient.deleteAlbum(albumId);
    await _refreshArtists();
  }

  Future<Album> setAlbumArtists(String albumId, List<String> artistIds) async {
    final album = await _restClient.setAlbumArtists(id: albumId, artistIds: artistIds);
    await _refreshArtists();
    return _resolveCoverUrl(album);
  }

  Future<Album> setAlbumTracks(String albumId, List<String> trackIds) async {
    final album = await _restClient.setAlbumTracks(id: albumId, trackIds: trackIds);
    return _resolveCoverUrl(album);
  }

  Future<void> setTrackAlbum(String trackId, String albumId) =>
      _restClient.setTrackAlbum(trackId: trackId, albumId: albumId);

  Future<void> updateAlbumImage(String albumId, List<int> bytes, String filename) async {
    await _restClient.updateAlbumImage(
      id: albumId,
      image: MultipartFile.fromBytes(bytes, filename: filename),
    );
    await _refreshArtists();
  }

  Future<List<ReleaseGroupCandidate>> searchCover(String albumId, {String query = ''}) {
    return _restClient.searchAlbumCover(id: albumId, query: query);
  }

  Future<Album> applyCover(String albumId, String mbid) async {
    final album = await _restClient.applyAlbumCover(id: albumId, mbid: mbid);
    await _refreshArtists();
    return _resolveCoverUrl(album);
  }

  Album _resolveCoverUrl(Album a) => a.copyWith(cover: imageUrlWithVersion(a.cover, _baseUrl, a.updatedAt));
}
