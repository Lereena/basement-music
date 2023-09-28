import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import '../../audio_player_handler.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repositories/tracks_repository.dart';
import '../cacher_bloc/cacher_bloc.dart';
import '../connectivity_status_bloc/connectivity_status_cubit.dart';
import '../settings_bloc/settings_bloc.dart';
import 'player_event.dart';
import 'player_state.dart';

final random = Random();

class PlayerBloc extends Bloc<PlayerEvent, AudioPlayerState> {
  final TracksRepository tracksRepository;
  final SettingsBloc settingsBloc;
  final CacherBloc cacherBloc;
  final ConnectivityStatusCubit connectivityStatusCubit;

  final AudioPlayerHandler _audioHandler = audioHandler;
  late final onPositionChanged = _audioHandler.onPositionChanged;

  Playlist currentPlaylist = Playlist.empty();
  Track currentTrack = Track.empty();

  PlayerBloc({
    required this.tracksRepository,
    required this.settingsBloc,
    required this.cacherBloc,
    required this.connectivityStatusCubit,
  }) : super(InitialPlayerState(Track.empty())) {
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
      currentPlaylist = Playlist.anonymous(tracksRepository.items);
    }

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

    _audioHandler.addMediaItem(currentTrack);
    _audioHandler.play();

    emit(PlayingPlayerState(currentTrack));
  }

  FutureOr<void> _onPreviousEvent(
    PreviousEvent event,
    Emitter<AudioPlayerState> emit,
  ) async {
    _audioHandler.pause();

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

    _audioHandler.addMediaItem(currentTrack);
    _audioHandler.play();

    emit(PlayingPlayerState(currentTrack));
  }

  List<Track> _getAvailableTracks() {
    final isOffline = connectivityStatusCubit.state is NoConnectionState;

    return isOffline
        ? currentPlaylist.tracks
            .where((track) => cacherBloc.state.cached.contains(track.id))
            .toList()
        : currentPlaylist.tracks;
  }

  int _shuffledNext(List<Track> availableTracks, int excluding) {
    var result = random.nextInt(availableTracks.length);
    while (result == excluding) {
      result = random.nextInt(availableTracks.length);
    }
    return result;
  }
}
