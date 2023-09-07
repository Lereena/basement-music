import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import '../../audio_player_handler.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repositories/tracks_repository.dart';
import '../cacher_bloc/bloc/cacher_bloc.dart';
import '../settings_bloc/settings_bloc.dart';
import 'player_event.dart';
import 'player_state.dart';

final random = Random();

class PlayerBloc extends Bloc<PlayerEvent, AudioPlayerState> {
  final TracksRepository _tracksRepository;
  final SettingsBloc _settingsBloc;
  final CacherBloc _cacherBloc;

  final AudioPlayerHandler _audioHandler = audioHandler;
  late final onPositionChanged = _audioHandler.onPositionChanged;

  Playlist currentPlaylist = Playlist.empty();
  Track currentTrack = Track.empty();

  PlayerBloc(
    this._settingsBloc,
    this._tracksRepository,
    this._cacherBloc,
  ) : super(InitialPlayerState(Track.empty())) {
    on<PlayEvent>(_onPlayEvent);
    on<PauseEvent>(_onPauseEvent);
    on<ResumeEvent>(_onResumeEvent);
    on<NextEvent>(_onNextEvent);
    on<PreviousEvent>(_onPreviousEvent);

    _audioHandler.onPlayerComplete.listen((event) {
      add(NextEvent());
    });
  }

  FutureOr<void> _onPlayEvent(
    PlayEvent event,
    Emitter<AudioPlayerState> emit,
  ) async {
    if (currentPlaylist == Playlist.empty()) {
      currentPlaylist = Playlist.anonymous(_tracksRepository.items);
    }

    // final cached = _cacherBloc.state.isCached([event.track.id]);

    currentTrack = event.track;
    _audioHandler.addMediaItem(currentTrack);
    _audioHandler.play();
    emit(PlayingPlayerState(event.track));
  }

  FutureOr<void> _onPauseEvent(
    PauseEvent event,
    Emitter<AudioPlayerState> emit,
  ) {
    _audioHandler.pause();
    emit(PausedPlayerState(currentTrack));
  }

  FutureOr<void> _onResumeEvent(
    ResumeEvent event,
    Emitter<AudioPlayerState> emit,
  ) {
    _audioHandler.resume();
    emit(ResumedPlayerState(currentTrack));
  }

  FutureOr<void> _onNextEvent(
    NextEvent event,
    Emitter<AudioPlayerState> emit,
  ) async {
    _audioHandler.pause();

    if (!_settingsBloc.state.repeat) {
      if (_settingsBloc.state.shuffle) {
        final nextTrackPosition =
            _shuffledNext(currentPlaylist.tracks.indexOf(currentTrack));
        currentTrack = currentPlaylist.tracks[nextTrackPosition];
      } else {
        final lastTrackPosition = currentPlaylist.tracks.indexOf(currentTrack);
        final nextTrackPosition =
            lastTrackPosition < currentPlaylist.tracks.length - 1
                ? lastTrackPosition + 1
                : 0;
        currentTrack = currentPlaylist.tracks[nextTrackPosition];
      }
    }

    // final cached = _cacherBloc.state.isCached([currentTrack.id]);

    _audioHandler.addMediaItem(currentTrack);
    _audioHandler.play();

    emit(PlayingPlayerState(currentTrack));
  }

  FutureOr<void> _onPreviousEvent(
    PreviousEvent event,
    Emitter<AudioPlayerState> emit,
  ) async {
    _audioHandler.pause();

    if (!_settingsBloc.state.repeat) {
      if (_settingsBloc.state.shuffle) {
        final nextTrackPosition =
            _shuffledNext(currentPlaylist.tracks.indexOf(currentTrack));
        currentTrack = currentPlaylist.tracks[nextTrackPosition];
      } else {
        final lastTrackPosition = currentPlaylist.tracks.indexOf(currentTrack);
        final previousTrackPosition = lastTrackPosition > 0
            ? lastTrackPosition - 1
            : currentPlaylist.tracks.length - 1;
        currentTrack = currentPlaylist.tracks[previousTrackPosition];
      }
    }

    // final cached = _cacherBloc.state.isCached([currentTrack.id]);

    _audioHandler.addMediaItem(currentTrack);
    _audioHandler.play();

    emit(PlayingPlayerState(currentTrack));
  }

  int _shuffledNext(int excluding) {
    var result = random.nextInt(currentPlaylist.tracks.length);
    while (result == excluding) {
      result = random.nextInt(currentPlaylist.tracks.length);
    }
    return result;
  }
}
