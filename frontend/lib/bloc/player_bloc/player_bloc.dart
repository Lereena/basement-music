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
    on<PlayerPlayedExternally>(_onPlayerPlayedExternally);
    on<PlayerNextStarted>(_onNextStarted);
    on<PlayerPreviousStarted>(_onPreviousStarted);
    on<PlayerTracksUpdated>(_onTracksUpdated);

    audioHandler.onPlayerComplete.listen((_) => add(PlayerNextStarted()));

    audioHandler.playbackState.listen(
      (state) => add(
        state.playing ? PlayerPlayedExternally() : PlayerPausedExternally(),
      ),
    );

    tracksRepository.tracksSubject.listen(
      (tracks) {
        if (state.currentTrack != Track.empty()) {
          add(
            PlayerTracksUpdated(
              tracks.firstWhere((track) => track.id == state.currentTrack.id),
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
    audioHandler.currentPlaylist =
        event.playlist ?? Playlist.anonymous(tracksRepository.items);

    audioHandler.addMediaItem(event.track);

    await audioHandler.play();

    emit(PlayerPlay(event.track));
  }

  FutureOr<void> _onPlayerPlayedExternally(
    PlayerPlayedExternally event,
    Emitter<PlayerState> emit,
  ) {
    emit(PlayerPlay(_currentTrack));
  }

  FutureOr<void> _onPaused(
    PlayerPaused event,
    Emitter<PlayerState> emit,
  ) {
    audioHandler.pause();

    emit(PlayerPause(state.currentTrack));
  }

  FutureOr<void> _onPlayerPausedExternally(
    PlayerPausedExternally event,
    Emitter<PlayerState> emit,
  ) {
    emit(PlayerPause(state.currentTrack));
  }

  FutureOr<void> _onNextStarted(
    PlayerNextStarted event,
    Emitter<PlayerState> emit,
  ) async {
    await audioHandler.skipToNext();

    emit(PlayerPlay(_currentTrack));
  }

  FutureOr<void> _onPreviousStarted(
    PlayerPreviousStarted event,
    Emitter<PlayerState> emit,
  ) async {
    await audioHandler.skipToPrevious();

    emit(PlayerPlay(_currentTrack));
  }

  FutureOr<void> _onTracksUpdated(
    PlayerTracksUpdated event,
    Emitter<PlayerState> emit,
  ) {
    if (state is PlayerPlay) {
      emit(PlayerPlay(event.track));
    } else {
      emit(PlayerPause(event.track));
    }
  }

  Track get _currentTrack => tracksRepository.items
      .firstWhere((track) => track.id == audioHandler.mediaItem.value?.id);
}
