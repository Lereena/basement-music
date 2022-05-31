import 'dart:convert';
import 'dart:developer';

import 'api.dart';
import 'models/track.dart';
import 'package:http/http.dart' as http;

Future<List<Track>> fetchAllTracks() async {
  final uri = Uri.parse('$host$reqAllTracks');
  final response = await http.get(uri);
  final List<dynamic> jsonList = jsonDecode(response.body);
  final list = <Track>[];
  if (response.statusCode == 200) {
    jsonList.map((e) => Track.fromJson(e)).forEach((element) {
      list.add(element);
    });
  } else {
    log('Failed to load tracks');
  }
  tracks = list;
  return list;
}

Future<bool> uploadTrack(String url) async {
  if (url == '') return false;

  final uri2 = Uri.parse('$host$downloadYt$url');
  final response = await http.get(uri2);

  return response.statusCode == 200;
}

List<Track> tracks = [];
