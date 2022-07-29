import 'dart:async';
import 'dart:math';

import 'package:basement_music/library.dart';
import 'package:basement_music/models/track.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../audio_player.dart';
import '../models/playlist.dart';
import '../settings.dart';
import 'events/player_event.dart';
import 'states/audio_player_state.dart';

final random = Random();

class PlayerBloc extends Bloc<PlayerEvent, AudioPlayerState> {
  Track lastTrack = Track.empty();
  Playlist currentPlaylist = Playlist.all();

  PlayerBloc() : super(InitialPlayerState(Track.empty())) {
    on<PlayEvent>(_onPlayEvent);
    on<PauseEvent>(_onPauseEvent);
    on<ResumeEvent>(_onResumeEvent);
    on<NextEvent>(_onNextEvent);
    on<PreviousEvent>(_onPreviousEvent);
  }

  FutureOr<void> _onPlayEvent(PlayEvent event, Emitter<AudioPlayerState> emit) async {
    audioPlayer.customPlay(event.track.id);
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

  FutureOr<void> _onNextEvent(NextEvent event, Emitter<AudioPlayerState> emit) async {
    audioPlayer.stop();

    final repeat = await getRepeat();
    final shuffle = await getShuffle();

    if (!repeat) {
      if (shuffle) {
        final nextTrackPosition = _shuffledNext(tracks.indexOf(lastTrack));
        lastTrack = currentPlaylist.tracks[nextTrackPosition];
      } else {
        final lastTrackPosition = currentPlaylist.tracks.indexOf(lastTrack);
        final nextTrackPosition = lastTrackPosition < currentPlaylist.tracks.length - 1 ? lastTrackPosition + 1 : 0;
        lastTrack = currentPlaylist.tracks[nextTrackPosition];
      }
    }

    audioPlayer.customPlay(lastTrack.id);
    emit(PlayingPlayerState(lastTrack));
  }

  FutureOr<void> _onPreviousEvent(PreviousEvent event, Emitter<AudioPlayerState> emit) async {
    audioPlayer.stop();

    final repeat = await getRepeat();
    final shuffle = await getShuffle();

    if (!repeat) {
      if (shuffle) {
        final nextTrackPosition = _shuffledNext(currentPlaylist.tracks.indexOf(lastTrack));
        lastTrack = currentPlaylist.tracks[nextTrackPosition];
      } else {
        final lastTrackPosition = currentPlaylist.tracks.indexOf(lastTrack);
        final previousTrackPosition = lastTrackPosition > 0 ? lastTrackPosition - 1 : currentPlaylist.tracks.length - 1;
        lastTrack = currentPlaylist.tracks[previousTrackPosition];
      }
    }

    audioPlayer.customPlay(lastTrack.id);
    emit(PlayingPlayerState(lastTrack));
  }

  int _shuffledNext(int excluding) {
    var result = random.nextInt(currentPlaylist.tracks.length);
    while (result == excluding) {
      result = random.nextInt(currentPlaylist.tracks.length);
    }
    return result;
  }
}
