import 'dart:async';

import 'package:basement_music/logger.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_editor_cubit.freezed.dart';
part 'track_editor_state.dart';

class TrackEditorCubit extends Cubit<TrackEditorState> {
  final TracksRepository _tracksRepository;

  TrackEditorCubit(this._tracksRepository) : super(const TrackEditorState.initial());

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
}
