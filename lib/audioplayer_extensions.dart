import 'package:audioplayers/audioplayers.dart';
import 'package:basement_music/utils/log/log_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'api.dart';

extension CustomPlay on AudioPlayer {
  Future<void> customPlay(String trackId, {bool cached = false}) async {
    if (!cached) {
      await play(UrlSource(trackPlayback(trackId)));
      return;
    }

    final trackUrl = (await _getCachedFile(trackId))?.file.uri.path;

    if (trackUrl == null) {
      LogService.log("Couldn't play cached track $trackId");
      return;
    }
    play(DeviceFileSource(trackUrl));
  }

  Future<FileInfo?> _getCachedFile(String trackId) async {
    return DefaultCacheManager().getFileFromCache(trackId);
  }
}
