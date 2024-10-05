import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../models/artist.dart';
import '../rest_client.dart';

class ArtistsRepository {
  final _items = <Artist>[];

  final RestClient _restClient;

  ArtistsRepository(this._restClient);

  List<Artist> get items => _items;

  BehaviorSubject<List<Artist>> artistsSubject = BehaviorSubject.seeded([]);

  Future<bool> getAllArtists() async {
    final result = await _restClient.getAllArtists();
    _items.clear();
    _items.addAll(result);

    artistsSubject.add(_items);

    return true;
  }

  Future<Artist> getArtist(String artistId) async {
    final artist = _items.firstWhereOrNull((item) => item.id == artistId);

    if (artist == null) {
      return _restClient.getArtist(artistId);
    }

    return artist;
  }
}
