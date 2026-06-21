import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import 'package:basement_music/models/artist.dart';
import 'package:basement_music/rest_client.dart';

class ArtistsRepository {
  final _items = <Artist>[];

  final RestClient _restClient;
  final String _baseUrl;

  ArtistsRepository(this._restClient, {required String baseUrl}) : _baseUrl = baseUrl;

  List<Artist> get items => _items;

  BehaviorSubject<List<Artist>> artistsSubject = BehaviorSubject.seeded([]);

  Future<bool> getAllArtists() async {
    final result = await _restClient.getAllArtists();
    _items.clear();
    _items.addAll(result.map(_resolveImageUrl));

    artistsSubject.add(_items);

    return true;
  }

  Future<Artist> getArtist(String artistId) async {
    final artist = await _restClient.getArtist(artistId);
    return _resolveImageUrl(artist);
  }

  Future<void> updateArtistImage(String artistId, List<int> bytes, String filename) {
    return _restClient.updateArtistImage(
      id: artistId,
      image: MultipartFile.fromBytes(bytes, filename: filename),
    );
  }

  Artist _resolveImageUrl(Artist a) {
    if (a.image == null || a.image!.startsWith('http')) return a;
    return Artist(id: a.id, name: a.name, image: '$_baseUrl${a.image!}', tracks: a.tracks);
  }
}
