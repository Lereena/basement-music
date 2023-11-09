import 'package:collection/collection.dart';

import '../models/playlist.dart';
import '../rest_client.dart';

class PlaylistsRepository {
  final _items = <Playlist>[];

  final RestClient _restClient;

  PlaylistsRepository(this._restClient);

  List<Playlist> get items => _items;

  Future<bool> getAllPlaylists() async {
    final result = await _restClient.getAllPlaylists();
    _items.clear();
    _items.addAll(result);

    return true;
  }

  Future<Playlist> getPlaylist(String playlistId) async {
    final playlist = items.firstWhereOrNull((item) => item.id == playlistId);

    if (playlist == null) {
      return _restClient.getPlaylist(playlistId);
    }

    return playlist;
  }

  Future<void> createPlaylist(String title) async {
    final result = await _restClient.createPlaylist(title);
    _items.add(result);
  }

  Future<void> editPlaylist({
    required String id,
    required String title,
    required List<String> tracksIds,
  }) {
    return _restClient.editPlaylist(
      id: id,
      title: title,
      tracks: tracksIds,
    );
  }

  Future<void> deletePlaylist(String playlistId) async {
    await _restClient.deletePlaylist(playlistId);

    _items.removeWhere((element) => element.id == playlistId);
  }

  Future<void> addTrackToPlaylist(String playlistId, String trackId) {
    return _restClient.addTrackToPlaylist(
      playlistId: playlistId,
      trackId: trackId,
    );
  }

  Future<void> removeTrackFromPlaylist(
    String playlistId,
    String trackId,
  ) {
    return _restClient.removeTrackFromPlaylist(
      playlistId: playlistId,
      trackId: trackId,
    );
  }
}
