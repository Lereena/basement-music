import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../models/playlist.dart';
import '../rest_client.dart';

class PlaylistsRepository {
  final _items = <Playlist>[];

  final RestClient _restClient;

  PlaylistsRepository(this._restClient);

  List<Playlist> get items => _items;

  BehaviorSubject<List<Playlist>> playlistsSubject = BehaviorSubject.seeded([]);

  Playlist openedPlaylist = Playlist.empty();

  Future<bool> getAllPlaylists() async {
    final result = await _restClient.getAllPlaylists();
    _items.clear();
    _items.addAll(result);

    playlistsSubject.add(_items);

    return true;
  }

  Future<Playlist> getPlaylist(String playlistId) async {
    final playlist = _items.firstWhereOrNull((item) => item.id == playlistId);

    if (playlist == null) {
      return _restClient.getPlaylist(playlistId);
    }

    return playlist;
  }

  Future<void> createPlaylist(String title) async {
    final result = await _restClient.createPlaylist(title);
    _items.add(result);

    playlistsSubject.add(_items);
  }

  Future<void> editPlaylist({
    required String id,
    required String title,
    required List<String> tracksIds,
  }) async {
    await _restClient.editPlaylist(
      id: id,
      title: title,
      tracks: tracksIds,
    );

    final playlist = await _restClient.getPlaylist(id);
    final playlistIndex = _items.indexWhere((item) => item.id == id);
    _items[playlistIndex] = playlist;

    playlistsSubject.add(_items);
  }

  Future<void> deletePlaylist(String playlistId) async {
    await _restClient.deletePlaylist(playlistId);

    _items.removeWhere((element) => element.id == playlistId);
    playlistsSubject.add(_items);
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
