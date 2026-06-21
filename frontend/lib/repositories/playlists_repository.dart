import 'dart:convert';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/rest_client.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class PlaylistsRepository {
  final _items = <Playlist>[];

  final RestClient _restClient;
  final Box<String> _persistenceBox;
  final String _baseUrl;
  static const _cacheKey = 'playlists';

  PlaylistsRepository(this._restClient, {required Box<String> persistenceBox, required String baseUrl})
    : _persistenceBox = persistenceBox,
      _baseUrl = baseUrl {
    final cached = persistenceBox.get(_cacheKey);
    if (cached != null) {
      try {
        _items.addAll((jsonDecode(cached) as List).map((e) => Playlist.fromJson(e as Map<String, dynamic>)));
      } catch (e) {
        persistenceBox.delete(_cacheKey);
        logger.w('Playlists cache decode failed, cleared: $e');
      }
    }
  }

  List<Playlist> get items => _items;

  BehaviorSubject<List<Playlist>> playlistsSubject = BehaviorSubject.seeded([]);

  Playlist openedPlaylist = Playlist.empty();

  Future<bool> getAllPlaylists() async {
    final result = await _restClient.getAllPlaylists();
    _items.clear();
    _items.addAll(result.map(_resolveImageUrl));
    await _persistenceBox.put(_cacheKey, jsonEncode(_items.map((e) => e.toJson()).toList()));
    playlistsSubject.add(_items);

    return true;
  }

  Future<Playlist> getPlaylist(String playlistId) async {
    final playlist = _items.firstWhereOrNull((item) => item.id == playlistId);

    if (playlist == null) {
      return _resolveImageUrl(await _restClient.getPlaylist(playlistId));
    }

    return playlist;
  }

  Future<void> createPlaylist(String title) async {
    final result = await _restClient.createPlaylist(title);
    _items.add(_resolveImageUrl(result));

    playlistsSubject.add(_items);
  }

  Future<void> editPlaylist({required String id, required String title, required List<String> tracksIds}) async {
    await _restClient.editPlaylist(id: id, title: title, tracks: tracksIds);

    final playlist = _resolveImageUrl(await _restClient.getPlaylist(id));
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
    return _restClient.addTrackToPlaylist(playlistId: playlistId, trackId: trackId);
  }

  Future<void> removeTrackFromPlaylist(String playlistId, String trackId) {
    return _restClient.removeTrackFromPlaylist(playlistId: playlistId, trackId: trackId);
  }

  Future<void> reorderTracks(String playlistId, List<String> trackIds) {
    return _restClient.reorderPlaylistTracks(playlistId: playlistId, body: {'trackIds': trackIds});
  }

  Future<void> updatePlaylistImage(String playlistId, List<int> bytes, String filename) {
    return _restClient.updatePlaylistImage(
      id: playlistId,
      image: MultipartFile.fromBytes(bytes, filename: filename),
    );
  }

  Playlist _resolveImageUrl(Playlist p) {
    if (p.image == null || p.image!.startsWith('http')) return p;
    return p.copyWith(image: '$_baseUrl${p.image!}');
  }
}
