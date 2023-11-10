import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../audio_player_handler.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repositories/connectivity_status_repository.dart';
import '../../repositories/tracks_repository.dart';
import '../cacher_bloc/cacher_bloc.dart';
import '../settings_bloc/settings_bloc.dart';
import 'player_event.dart';
import 'player_state.dart';

final random = Random();

class PlayerBloc extends Bloc<PlayerEvent, AudioPlayerState> {
  final ConnectivityStatusRepository connectivityStatusRepository;
  final TracksRepository tracksRepository;
  final AudioPlayerHandler audioHandler;
  final SettingsBloc settingsBloc;
  final CacherBloc cacherBloc;

  Playlist _currentPlaylist = Playlist.empty();
  Track currentTrack = Track.empty();

  PlayerBloc({
    required this.connectivityStatusRepository,
    required this.tracksRepository,
    required this.audioHandler,
    required this.settingsBloc,
    required this.cacherBloc,
  }) : super(InitialPlayerState(Track.empty())) {
    on<PlayEvent>(_onPlayEvent);
    on<PauseEvent>(_onPauseEvent);
    on<ResumeEvent>(_onResumeEvent);
    on<NextEvent>(_onNextEvent);
    on<PreviousEvent>(_onPreviousEvent);

    audioHandler.onPlayerComplete.listen((event) {
      add(NextEvent());
    });
  }

  FutureOr<void> _onPlayEvent(
    PlayEvent event,
    Emitter<AudioPlayerState> emit,
  ) async {
    _currentPlaylist =
        event.playlist ?? Playlist.anonymous(tracksRepository.items);

    currentTrack = event.track;
    audioHandler.addMediaItem(currentTrack);
    audioHandler.play();
    emit(PlayingPlayerState(event.track));
  }

  FutureOr<void> _onPauseEvent(
    PauseEvent event,
    Emitter<AudioPlayerState> emit,
  ) {
    audioHandler.pause();
    emit(PausedPlayerState(currentTrack));
  }

  FutureOr<void> _onResumeEvent(
    ResumeEvent event,
    Emitter<AudioPlayerState> emit,
  ) {
    audioHandler.resume();
    emit(ResumedPlayerState(currentTrack));
  }

  FutureOr<void> _onNextEvent(
    NextEvent event,
    Emitter<AudioPlayerState> emit,
  ) async {
    audioHandler.pause();

    final availableTracks = _getAvailableTracks();

    if (availableTracks.isEmpty) {
      emit(PausedPlayerState(currentTrack));
      return;
    }

    if (!settingsBloc.state.repeat) {
      if (settingsBloc.state.shuffle) {
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

    audioHandler.addMediaItem(currentTrack);
    audioHandler.play();

    emit(PlayingPlayerState(currentTrack));
  }

  FutureOr<void> _onPreviousEvent(
    PreviousEvent event,
    Emitter<AudioPlayerState> emit,
  ) async {
    audioHandler.pause();

    final availableTracks = _getAvailableTracks();

    if (availableTracks.isEmpty) {
      emit(PausedPlayerState(currentTrack));
      return;
    }

    if (!settingsBloc.state.repeat) {
      if (settingsBloc.state.shuffle) {
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

    audioHandler.addMediaItem(currentTrack);
    audioHandler.play();

    emit(PlayingPlayerState(currentTrack));
  }

  List<Track> _getAvailableTracks() {
    final isOffline = connectivityStatusRepository.statusSubject.value ==
        ConnectivityResult.none;

    return isOffline
        ? _currentPlaylist.tracks
            .where((track) => cacherBloc.state.cached.contains(track.id))
            .toList()
        : _currentPlaylist.tracks;
  }

  int _shuffledNext(List<Track> availableTracks, int excluding) {
    var result = random.nextInt(availableTracks.length);
    while (result == excluding) {
      result = random.nextInt(availableTracks.length);
    }
    return result;
  }
}
