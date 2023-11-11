import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../logger.dart';
import '../../repositories/tracks_repository.dart';

part 'track_editor_event.dart';
part 'track_editor_state.dart';

class TrackEditorBloc extends Bloc<TrackEditorEvent, TrackEditorState> {
  final TracksRepository _tracksRepository;

  TrackEditorBloc(this._tracksRepository) : super(TrackEditorInitial()) {
    on<TrackEditorEdited>(_onTrackEditorEdited);
  }

  FutureOr<void> _onTrackEditorEdited(
    TrackEditorEdited event,
    Emitter<TrackEditorState> emit,
  ) async {
    emit(TrackEditorLoadInProgress());

    try {
      await _tracksRepository.editTrack(
        id: event.trackId,
        artist: event.artist,
        title: event.title,
        cover: event.cover,
      );

      emit(TrackEditorSuccess());
    } catch (e) {
      emit(TrackEditorError());
      logger.e('Error editing track: $e');
    }
  }
}
