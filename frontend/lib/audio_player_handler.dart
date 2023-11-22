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

  void addMediaItem(Track track) {
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
    if (!mediaItem.hasValue) return;

    final trackId = mediaItem.value!.id;
    final cachedFile = await DefaultCacheManager().getFileFromCache(trackId);

    if (cachedFile == null) {
      await _audioPlayer
          .play(UrlSource('${appConfig.baseUrl}/api/track/$trackId'));
    } else {
      await _audioPlayer.play(DeviceFileSource(cachedFile.file.uri.path));
    }

    playbackState.add(
      playbackState.value.copyWith(
        playing: true,
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.pause,
          MediaControl.skipToNext,
        ],
        updatePosition:
            await _audioPlayer.getCurrentPosition() ?? Duration.zero,
        processingState: AudioProcessingState.ready,
      ),
    );
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();

    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.play,
          MediaControl.skipToNext,
        ],
        updatePosition:
            await _audioPlayer.getCurrentPosition() ?? Duration.zero,
        processingState: AudioProcessingState.ready,
      ),
    );
  }

  @override
  Future<void> skipToNext() {
    final availableTracks = _getAvailableTracks();

    if (availableTracks.isEmpty) {
      return pause();
    }

    late final Track nextTrack;
    if (!settingsRepository.repeat) {
      if (settingsRepository.shuffle) {
        final nextTrackPosition = _shuffledNext(
          availableTracks,
          availableTracks
              .indexWhere((track) => track.id == mediaItem.value?.id),
        );
        nextTrack = availableTracks[nextTrackPosition];
      } else {
        final lastTrackPosition = availableTracks
            .indexWhere((track) => track.id == mediaItem.value?.id);
        final nextTrackPosition = lastTrackPosition < availableTracks.length - 1
            ? lastTrackPosition + 1
            : 0;
        nextTrack = availableTracks[nextTrackPosition];
      }
    }

    addMediaItem(nextTrack);
    return play();
  }

  @override
  Future<void> skipToPrevious() {
    final availableTracks = _getAvailableTracks();

    if (availableTracks.isEmpty) {
      return pause();
    }

    late final Track nextTrack;
    if (!settingsRepository.repeat) {
      if (settingsRepository.shuffle) {
        final nextTrackPosition = _shuffledNext(
          availableTracks,
          availableTracks
              .indexWhere((track) => track.id == mediaItem.value?.id),
        );
        nextTrack = availableTracks[nextTrackPosition];
      } else {
        final lastTrackPosition = availableTracks
            .indexWhere((track) => track.id == mediaItem.value?.id);
        final previousTrackPosition = lastTrackPosition > 0
            ? lastTrackPosition - 1
            : availableTracks.length - 1;
        nextTrack = availableTracks[previousTrackPosition];
      }
    }

    addMediaItem(nextTrack);
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
