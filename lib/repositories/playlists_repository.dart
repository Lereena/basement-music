import 'package:basement_music/api_providers/playlists_api_provider.dart';
import 'package:basement_music/library.dart';
import 'package:basement_music/models/playlist.dart';

class PlaylistsRepository {
  final _playlistsApiProvider = PlaylistsApiProvider();
  var _items = <Playlist>[];

  get items => _items;

  Future<bool> getAllPlaylists() async {
    final result = await _playlistsApiProvider.fetchAllPlaylists();
    _items.addAll(result);

    return true;
  }

  Future<bool> createPlaylist(String title) async {
    final result = await _playlistsApiProvider.createPlaylist(title);
    _items.add(result);
    return true;
  }

  Future<bool> deletePlaylist(String playlistId) async {
    final result = await _playlistsApiProvider.deletePlaylist(playlistId);
    if (result) {
      _items.removeWhere(((element) => element.id == playlistId));
    }
    return result;
  }

  Future<bool> addTrackToPlaylist(String playlistId, String trackId) async {
    final result = await _playlistsApiProvider.addTrackToPlaylist(playlistId, trackId);
    if (result) {
      _items
          .firstWhere((element) => element.id == playlistId)
          .tracks
          .add(tracks.firstWhere((element) => element.id == trackId));
    }
    return result;
  }
}
