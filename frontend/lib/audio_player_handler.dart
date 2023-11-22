import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'app_config.dart';
import 'models/playlist.dart';
import 'models/track.dart';
import 'repositories/repositories.dart';

final _random = Random();

final _playingPlaybackState = PlaybackState(
  playing: true,
  controls: [
    MediaControl.skipToPrevious,
    MediaControl.pause,
    MediaControl.skipToNext,
  ],
  processingState: AudioProcessingState.ready,
);

final _pausedPlaybackState = PlaybackState(
  controls: [
    MediaControl.skipToPrevious,
    MediaControl.play,
    MediaControl.skipToNext,
  ],
  processingState: AudioProcessingState.ready,
);

class AudioPlayerHandler extends BaseAudioHandler {
  final AppConfig appConfig;
  final SettingsRepository settingsRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;
  final CacheRepository cacheRepository;

  AudioPlayerHandler({
    required this.appConfig,
    required this.settingsRepository,
    required this.connectivityStatusRepository,
    required this.cacheRepository,
  });

  final _audioPlayer = AudioPlayer();

  Stream<void> get onPlayerComplete => _audioPlayer.onPlayerComplete;
  Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;
  Stream<PlayerState> get onPlayerStateChanged =>
      _audioPlayer.onPlayerStateChanged;

  Playlist currentPlaylist = Playlist.empty();
  Track currentTrack = Track.empty();

  void addMediaItem(Track track) {
    currentTrack = track;
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
  Future<void> play() async {
    addMediaItem(currentTrack);

    final trackId = mediaItem.value!.id;
    final cachedFile = await DefaultCacheManager().getFileFromCache(trackId);

    if (cachedFile == null) {
      await _audioPlayer
          .play(UrlSource('${appConfig.baseUrl}/api/track/$trackId'));
    } else {
      await _audioPlayer.play(DeviceFileSource(cachedFile.file.uri.path));
    }

    playbackState.add(_playingPlaybackState);
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
    playbackState.add(_pausedPlaybackState);
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
    playbackState.add(_playingPlaybackState);
  }

  @override
  Future<void> skipToNext() {
    pause();

    final availableTracks = _getAvailableTracks();

    if (availableTracks.isEmpty) {
      return pause();
    }

    if (!settingsRepository.repeat) {
      if (settingsRepository.shuffle) {
        final nextTrackPosition = _shuffledNext(
          availableTracks,
          availableTracks.indexOf(currentTrack),
        );
        currentTrack = availableTracks[nextTrackPosition];
      } else {
        final lastTrackPosition = availableTracks.indexOf(currentTrack);
        final nextTrackPosition = lastTrackPosition < availableTracks.length - 1
            ? lastTrackPosition + 1
            : 0;
        currentTrack = availableTracks[nextTrackPosition];
      }
    }

    addMediaItem(currentTrack);
    return play();
  }

  @override
  Future<void> skipToPrevious() {
    pause();

    final availableTracks = _getAvailableTracks();

    if (availableTracks.isEmpty) {
      return pause();
    }

    if (!settingsRepository.repeat) {
      if (settingsRepository.shuffle) {
        final nextTrackPosition = _shuffledNext(
          availableTracks,
          availableTracks.indexOf(currentTrack),
        );
        currentTrack = availableTracks[nextTrackPosition];
      } else {
        final lastTrackPosition = availableTracks.indexOf(currentTrack);
        final previousTrackPosition = lastTrackPosition > 0
            ? lastTrackPosition - 1
            : availableTracks.length - 1;
        currentTrack = availableTracks[previousTrackPosition];
      }
    }

    addMediaItem(currentTrack);
    return play();
  }

  List<Track> _getAvailableTracks() {
    final isOffline = connectivityStatusRepository.statusSubject.value ==
        ConnectivityResult.none;

    return isOffline
        ? currentPlaylist.tracks
            .where((track) => cacheRepository.items.contains(track.id))
            .toList()
        : currentPlaylist.tracks;
  }

  int _shuffledNext(List<Track> availableTracks, int excluding) {
    var result = _random.nextInt(availableTracks.length);
    while (result == excluding) {
      result = _random.nextInt(availableTracks.length);
    }
    return result;
  }
}
