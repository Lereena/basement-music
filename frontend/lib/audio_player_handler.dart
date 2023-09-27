import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'api_service.dart';
import 'app.dart';
import 'models/track.dart';

Future<void> initAudioHandler(ApiService apiService) async {
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(apiService),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.lereena.basement-music.channel.audio',
      androidNotificationChannelName: 'Basement music',
      androidNotificationOngoing: true,
    ),
  );
}

class AudioPlayerHandler extends BaseAudioHandler {
  final ApiService apiService;

  AudioPlayerHandler(this.apiService);

  final _audioPlayer = AudioPlayer();
  var _currentTrack = Track.empty();

  late final onPlayerComplete = _audioPlayer.onPlayerComplete;
  late final onPositionChanged = _audioPlayer.onPositionChanged;

  void addMediaItem(Track track) {
    _currentTrack = track;
    mediaItem
        .add(MediaItem(id: track.id, title: track.title, artist: track.artist));
  }

  @override
  Future<void> play() => _customPlay(_currentTrack.id);

  @override
  Future<void> pause() => _audioPlayer.pause();

  Future<void> resume() => _audioPlayer.resume();

  Future<void> _customPlay(String trackId) async {
    final cachedFile = await DefaultCacheManager().getFileFromCache(trackId);

    if (cachedFile == null) {
      await _audioPlayer.play(UrlSource(apiService.trackPlayback(trackId)));
      return;
    }

    _audioPlayer.play(DeviceFileSource(cachedFile.file.uri.path));
  }
}
