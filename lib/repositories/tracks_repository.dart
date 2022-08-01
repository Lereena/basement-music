import 'package:basement_music/api_providers/tracks_api_provider.dart';

import '../models/track.dart';

class TracksRepository {
  final _tracksApiProvider = TracksApiProvider();

  Future<List<Track>> getAllTracks() => _tracksApiProvider.fetchAllTracks();
}
