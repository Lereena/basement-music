import 'dart:convert';
import 'dart:developer';

import 'api.dart';
import 'models/track.dart';
import 'package:http/http.dart' as http;

Future<List<Track>> fetchAllTracks() async {
  final uri = Uri.parse('$host$reqAllTracks');
  final response = await http.get(uri);
  // final uri2 = Uri.parse('$host$downloadYt/https://www.youtube.com/watch?v=svmP5aT6ZqY');
  // await http.get(uri2);
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
