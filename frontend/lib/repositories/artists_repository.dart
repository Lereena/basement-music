import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import 'package:basement_music/models/album.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/models/metadata_candidates.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/rest_client.dart';
import 'package:basement_music/utils/image_url.dart';

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

    // Emit a fresh list instance — reusing the mutated `_items` reference makes
    // freezed state equality short-circuit on identical() and skip the rebuild.
    artistsSubject.add(List.of(_items));

    return true;
  }

  Future<List<Artist>> searchArtists(String query) async {
    final result = await _restClient.searchArtists(query);
    return result.map(_resolveImageUrl).toList();
  }

  Future<Artist> getArtist(String artistId) async {
    final artist = _resolveImageUrl(await _restClient.getArtist(artistId));

    // Keep the in-memory list and subscribers in sync so cubits listening on
    // artistsSubject refresh after an edit/metadata mutation.
    final index = _items.indexWhere((item) => item.id == artistId);
    if (index != -1) {
      _items[index] = artist;
    } else {
      _items.add(artist);
    }
    artistsSubject.add(List.of(_items));

    return artist;
  }

  Future<void> updateArtistImage(String artistId, List<int> bytes, String filename) async {
    await _restClient.updateArtistImage(
      id: artistId,
      image: MultipartFile.fromBytes(bytes, filename: filename),
    );
  }

  // Rebinds a track to the given artists (entity-level). Returns the updated
  // track and refreshes the artist list so grids/pages reflect the change.
  Future<Track> setTrackArtists(String trackId, List<String> artistIds) async {
    final track = await _restClient.setTrackArtists(trackId: trackId, artistIds: artistIds);
    await getAllArtists();
    return track;
  }

  Future<Artist> editArtist({required String id, required String name, String description = ''}) async {
    await _restClient.editArtist(id: id, name: name, description: description);
    return getArtist(id);
  }

  Future<List<ArtistCandidate>> searchMetadata(String artistId, {String query = ''}) {
    return _restClient.searchArtistMetadata(id: artistId, query: query);
  }

  Future<ArtistMetadataPreview> previewMetadata(String artistId, String mbid) {
    return _restClient.previewArtistMetadata(id: artistId, mbid: mbid);
  }

  Future<Artist> applyMetadata(String artistId, {String description = '', String imageUrl = ''}) async {
    await _restClient.applyArtistMetadata(id: artistId, description: description, imageUrl: imageUrl);
    return getArtist(artistId);
  }

  Artist _resolveImageUrl(Artist a) {
    final image = imageUrlWithVersion(a.image, _baseUrl, a.updatedAt);
    final albums = a.albums?.map(_resolveAlbumCover).toList();
    return a.copyWith(image: image, albums: albums);
  }

  Album _resolveAlbumCover(Album album) => album.copyWith(
    cover: imageUrlWithVersion(album.cover, _baseUrl, album.updatedAt),
  );
}
