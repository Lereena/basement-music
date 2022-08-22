import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../api.dart';
import '../utils/log/log_service.dart';
import '../utils/request.dart';

Future<bool> uploadYtTrack(String url, String artist, String title) async {
  if (url == '') return false;

  final uri2 = Uri.parse(reqYtDownload(url, artist, title));
  final response = await getAsync(uri2);

  return response.statusCode == 200;
}

Future<bool> editTrack(String id, {String artist = "", String title = "", String cover = ""}) async {
  try {
    final response = await patchAsync(
      Uri.parse(trackPlayback(id)),
      body: {
        "artist": artist,
        "title": title,
        "cover": cover,
      },
    );
    return response.statusCode == 200;
  } catch (e) {
    LogService.log("Error when editing track: $e");
    return false;
  }
}

Future<bool> uploadLocalTrack(List<int> file, String filename) async {
  try {
    final request = http.MultipartRequest("POST", Uri.parse(upload))
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          file,
          filename: filename,
          contentType: MediaType('audio', ''),
        ),
      );
    final response = await request.sendAsync();
    return response.statusCode == 200;
  } catch (e) {
    LogService.log("Error when uploading track: $e");
    return false;
  }
}
