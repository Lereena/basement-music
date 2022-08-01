import 'package:basement_music/api_providers/playlists_api_provider.dart';
import 'package:basement_music/models/playlist.dart';

class PlaylistsRepository {
  final _playlistsApiProvider = PlaylistsApiProvider();

  Future<List<Playlist>> getAllPlaylists() => _playlistsApiProvider.fetchAllPlaylists();
}
