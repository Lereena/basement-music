import 'package:dio/dio.dart';

import 'package:basement_music/models/album.dart';
import 'package:basement_music/models/metadata_candidates.dart';
import 'package:basement_music/rest_client.dart';

class AlbumsRepository {
  final _items = <Album>[];

  final RestClient _restClient;
  final String _baseUrl;

  AlbumsRepository(this._restClient, {required String baseUrl}) : _baseUrl = baseUrl;

  List<Album> get items => _items;

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
    return _resolveCoverUrl(album);
  }

  Future<Album> editAlbum({required String id, required String title, String year = ''}) async {
    final album = await _restClient.editAlbum(id: id, title: title, year: year);
    return _resolveCoverUrl(album);
  }

  Future<void> deleteAlbum(String albumId) => _restClient.deleteAlbum(albumId);

  Future<Album> setAlbumArtists(String albumId, List<String> artistIds) async {
    final album = await _restClient.setAlbumArtists(id: albumId, artistIds: artistIds);
    return _resolveCoverUrl(album);
  }

  Future<Album> setAlbumTracks(String albumId, List<String> trackIds) async {
    final album = await _restClient.setAlbumTracks(id: albumId, trackIds: trackIds);
    return _resolveCoverUrl(album);
  }

  Future<void> setTrackAlbum(String trackId, String albumId) =>
      _restClient.setTrackAlbum(trackId: trackId, albumId: albumId);

  Future<void> updateAlbumImage(String albumId, List<int> bytes, String filename) {
    return _restClient.updateAlbumImage(
      id: albumId,
      image: MultipartFile.fromBytes(bytes, filename: filename),
    );
  }

  Future<List<ReleaseGroupCandidate>> searchCover(String albumId, {String query = ''}) {
    return _restClient.searchAlbumCover(id: albumId, query: query);
  }

  Future<Album> applyCover(String albumId, String mbid) async {
    final album = await _restClient.applyAlbumCover(id: albumId, mbid: mbid);
    return _resolveCoverUrl(album);
  }

  Album _resolveCoverUrl(Album a) {
    if (a.cover == null || a.cover!.startsWith('http')) return a;
    return a.copyWith(cover: '$_baseUrl${a.cover!}');
  }
}
