import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:http_parser/http_parser.dart';
import 'package:rxdart/rxdart.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/models/video_info.dart';
import 'package:basement_music/rest_client.dart';

class TracksRepository {
  final _items = <Track>[];
  final _searchItems = <Track>[];

  final RestClient _restClient;
  final Box<String> _persistenceBox;
  static const _cacheKey = 'tracks';

  TracksRepository(this._restClient, {required Box<String> persistenceBox})
      : _persistenceBox = persistenceBox {
    final cached = persistenceBox.get(_cacheKey);
    if (cached != null) {
      try {
        _items.addAll(
          (jsonDecode(cached) as List).map((e) => Track.fromJson(e as Map<String, dynamic>)),
        );
      } catch (e) {
        persistenceBox.delete(_cacheKey);
        logger.w('Tracks cache decode failed, cleared: $e');
      }
    }
  }

  List<Track> get items => _items;
  List<Track> get searchItems => _searchItems;

  BehaviorSubject<List<Track>> tracksSubject = BehaviorSubject.seeded([]);

  Future<void> getAllTracks() async {
    final result = await _restClient.getAllTracks();
    _items.clear();
    _items.addAll(result);
    await _persistenceBox.put(_cacheKey, jsonEncode(_items.map((e) => e.toJson()).toList()));
    tracksSubject.add(_items);
  }

  void searchTracksOffline(String searchQuery) {
    _searchItems.clear();

    final result = _items.where((track) => track.matchesQuery(searchQuery));
    _searchItems.addAll(result);
  }

  Future<void> searchTracksOnline(String searchQuery) async {
    _searchItems.clear();

    final result = await _restClient.searchTracks(searchQuery);
    _searchItems.addAll(result);
  }

  Future<VideoInfo?> fetchYtVideoInfo(String url) {
    return _restClient.fetchYtVideoInfo(url);
  }

  Future<void> uploadYtTrack(String url, String artist, String title) {
    return _restClient.uploadYtTrack(url, artist, title);
  }

  Future<void> uploadLocalTracks(
    List<({List<int> bytes, String filename})> files,
  ) {
    final multipartFiles = <MultipartFile>[];

    for (final file in files) {
      multipartFiles.add(
        MultipartFile.fromBytes(
          file.bytes,
          filename: file.filename,
          contentType: MediaType('audio', ''),
        ),
      );
    }

    return _restClient.uploadLocalTracks(multipartFiles);
  }

  Future<void> editTrack({
    required String id,
    String? artist,
    String? title,
    String? cover,
  }) async {
    await _restClient.editTrack(
      id: id,
      artist: artist?.trim() ?? '',
      title: title?.trim() ?? '',
      cover: cover?.trim() ?? '',
    );

    final trackIndex = _items.indexWhere((track) => track.id == id);
    _items[trackIndex] = _items[trackIndex].copyWith(
      artist: artist,
      title: title,
      cover: cover,
    );

    tracksSubject.add(_items);
  }

  /// Replaces a track with a server-updated copy and re-emits. Used after
  /// lyrics are embedded so hasLyrics is reflected everywhere without a full
  /// refetch. (Hive cache refreshes on the next getAllTracks, like editTrack.)
  void applyTrackUpdate(Track updated) {
    final index = _items.indexWhere((track) => track.id == updated.id);
    if (index == -1) return;
    _items[index] = updated;
    tracksSubject.add(_items);
  }
}
