import 'package:collection/collection.dart';

import '../api_providers/playlists_api_provider.dart';
import '../api_service.dart';
import '../models/playlist.dart';

class PlaylistsRepository {
  final ApiService _apiService;
  final _items = <Playlist>[];
  late final _playlistsApiProvider = PlaylistsApiProvider(_apiService);

  PlaylistsRepository(this._apiService);

  List<Playlist> get items => _items;

  Future<bool> getAllPlaylists() async {
    final result = await _playlistsApiProvider.fetchAllPlaylists();
    _items.clear();
    _items.addAll(result);

    return true;
  }

  Future<Playlist> getPlaylist(
    String playlistId, {
    bool useCache = true,
  }) async {
    Playlist? playlist;

    if (useCache) {
      playlist = items.firstWhereOrNull((item) => item.id == playlistId);
    }

    if (playlist == null) {
      return _playlistsApiProvider.getPlaylist(playlistId);
    }

    return playlist;
  }

  Future<bool> createPlaylist(String title) async {
    final result = await _playlistsApiProvider.createPlaylist(title);
    _items.add(result);
    return true;
  }

  Future<bool> editPlaylist({
    required String id,
    required String title,
    required List<String> tracksIds,
  }) async {
    final result = await _playlistsApiProvider.editPlaylist(
      id: id,
      title: title,
      tracksIds: tracksIds,
    );

    return result;
  }

  Future<bool> deletePlaylist(String playlistId) async {
    final result = await _playlistsApiProvider.deletePlaylist(playlistId);
    if (result) {
      _items.removeWhere((element) => element.id == playlistId);
    }
    return result;
  }

  Future<bool> addTrackToPlaylist(String playlistId, String trackId) async {
    return _playlistsApiProvider.addTrackToPlaylist(playlistId, trackId);
  }

  Future<bool> removeTrackFromPlaylist(
    String playlistId,
    String trackId,
  ) async {
    return _playlistsApiProvider.removeTrackFromPlaylist(playlistId, trackId);
  }
}
