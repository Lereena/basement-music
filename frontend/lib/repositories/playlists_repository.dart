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
    _items.addAll(result);

    return true;
  }

  Future<Playlist> getPlaylist(String playlistId) async {
    final localPlaylist =
        items.firstWhereOrNull((item) => item.id == playlistId);

    if (localPlaylist == null) {
      return _playlistsApiProvider.getPlaylist(playlistId);
    }

    return localPlaylist;
  }

  Future<bool> createPlaylist(String title) async {
    final result = await _playlistsApiProvider.createPlaylist(title);
    _items.add(result);
    return true;
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
