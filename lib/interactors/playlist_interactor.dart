import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api.dart';
import '../library.dart';
import '../models/playlist.dart';
import '../models/track.dart';

Future<List<Playlist>> fetchAllPlaylists() async {
  final uri = Uri.parse('$reqAllPlaylists');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    playlists = jsonDecode(response.body).map((e) {
      final a = Playlist.fromJson(e);
      return a;
    });
  } else {
    log('Failed to load playlist: ${response.body}');
  }

  return playlists;
}

Future<void> createPlaylist(String title) async {
  if (title.isEmpty) {
    debugPrint("Playlist title is empty");
    return;
  }

  final uri = Uri.parse('${createPlaylist(title)}');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    playlists.add(Playlist.fromJson(response.body as Map<String, dynamic>));
  } else {
    debugPrint('Failed to create playlist: ${response.body}');
  }
}

Future<void> addTrackToPlaylist(String playlistId, String trackId) async {
  if (playlistId.isEmpty || trackId.isEmpty) {
    debugPrint("Playlist id and track id must not be empty");
    return;
  }

  final uri = Uri.parse('${addTrackToPlaylist(playlistId, trackId)}');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    playlists
        .firstWhere((element) => element.id == playlistId)
        .tracksIds
        .add(Track.fromJson(jsonDecode(response.body)));
  } else {
    debugPrint('Failed to create playlist: ${response.body}');
  }
}