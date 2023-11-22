import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../audio_player_handler.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repositories/repositories.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final TracksRepository tracksRepository;
  final AudioPlayerHandler audioHandler;

  PlayerBloc({
    required this.tracksRepository,
    required this.audioHandler,
  }) : super(PlayerInitial(Track.empty())) {
    on<PlayerPlayStarted>(_onPlayStarted);
    on<PlayerPaused>(_onPaused);
    on<PlayerPausedExternally>(_onPlayerPausedExternally);
    on<PlayerResumed>(_onResumed);
    on<PlayerResumedExternally>(_onPlayerResumedExternally);
    on<PlayerNextStarted>(_onNextStarted);
    on<PlayerPreviousStarted>(_onPreviousStarted);
    on<PlayerTracksUpdated>(_onTracksUpdated);

    audioHandler.onPlayerComplete.listen((_) => add(PlayerNextStarted()));

    audioHandler.playbackState.listen(
      (state) => add(
        state.playing ? PlayerResumedExternally() : PlayerPausedExternally(),
      ),
    );

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

  Playlist get currentPlaylist => audioHandler.currentPlaylist;
  set currentPlaylist(Playlist playlist) =>
      audioHandler.currentPlaylist = playlist;

  Track get currentTrack => audioHandler.currentTrack;
  set currentTrack(Track track) => audioHandler.currentTrack = track;

  FutureOr<void> _onPlayStarted(
    PlayerPlayStarted event,
    Emitter<PlayerState> emit,
  ) async {
    currentPlaylist =
        event.playlist ?? Playlist.anonymous(tracksRepository.items);
    currentTrack = event.track;

    await audioHandler.play();

    emit(PlayerPlay(event.track));
  }

  FutureOr<void> _onPaused(
    PlayerPaused event,
    Emitter<PlayerState> emit,
  ) {
    audioHandler.pause();

    emit(PlayerPause(currentTrack));
  }

  FutureOr<void> _onPlayerPausedExternally(
    PlayerPausedExternally event,
    Emitter<PlayerState> emit,
  ) {
    emit(PlayerPause(currentTrack));
  }

  FutureOr<void> _onResumed(
    PlayerResumed event,
    Emitter<PlayerState> emit,
  ) {
    audioHandler.resume();

    emit(PlayerResume(currentTrack));
  }

  FutureOr<void> _onPlayerResumedExternally(
    PlayerResumedExternally event,
    Emitter<PlayerState> emit,
  ) {
    if (state is! PlayerPlay) {
      emit(PlayerResume(currentTrack));
    }
  }

  FutureOr<void> _onNextStarted(
    PlayerNextStarted event,
    Emitter<PlayerState> emit,
  ) async {
    await audioHandler.skipToNext();

    emit(PlayerPlay(currentTrack));
  }

  FutureOr<void> _onPreviousStarted(
    PlayerPreviousStarted event,
    Emitter<PlayerState> emit,
  ) async {
    await audioHandler.skipToPrevious();

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
}
