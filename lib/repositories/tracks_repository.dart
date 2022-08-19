import 'package:basement_music/api_providers/tracks_api_provider.dart';

import '../models/track.dart';

class TracksRepository {
  final _tracksApiProvider = TracksApiProvider();

  var _items = <Track>[];
  List<Track> get items => _items;

  Future<bool> getAllTracks() async {
    final result = await _tracksApiProvider.fetchAllTracks();
    _items.addAll(result);

    return true;
  }
}
