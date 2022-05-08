import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:basement_music/models/track.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events/player_event.dart';
import 'states/player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, AudioPlayerState> {
  final audioPlayer = AudioPlayer();
  Track lastTrack = Track.empty();

  PlayerBloc() : super(InitialPlayerState(Track.empty())) {
    on<PlayEvent>(_onPlayEvent);
    on<PauseEvent>(_onPauseEvent);
    on<ResumeEvent>(_onResumeEvent);
  }

  FutureOr<void> _onPlayEvent(PlayEvent event, Emitter<AudioPlayerState> emit) {
    audioPlayer.play(event.track.url);
    lastTrack = event.track;
    emit(PlayingPlayerState(event.track));
  }

  FutureOr<void> _onPauseEvent(PauseEvent event, Emitter<AudioPlayerState> emit) {
    audioPlayer.pause();
    emit(PausedPlayerState(lastTrack));
  }

  FutureOr<void> _onResumeEvent(ResumeEvent event, Emitter<AudioPlayerState> emit) {
    audioPlayer.resume();
    emit(ResumedPlayerState(lastTrack));
  }
}
