import 'dart:convert';

import 'package:basement_music/models/playlist.dart';

import '../api.dart';
import '../utils/request.dart';

class PlaylistsApiProvider {
  Future<List<Playlist>> fetchAllPlaylists() async {
    final uri = Uri.parse('$reqAllPlaylists');
    final response = await getAsync(uri);

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body);
      return List.castFrom<dynamic, Playlist>(jsonList.map((e) => Playlist.fromJson(e)).toList());
    } else {
      throw Exception('Failed to load playlists: ${response.body}');
    }
  }
}
