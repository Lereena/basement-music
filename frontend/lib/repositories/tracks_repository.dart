import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../models/track.dart';
import '../models/video_info.dart';
import '../rest_client.dart';

class TracksRepository {
  final _items = <Track>[];
  final _searchItems = <Track>[];

  final RestClient _restClient;

  TracksRepository(this._restClient);

  List<Track> get items => _items;
  List<Track> get searchItems => _searchItems;

  Future<void> getAllTracks() async {
    final result = await _restClient.getAllTracks();
    _items.clear();
    _items.addAll(result);
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
      MultipartFile.fromBytes(
        file.bytes,
        filename: file.filename,
        contentType: MediaType('audio', ''),
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
  }
}
