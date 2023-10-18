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
      return List.castFrom<dynamic, Track>(
        jsonList.map((e) => Track.fromJson(e as Map<String, dynamic>)).toList(),
      );
    }

    throw Exception('Failed to load tracks: ${response.body}');
  }

  Future<Track> getTrack(String trackId) async {
    final uri = Uri.parse(_apiService.reqTrack(trackId));
    final response = await getAsync(uri);

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as Map<String, dynamic>;
      return Track.fromJson(jsonList);
    }

    throw Exception('Failed to load track: ${response.body}');
  }

  Future<List<Track>> searchTracks(String searchQuery) async {
    final uri =
        Uri.parse(_apiService.reqSearch(Uri.encodeComponent(searchQuery)));
    final response = await getAsync(uri);

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List<dynamic>;
      return List.castFrom<dynamic, Track>(
        jsonList.map((e) => Track.fromJson(e as Map<String, dynamic>)).toList(),
      );
    }

    throw Exception('Failed to search tracks: ${response.body}');
  }

  Future<({String artist, String title})?> fetchYtVideoInfo(String url) async {
    if (url == '') return null;

    final uri = Uri.parse(_apiService.reqYtVideoInfo(url));
    final response = await getAsync(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return (
        artist: Uri.decodeQueryComponent(body['artist'] as String).trim(),
        title: Uri.decodeQueryComponent(body['title'] as String).trim()
      );
    }

    throw Exception('Failed to upload YouTube track: ${response.body}');
  }

  Future<bool> uploadYtTrack(String url, String artist, String title) async {
    if (url == '') return false;

    final uri = Uri.parse(_apiService.reqYtDownload(url, artist, title));
    final response = await getAsync(uri);

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('Failed to upload YouTube track: ${response.body}');
  }

  Future<bool> editTrack(
    String id, {
    String? artist,
    String? title,
    String? cover,
  }) async {
    final response = await patchAsync(
      Uri.parse(_apiService.trackPlayback(id)),
      body: {
        "artist": artist?.trim() ?? '',
        "title": title?.trim() ?? '',
        "cover": cover?.trim() ?? '',
      },
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('Failed to edit track: ${response.body}');
  }

  Future<bool> uploadLocalTracks(
    List<({List<int> bytes, String filename})> files,
  ) async {
    final request =
        http.MultipartRequest("POST", Uri.parse(_apiService.upload));

    for (final file in files) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          file.bytes,
          filename: file.filename,
          contentType: MediaType('audio', ''),
        ),
      );
    }

    final response = await request.sendAsync();

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('Failed to upload local track: $response');
  }
}
