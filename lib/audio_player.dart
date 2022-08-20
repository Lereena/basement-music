import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'api.dart';

final audioPlayer = AudioPlayer();

extension CustomPlay on AudioPlayer {
  Future<void> customPlay(String trackId, {bool cached = false}) async {
    if (!cached) {
      this.play(UrlSource(trackPlayback(trackId)));
      return;
    }

    final trackUrl = (await _getCachedFile(trackId))?.file.uri.path;

    if (trackUrl == null) {
      debugPrint('Couldn\'t play cached track $trackId');
      return;
    }
    this.play(DeviceFileSource(trackUrl));
  }

  Future<FileInfo?> _getCachedFile(String trackId) async {
    return await DefaultCacheManager().getFileFromCache(trackId);
  }
}
