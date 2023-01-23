import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'api_service.dart';
import 'bloc/settings_bloc/settings_bloc.dart';
import 'models/playlist.dart';
import 'models/track.dart';
import 'utils/log/log_service.dart';

AudioPlayerHandler? audioHandler;

Future<void> initAudioHandler(ApiService apiService, SettingsBloc settingsBloc) async {
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(apiService, settingsBloc),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.lereena.basement-music.channel.audio',
      androidNotificationChannelName: 'Basement music',
      androidNotificationOngoing: true,
    ),
  );
}

final _random = Random();

class AudioPlayerHandler extends BaseAudioHandler {
  final ApiService _apiService;
  final SettingsBloc _settingsBloc;

  AudioPlayerHandler(this._apiService, this._settingsBloc) {
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          const MediaControl(action: MediaAction.skipToNext, androidIcon: 'skip_next', label: 'Next'),
          const MediaControl(action: MediaAction.skipToPrevious, androidIcon: 'skip_previous', label: 'Previous'),
        ],
      ),
    );
  }

  final _audioPlayer = AudioPlayer();

  Stream<void> get onPlayerComplete => _audioPlayer.onPlayerComplete;
  Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;

  Playlist currentPlaylist = Playlist.empty();
  Track currentTrack = Track.empty();

  void addMediaItem(Track track) {
    currentTrack = track;
    mediaItem.add(MediaItem(id: track.id, title: track.title, artist: track.artist));
  }

  @override
  Future<void> play() {
    addMediaItem(currentTrack);
    return _customPlay(currentTrack.id);
  }

  @override
  Future<void> pause() => _audioPlayer.pause();

  void resume() => _audioPlayer.resume();

  @override
  Future<void> skipToNext() {
    pause();

    if (!_settingsBloc.state.repeat) {
      if (_settingsBloc.state.shuffle) {
        final nextTrackPosition = _shuffledNext(currentPlaylist.tracks.indexOf(currentTrack), currentPlaylist);
        currentTrack = currentPlaylist.tracks[nextTrackPosition];
      } else {
        final lastTrackPosition = currentPlaylist.tracks.indexOf(currentTrack);
        final nextTrackPosition = lastTrackPosition < currentPlaylist.tracks.length - 1 ? lastTrackPosition + 1 : 0;
        currentTrack = currentPlaylist.tracks[nextTrackPosition];
      }
    }

    addMediaItem(currentTrack);
    playbackState.add(playbackState.value.copyWith());
    return play();
  }

  @override
  Future<void> skipToPrevious() {
    pause();

    if (!_settingsBloc.state.repeat) {
      if (_settingsBloc.state.shuffle) {
        final nextTrackPosition = _shuffledNext(currentPlaylist.tracks.indexOf(currentTrack), currentPlaylist);
        currentTrack = currentPlaylist.tracks[nextTrackPosition];
      } else {
        final lastTrackPosition = currentPlaylist.tracks.indexOf(currentTrack);
        final previousTrackPosition = lastTrackPosition > 0 ? lastTrackPosition - 1 : currentPlaylist.tracks.length - 1;
        currentTrack = currentPlaylist.tracks[previousTrackPosition];
      }
    }

    addMediaItem(currentTrack);
    return play();
  }

  Future<void> _customPlay(String trackId, {bool cached = false}) async {
    if (!cached) {
      await _audioPlayer.play(UrlSource(_apiService.trackPlayback(trackId)));
      return;
    }

    final trackUrl = (await DefaultCacheManager().getFileFromCache(trackId))?.file.uri.path;

    if (trackUrl == null) {
      LogService.log("Couldn't play cached track $trackId");
      return;
    }
    _audioPlayer.play(DeviceFileSource(trackUrl));
  }

  int _shuffledNext(int excluding, Playlist currentPlaylist) {
    var result = _random.nextInt(currentPlaylist.tracks.length);
    while (result == excluding) {
      result = _random.nextInt(currentPlaylist.tracks.length);
    }
    return result;
  }
}
