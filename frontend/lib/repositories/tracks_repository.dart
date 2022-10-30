import '../api_providers/tracks_api_provider.dart';
import '../api_service.dart';
import '../models/track.dart';

class TracksRepository {
  final _items = <Track>[];
  final ApiService _apiService;
  late final _tracksApiProvider = TracksApiProvider(_apiService);

  TracksRepository(this._apiService);

  List<Track> get items => _items;

  Future<void> getAllTracks() async {
    final result = await _tracksApiProvider.fetchAllTracks();
    _items.addAll(result);
  }

  Future<bool> uploadYtTrack(String url, String artist, String title) {
    return _tracksApiProvider.uploadYtTrack(url, artist, title);
  }

  Future<bool> editTrack(
    String id,
    String artist,
    String title,
    String cover,
  ) async {
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

  Future<bool> uploadLocalTrack(List<int> file, String filename) {
    return _tracksApiProvider.uploadLocalTrack(file, filename);
  }
}