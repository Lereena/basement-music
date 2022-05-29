import 'dart:async';

import 'package:basement_music/library.dart';
import 'package:basement_music/models/track.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../audio_player.dart';
import 'events/player_event.dart';
import 'states/audio_player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, AudioPlayerState> {
  Track lastTrack = Track.empty();

  PlayerBloc() : super(InitialPlayerState(Track.empty())) {
    on<PlayEvent>(_onPlayEvent);
    on<PauseEvent>(_onPauseEvent);
    on<ResumeEvent>(_onResumeEvent);
    on<NextEvent>(_onNextEvent);
    on<PreviousEvent>(_onPreviousEvent);
  }

  FutureOr<void> _onPlayEvent(PlayEvent event, Emitter<AudioPlayerState> emit) async {
    audioPlayer.play('http://localhost:9000/track/${event.track.id}');
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

  FutureOr<void> _onNextEvent(NextEvent event, Emitter<AudioPlayerState> emit) {
    audioPlayer.stop();
    final lastTrackPosition = tracks.indexOf(lastTrack);
    final nextTrackPosition = lastTrackPosition < tracks.length - 1 ? lastTrackPosition + 1 : 0;
    lastTrack = tracks[nextTrackPosition];

    audioPlayer.play(lastTrack.url);
    emit(PlayingPlayerState(lastTrack));
  }

  FutureOr<void> _onPreviousEvent(PreviousEvent event, Emitter<AudioPlayerState> emit) {
    audioPlayer.stop();

    final lastTrackPosition = tracks.indexOf(lastTrack);
    final previousTrackPosition = lastTrackPosition > 0 ? lastTrackPosition - 1 : tracks.length - 1;
    lastTrack = tracks[previousTrackPosition];

    audioPlayer.play(lastTrack.url);
    emit(PlayingPlayerState(lastTrack));
  }
}
