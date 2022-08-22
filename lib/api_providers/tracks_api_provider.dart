import 'dart:convert';

import '../api.dart';
import '../models/track.dart';
import '../utils/request.dart';

class TracksApiProvider {
  Future<List<Track>> fetchAllTracks() async {
    final uri = Uri.parse(reqAllTracks);
    final response = await getAsync(uri);

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
    final list = <Track>[];

    if (response.statusCode == 200) {
      jsonList.map((e) => Track.fromJson(e)).forEach((element) {
        list.add(element);
      });

      // await cacher.fetchAllCachedIds();

      return list;
    } else {
      throw Exception('Failed to load tracks: ${response.body}');
    }
  }
}
