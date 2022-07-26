import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'api.dart';
import 'cacher/cacher.dart';

final audioPlayer = AudioPlayer();

extension CustomPlay on AudioPlayer {
  Future<void> customPlay(String trackId) async {
    if (!(cacher.isCached(trackId))) {
      this.play(UrlSource(trackPlayback(trackId)));
      return;
    }

    final trackUrl = (await cacher.getFile(trackId))?.file.uri.path;

    if (trackUrl == null) {
      debugPrint('Couldn\'t play cached track $trackId');
      return;
    }
    this.play(DeviceFileSource(trackUrl));
  }
}
