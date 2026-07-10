import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:basement_music/app_config.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

  final _audioPlayer = AudioPlayer()..setAudioContext(
    AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {},
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gain,
      ),
    ),
  );

  Stream<void> get onPlayerComplete => _audioPlayer.onPlayerComplete;
  Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;
  Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.onPlayerStateChanged;

  Playlist currentPlaylist = Playlist.empty();

  // A preview is a one-off stream (e.g. a Soulseek temp track) rather than a
  // library track, so it should not advance to a "next" track on completion.
  bool get isPreview => mediaItem.valueOrNull?.extras?['streamUrl'] != null;

  // Mark a finished preview as paused at its start so it can be replayed.
  // Don't touch _audioPlayer here: on iOS the item is already released after
  // natural completion and re-poking it throws. Replay re-sets a fresh source.
  void pausePreviewAtStart() {
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        controls: [MediaControl.play],
        updatePosition: Duration.zero,
        processingState: AudioProcessingState.ready,
      ),
    );
  }

  void addMediaItem(Track track, {String? streamUrl}) {
    mediaItem.add(
      MediaItem(
        id: track.id,
        title: track.title,
        artist: track.artist,
        duration: Duration(seconds: track.duration),
        // streamUrl overrides the default /api/track/{id} source. Used for
        // Soulseek temp previews, which are not regular library tracks.
        extras: streamUrl != null ? {'streamUrl': streamUrl} : null,
      ),
    );
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (_) {
      // The source may already be released (e.g. a finished iOS preview).
      return;
    }
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
  }

  @override
  Future<void> play() async {
    final item = mediaItem.valueOrNull;
    if (item == null) return;

    final streamUrl = item.extras?['streamUrl'] as String?;
    if (streamUrl != null) {
      await _audioPlayer.play(UrlSource(streamUrl));
      playbackState.add(
        playbackState.value.copyWith(
          playing: true,
          controls: [MediaControl.pause],
          systemActions: const {MediaAction.seek},
          updatePosition: await _audioPlayer.getCurrentPosition() ?? Duration.zero,
          processingState: AudioProcessingState.ready,
        ),
      );
      return;
    }

    final trackId = item.id;
    final cachedFile = await cacheRepository.retrieveTrack(trackId);

    if (cachedFile == null) {
      await _audioPlayer.play(UrlSource('${appConfig.baseUrl}/api/track/$trackId'));
    } else {
      await _audioPlayer.play(DeviceFileSource(cachedFile.file.uri.path));
    }

    playbackState.add(
      playbackState.value.copyWith(
        playing: true,
        controls: [MediaControl.skipToPrevious, MediaControl.pause, MediaControl.skipToNext],
        systemActions: const {MediaAction.seek},
        updatePosition: await _audioPlayer.getCurrentPosition() ?? Duration.zero,
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
        controls: [MediaControl.skipToPrevious, MediaControl.play, MediaControl.skipToNext],
        systemActions: const {MediaAction.seek},
        updatePosition: await _audioPlayer.getCurrentPosition() ?? Duration.zero,
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
    if (settingsRepository.repeat) {
      stop();
      nextTrack =
          availableTracks.firstWhereOrNull((track) => track.id == mediaItem.valueOrNull!.id) ?? availableTracks.first;
    } else {
      if (settingsRepository.shuffle) {
        final nextTrackPosition = _shuffledNext(
          availableTracks,
          availableTracks.indexWhere((track) => track.id == mediaItem.value?.id),
        );
        nextTrack = availableTracks[nextTrackPosition];
      } else {
        final lastTrackPosition = availableTracks.indexWhere((track) => track.id == mediaItem.value?.id);
        final nextTrackPosition = lastTrackPosition < availableTracks.length - 1 ? lastTrackPosition + 1 : 0;
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
          availableTracks.indexWhere((track) => track.id == mediaItem.value?.id),
        );
        nextTrack = availableTracks[nextTrackPosition];
      } else {
        final lastTrackPosition = availableTracks.indexWhere((track) => track.id == mediaItem.value?.id);
        final previousTrackPosition = lastTrackPosition > 0 ? lastTrackPosition - 1 : availableTracks.length - 1;
        nextTrack = availableTracks[previousTrackPosition];
      }
    }

    addMediaItem(nextTrack);
    return play();
  }

  List<Track> _getAvailableTracks() {
    final isOffline = connectivityStatusRepository.statusSubject.value.contains(ConnectivityResult.none);

    return isOffline
        ? currentPlaylist.tracks.where((track) => cacheRepository.items.contains(track.id)).toList()
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
