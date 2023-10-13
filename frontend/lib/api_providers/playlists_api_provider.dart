import 'dart:convert';

import '../api_service.dart';
import '../models/playlist.dart';
import '../utils/request.dart';

class PlaylistsApiProvider {
  final ApiService _apiService;

  PlaylistsApiProvider(this._apiService);

  Future<List<Playlist>> fetchAllPlaylists() async {
    final uri = Uri.parse(_apiService.reqAllPlaylists);
    final response = await getAsync(uri);

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body);
      return List.castFrom<dynamic, Playlist>(
        jsonList
            .map((e) => Playlist.fromJson(e as Map<String, dynamic>))
            .toList() as List<dynamic>,
      );
    } else {
      throw Exception('Failed to load playlists: ${response.body}');
    }
  }

  Future<Playlist> getPlaylist(String playlistId) async {
    final uri = Uri.parse(_apiService.reqPlaylist(playlistId));
    final response = await getAsync(uri);

    if (response.statusCode == 200) {
      return Playlist.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to load playlist: ${response.body}');
    }
  }

  Future<Playlist> createPlaylist(String title) async {
    final uri = Uri.parse(_apiService.reqCreatePlaylist(title));
    final response = await postAsync(uri);

    if (response.statusCode == 200) {
      return Playlist.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception('Failed to create playlist: ${response.body}');
  }

  Future<bool> deletePlaylist(String playlistId) async {
    final uri = Uri.parse(_apiService.reqPlaylist(playlistId));
    final response = await deleteAsync(uri);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete playlist: ${response.body}');
    }
  }

  Future<bool> addTrackToPlaylist(String playlistId, String trackId) async {
    final uri = Uri.parse(_apiService.reqTrackPlaylist(playlistId, trackId));
    final response = await postAsync(uri);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to add track to playlist: ${response.body}');
    }
  }

  Future<bool> removeTrackFromPlaylist(
    String playlistId,
    String trackId,
  ) async {
    final uri = Uri.parse(_apiService.reqTrackPlaylist(playlistId, trackId));
    final response = await deleteAsync(uri);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to remove track from playlist: ${response.body}');
    }
  }
}
