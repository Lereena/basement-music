import 'dart:async';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/lyrics_repository.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_editor_cubit.freezed.dart';
part 'track_editor_state.dart';

class TrackEditorCubit extends Cubit<TrackEditorState> {
  final TracksRepository _tracksRepository;
  final LyricsRepository _lyricsRepository;

  TrackEditorCubit(this._tracksRepository, this._lyricsRepository) : super(const TrackEditorState.initial());

  Future<void> editTrack({
    required String trackId,
    required String title,
    required String artist,
    required String cover,
  }) async {
    emit(const TrackEditorState.loadInProgress());

    try {
      await _tracksRepository.editTrack(id: trackId, artist: artist, title: title, cover: cover);
      emit(const TrackEditorState.success());
    } catch (e) {
      emit(const TrackEditorState.error());
      logger.e('Error editing track: $e');
    }
  }

  Future<void> uploadLyrics({required Track track, required String lyricsText}) async {
    emit(const TrackEditorState.loadInProgress());

    try {
      final updated = await _lyricsRepository.saveLyrics(track, lyricsText);
      _tracksRepository.applyTrackUpdate(updated);
      emit(const TrackEditorState.success(message: 'Lyrics were saved to the track'));
    } catch (e) {
      emit(const TrackEditorState.error());
      logger.e('Error uploading lyrics: $e');
    }
  }
}
