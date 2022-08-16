import 'package:basement_music/utils/request_result_model.dart';

import '../api.dart';
import '../library.dart';
import '../utils/log/log_service.dart';
import '../utils/request.dart';

Future<RequestResultModel> addTrackToPlaylist(String playlistId, String trackId) async {
  final uri = Uri.parse('${reqAddTrackToPlaylist(playlistId, trackId)}');
  final response = await postAsync(uri);

  if (response.statusCode == 200) {
    final track = tracks.firstWhere((element) => element.id == trackId);
    playlists.firstWhere((element) => element.id == playlistId).tracks.add(track);
    return RequestResultModel(result: true);
  } else {
    LogService.log('Failed to create playlist: ${response.body}');
    return RequestResultModel(result: false);
  }
}
