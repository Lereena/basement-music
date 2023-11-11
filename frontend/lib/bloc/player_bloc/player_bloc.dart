import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../audio_player_handler.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repositories/repositories.dart';

part 'player_event.dart';
part 'player_state.dart';

final random = Random();

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final ConnectivityStatusRepository connectivityStatusRepository;
  final TracksRepository tracksRepository;
  final AudioPlayerHandler audioHandler;
  final SettingsRepository settingsRepository;
  final CacheRepository cacheRepository;

  Playlist _currentPlaylist = Playlist.empty();
  Track currentTrack = Track.empty();

  PlayerBloc({
    required this.connectivityStatusRepository,
    required this.tracksRepository,
    required this.audioHandler,
    required this.settingsRepository,
    required this.cacheRepository,
  }) : super(PlayerInitial(Track.empty())) {
    on<PlayerPlayStarted>(_onPlayStarted);
    on<PlayerPaused>(_onPaused);
    on<PlayerResumed>(_onResumed);
    on<PlayerNextStarted>(_onNextStarted);
    on<PlayerPreviousStarted>(_onPreviousStarted);
    on<PlayerTracksUpdated>(_onTracksUpdated);

    audioHandler.onPlayerComplete.listen((event) => add(PlayerNextStarted()));

    tracksRepository.tracksSubject.listen(
      (tracks) {
        if (currentTrack != Track.empty()) {
          add(
            PlayerTracksUpdated(
              tracks.firstWhere((track) => track.id == currentTrack.id),
            ),
          );
        }
      },
    );
  }

  FutureOr<void> _onPlayStarted(
    PlayerPlayStarted event,
    Emitter<PlayerState> emit,
  ) async {
    _currentPlaylist =
        event.playlist ?? Playlist.anonymous(tracksRepository.items);

    currentTrack = event.track;
    audioHandler.addMediaItem(currentTrack);
    audioHandler.play();
    emit(PlayerPlay(event.track));
  }

  FutureOr<void> _onPaused(
    PlayerPaused event,
    Emitter<PlayerState> emit,
  ) {
    audioHandler.pause();
    emit(PlayerPause(currentTrack));
  }

  FutureOr<void> _onResumed(
    PlayerResumed event,
    Emitter<PlayerState> emit,
  ) {
    audioHandler.resume();
    emit(PlayerResume(currentTrack));
  }

  FutureOr<void> _onNextStarted(
    PlayerNextStarted event,
    Emitter<PlayerState> emit,
  ) async {
    audioHandler.pause();

    final availableTracks = _getAvailableTracks();

    if (availableTracks.isEmpty) {
      emit(PlayerPause(currentTrack));
      return;
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

    audioHandler.addMediaItem(currentTrack);
    audioHandler.play();

    emit(PlayerPlay(currentTrack));
  }

  FutureOr<void> _onPreviousStarted(
    PlayerPreviousStarted event,
    Emitter<PlayerState> emit,
  ) async {
    audioHandler.pause();

    final availableTracks = _getAvailableTracks();

    if (availableTracks.isEmpty) {
      emit(PlayerPause(currentTrack));
      return;
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

    audioHandler.addMediaItem(currentTrack);
    audioHandler.play();

    emit(PlayerPlay(currentTrack));
  }

  FutureOr<void> _onTracksUpdated(
    PlayerTracksUpdated event,
    Emitter<PlayerState> emit,
  ) {
    currentTrack = event.track;
    audioHandler.addMediaItem(event.track);

    if (state is PlayerPlay) {
      emit(PlayerPlay(currentTrack));
    } else {
      emit(PlayerPause(currentTrack));
    }
  }

  List<Track> _getAvailableTracks() {
    final isOffline = connectivityStatusRepository.statusSubject.value ==
        ConnectivityResult.none;

    return isOffline
        ? _currentPlaylist.tracks
            .where((track) => cacheRepository.items.contains(track.id))
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
