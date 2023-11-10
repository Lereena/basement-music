import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'app_config.dart';
import 'models/track.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  final AppConfig _appConfig;

  AudioPlayerHandler(this._appConfig);

  final _audioPlayer = AudioPlayer();
  var _currentTrack = Track.empty();

  late final onPlayerComplete = _audioPlayer.onPlayerComplete;
  late final onPositionChanged = _audioPlayer.onPositionChanged;

  void addMediaItem(Track track) {
    _currentTrack = track;
    mediaItem.add(
      MediaItem(
        id: track.id,
        title: track.title,
        artist: track.artist,
        duration: Duration(seconds: track.duration),
      ),
    );
  }

  @override
  Future<void> play() => _customPlay(_currentTrack.id);

  @override
  Future<void> pause() => _audioPlayer.pause();

  Future<void> resume() => _audioPlayer.resume();

  Future<void> _customPlay(String trackId) async {
    final cachedFile = await DefaultCacheManager().getFileFromCache(trackId);

    if (cachedFile == null) {
      await _audioPlayer
          .play(UrlSource('${_appConfig.baseUrl}/api/track/$trackId'));
      return;
    }

    await _audioPlayer.play(DeviceFileSource(cachedFile.file.uri.path));
  }
}
