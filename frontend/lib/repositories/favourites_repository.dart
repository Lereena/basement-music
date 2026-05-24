import 'package:basement_music/models/track.dart';
import 'package:basement_music/rest_client.dart';

class FavouritesRepository {
  FavouritesRepository(this._restClient);

  final RestClient _restClient;

  Future<List<Track>> getFavourites() => _restClient.getFavourites();

  Future<void> addFavourite(String trackId) =>
      _restClient.addFavourite(trackId);

  Future<void> removeFavourite(String trackId) =>
      _restClient.removeFavourite(trackId);
}
