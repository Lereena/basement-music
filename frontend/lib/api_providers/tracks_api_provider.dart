import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../api_service.dart';
import '../models/track.dart';
import '../utils/request.dart';

class TracksApiProvider {
  final ApiService _apiService;

  TracksApiProvider(this._apiService);

  Future<List<Track>> fetchAllTracks() async {
    final uri = Uri.parse(_apiService.reqAllTracks);
    final response = await getAsync(uri);

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List<dynamic>;
      return List.castFrom<dynamic, Track>(jsonList.map((e) => Track.fromJson(e)).toList());
    }

    throw Exception('Failed to load tracks: ${response.body}');
  }

  Future<bool> uploadYtTrack(String url, String artist, String title) async {
    if (url == '') return false;

    final uri2 = Uri.parse(_apiService.reqYtDownload(url, artist, title));
    final response = await getAsync(uri2);

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('Failed to upload YouTube track: ${response.body}');
  }

  Future<bool> editTrack(String id, {String artist = "", String title = "", String cover = ""}) async {
    final response = await patchAsync(
      Uri.parse(_apiService.trackPlayback(id)),
      body: {
        "artist": artist.trim(),
        "title": title.trim(),
        "cover": cover.trim(),
      },
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('Failed to edit track: ${response.body}');
  }

  Future<bool> uploadLocalTrack(List<int> file, String filename) async {
    final request = http.MultipartRequest("POST", Uri.parse(_apiService.upload))
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          file,
          filename: filename,
          contentType: MediaType('audio', ''),
        ),
      );

    final response = await request.sendAsync();

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('Failed to upload local track: ${response.body}');
  }
}
