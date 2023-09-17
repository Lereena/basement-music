import '../api_providers/tracks_api_provider.dart';
import '../api_service.dart';
import '../models/track.dart';

class TracksRepository {
  final _items = <Track>[];
  final _searchItems = <Track>[];
  final ApiService _apiService;
  late final _tracksApiProvider = TracksApiProvider(_apiService);

  TracksRepository(this._apiService);

  List<Track> get items => _items;
  List<Track> get searchItems => _searchItems;

  Future<void> getAllTracks() async {
    final result = await _tracksApiProvider.fetchAllTracks();
    _items.clear();
    _items.addAll(result.reversed);
  }

  Future<void> searchTracks(String searchQuery) async {
    _searchItems.clear();

    final result = await _tracksApiProvider.searchTracks(searchQuery);
    _searchItems.addAll(result);
  }

  Future<bool> uploadYtTrack(String url, String artist, String title) {
    return _tracksApiProvider.uploadYtTrack(url, artist, title);
  }

  Future<bool> uploadLocalTracks(
    List<({List<int> bytes, String filename})> files,
  ) {
    return _tracksApiProvider.uploadLocalTracks(files);
  }

  Future<bool> editTrack({
    required String id,
    String? artist,
    String? title,
    String? cover,
  }) async {
    final result = await _tracksApiProvider.editTrack(
      id,
      artist: artist,
      title: title,
      cover: cover,
    );

    if (result) {
      final trackIndex = _items.indexWhere((track) => track.id == id);
      _items[trackIndex] = _items[trackIndex].copyWith(
        artist: artist,
        title: title,
        cover: cover,
      );
    }

    return result;
  }
}
