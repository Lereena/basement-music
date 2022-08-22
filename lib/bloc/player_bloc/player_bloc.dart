import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../audioplayer_extensions.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repositories/tracks_repository.dart';
import '../cacher_bloc/bloc/cacher_bloc.dart';
import '../settings_bloc/settings_bloc.dart';
import 'player_event.dart';
import 'player_state.dart';

final random = Random();

class PlayerBloc extends Bloc<PlayerEvent, AudioPlayerState> {
  final _audioPlayer = AudioPlayer();
  late final onPositionChanged = _audioPlayer.onPositionChanged;

  final TracksRepository _tracksRepository;
  final SettingsBloc _settingsBloc;
  final CacherBloc _cacherBloc;

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

    _audioPlayer.onPlayerComplete.listen((event) {
      add(NextEvent());
    });
  }

  FutureOr<void> _onPlayEvent(PlayEvent event, Emitter<AudioPlayerState> emit) async {
    if (currentPlaylist == Playlist.empty()) {
      currentPlaylist = Playlist(id: '', title: '', tracks: _tracksRepository.items);
    }

    final cached = _cacherBloc.state.isCached([event.track.id]);

    _audioPlayer.customPlay(event.track.id, cached: cached);
    currentTrack = event.track;
    emit(PlayingPlayerState(event.track));
  }

  FutureOr<void> _onPauseEvent(PauseEvent event, Emitter<AudioPlayerState> emit) {
    _audioPlayer.pause();
    emit(PausedPlayerState(currentTrack));
  }

  FutureOr<void> _onResumeEvent(ResumeEvent event, Emitter<AudioPlayerState> emit) {
    _audioPlayer.resume();
    emit(ResumedPlayerState(currentTrack));
  }

  FutureOr<void> _onNextEvent(NextEvent event, Emitter<AudioPlayerState> emit) async {
    _audioPlayer.pause();

    if (!_settingsBloc.state.repeat) {
      if (_settingsBloc.state.shuffle) {
        final nextTrackPosition = _shuffledNext(currentPlaylist.tracks.indexOf(currentTrack));
        currentTrack = currentPlaylist.tracks[nextTrackPosition];
      } else {
        final lastTrackPosition = currentPlaylist.tracks.indexOf(currentTrack);
        final nextTrackPosition = lastTrackPosition < currentPlaylist.tracks.length - 1 ? lastTrackPosition + 1 : 0;
        currentTrack = currentPlaylist.tracks[nextTrackPosition];
      }
    }

    final cached = _cacherBloc.state.isCached([currentTrack.id]);

    _audioPlayer.customPlay(currentTrack.id, cached: cached);
    emit(PlayingPlayerState(currentTrack));
  }

  FutureOr<void> _onPreviousEvent(PreviousEvent event, Emitter<AudioPlayerState> emit) async {
    _audioPlayer.pause();

    if (!_settingsBloc.state.repeat) {
      if (_settingsBloc.state.shuffle) {
        final nextTrackPosition = _shuffledNext(currentPlaylist.tracks.indexOf(currentTrack));
        currentTrack = currentPlaylist.tracks[nextTrackPosition];
      } else {
        final lastTrackPosition = currentPlaylist.tracks.indexOf(currentTrack);
        final previousTrackPosition = lastTrackPosition > 0 ? lastTrackPosition - 1 : currentPlaylist.tracks.length - 1;
        currentTrack = currentPlaylist.tracks[previousTrackPosition];
      }
    }

    final cached = _cacherBloc.state.isCached([currentTrack.id]);

    _audioPlayer.customPlay(currentTrack.id, cached: cached);
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
