import 'dart:convert';
import 'dart:developer';

import 'models/track.dart';
import 'package:http/http.dart' as http;

Future<List<Track>> fetchAllTracks() async {
  final uri = Uri.parse('http://localhost:9000/tracks');
  final response = await http.get(uri);
  final List<dynamic> jsonList = jsonDecode(response.body);
  final list = <Track>[];
  if (response.statusCode == 200) {
    jsonList.map((e) => Track.fromJson(e)).forEach((element) {
      tracks.add(element);
    });
  } else {
    log('Failed to load tracks');
  }
  return list;
}

List<Track> tracks = [];
