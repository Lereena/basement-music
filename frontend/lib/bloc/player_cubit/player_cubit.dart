import 'dart:async';

import 'package:basement_music/audio_player_handler.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_cubit.freezed.dart';
part 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  final TracksRepository tracksRepository;
  final AudioPlayerHandler audioHandler;

  PlayerCubit({required this.tracksRepository, required this.audioHandler})
    : super(PlayerState.initial(currentTrack: Track.empty())) {
    audioHandler.onPlayerComplete.listen((_) => next());

    audioHandler.playbackState.listen((playbackState) {
      if (playbackState.playing) {
        _playByExternalControls();
      } else {
        _pauseExternally();
      }
    });

    tracksRepository.tracksSubject.listen((tracks) {
      if (state.currentTrack != Track.empty() && tracks.isNotEmpty) {
        _updateTrack(tracks.firstWhere((track) => track.id == state.currentTrack.id));
      }
    });
  }

  Future<void> play({required Track track, Playlist? playlist, String? streamUrl}) async {
    audioHandler.currentPlaylist = playlist ?? Playlist.anonymous(tracksRepository.items);
    audioHandler.addMediaItem(track, streamUrl: streamUrl);
    await audioHandler.play();
    emit(PlayerState.play(currentTrack: track));
  }

  Future<void> pause() async {
    await audioHandler.pause();
    emit(PlayerState.pause(currentTrack: state.currentTrack));
  }

  Future<void> playByShortcut() async {
    await audioHandler.play();
    emit(PlayerState.play(currentTrack: _currentTrack));
  }

  Future<void> next() async {
    await audioHandler.skipToNext();
    emit(PlayerState.play(currentTrack: _currentTrack));
  }

  Future<void> previous() async {
    await audioHandler.skipToPrevious();
    emit(PlayerState.play(currentTrack: _currentTrack));
  }

  void _playByExternalControls() {
    emit(PlayerState.play(currentTrack: _currentTrack));
  }

  void _pauseExternally() {
    emit(PlayerState.pause(currentTrack: state.currentTrack));
  }

  void _updateTrack(Track track) {
    state.maybeMap(
      play: (_) => emit(PlayerState.play(currentTrack: track)),
      orElse: () => emit(PlayerState.pause(currentTrack: track)),
    );
  }

  Track get _currentTrack => tracksRepository.items.firstWhere(
    (track) => track.id == audioHandler.mediaItem.value?.id,
    orElse: () => state.currentTrack,
  );
}
