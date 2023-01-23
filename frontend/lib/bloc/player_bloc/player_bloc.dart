import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../audio_player_handler.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repositories/tracks_repository.dart';
import '../cacher_bloc/bloc/cacher_bloc.dart';
import 'player_event.dart';
import 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, AudioPlayerState> {
  final TracksRepository _tracksRepository;
  final CacherBloc _cacherBloc;

  final AudioPlayerHandler _audioHandler = audioHandler!;

  Stream<Duration> get onPositionChanged => _audioHandler.onPositionChanged;

  Playlist get currentPlaylist => _audioHandler.currentPlaylist;
  set currentPlaylist(Playlist playlist) => _audioHandler.currentPlaylist = playlist;

  Track get currentTrack => _audioHandler.currentTrack;
  set currentTrack(Track track) => _audioHandler.currentTrack = track;

  PlayerBloc(
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

  FutureOr<void> _onPlayEvent(PlayEvent event, Emitter<AudioPlayerState> emit) async {
    if (currentPlaylist == Playlist.empty()) {
      currentPlaylist = Playlist.anonymous(_tracksRepository.items);
    }

    currentTrack = event.track;
    await _audioHandler.play();

    emit(PlayingPlayerState(currentTrack));
  }

  FutureOr<void> _onPauseEvent(PauseEvent event, Emitter<AudioPlayerState> emit) {
    _audioHandler.pause();

    emit(PausedPlayerState(currentTrack));
  }

  FutureOr<void> _onResumeEvent(ResumeEvent event, Emitter<AudioPlayerState> emit) {
    _audioHandler.resume();

    emit(ResumedPlayerState(currentTrack));
  }

  FutureOr<void> _onNextEvent(NextEvent event, Emitter<AudioPlayerState> emit) async {
    await _audioHandler.skipToNext();

    emit(PlayingPlayerState(currentTrack));
  }

  FutureOr<void> _onPreviousEvent(PreviousEvent event, Emitter<AudioPlayerState> emit) async {
    await _audioHandler.skipToPrevious();

    emit(PlayingPlayerState(currentTrack));
  }
}
