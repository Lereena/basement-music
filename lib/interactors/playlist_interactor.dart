import 'dart:convert';

import 'package:basement_music/utils/request_result_model.dart';

import '../api.dart';
import '../library.dart';
import '../models/playlist.dart';
import '../models/track.dart';
import '../utils/log/log_service.dart';
import '../utils/request.dart';

Future<RequestResultModel> fetchAllPlaylists() async {
  final uri = Uri.parse('$reqAllPlaylists');
  final response = await getAsync(uri);

  if (response.statusCode == 200) {
    final jsonList = jsonDecode(response.body);
    playlists = List.castFrom<dynamic, Playlist>(jsonList.map((e) => Playlist.fromJson(e)).toList());

    return RequestResultModel(result: true);
  } else {
    LogService.log('Failed to load playlists: ${response.body}');
    return RequestResultModel(result: false);
  }
}

Future<RequestResultModel> getPlaylist(String playlistId) async {
  final uri = Uri.parse('${reqPlaylist(playlistId)}');
  final response = await getAsync(uri);

  if (response.statusCode == 200) {
    final playlist = Playlist.fromJson(jsonDecode(response.body));
    return RequestResultModel(result: true, value: playlist);
  } else {
    LogService.log('Failed to load playlist: ${response.body}');
    return RequestResultModel(result: false);
  }
}

Future<RequestResultModel> createPlaylist(String title) async {
  final uri = Uri.parse('${reqCreatePlaylist(title)}');
  final response = await postAsync(uri);

  if (response.statusCode == 200) {
    return RequestResultModel(result: true);
  } else {
    LogService.log('Failed to create playlist: ${response.body}');
    return RequestResultModel(result: false);
  }
}

Future<RequestResultModel> deletePlaylist(String playlistId) async {
  final uri = Uri.parse('${reqPlaylist(playlistId)}');
  final response = await deleteAsync(uri);

  if (response.statusCode == 200) {
    playlists.removeWhere(((element) => element.id == playlistId));
    return RequestResultModel(result: true);
  } else {
    LogService.log('Failed to create playlist: ${response.body}');
    return RequestResultModel(result: false);
  }
}

Future<RequestResultModel> addTrackToPlaylist(String playlistId, String trackId) async {
  final uri = Uri.parse('${addTrackToPlaylist(playlistId, trackId)}');
  final response = await postAsync(uri);

  if (response.statusCode == 200) {
    playlists.firstWhere((element) => element.id == playlistId).tracks.add(Track.fromJson(jsonDecode(response.body)));
    return RequestResultModel(result: true);
  } else {
    LogService.log('Failed to create playlist: ${response.body}');
    return RequestResultModel(result: false);
  }
}
