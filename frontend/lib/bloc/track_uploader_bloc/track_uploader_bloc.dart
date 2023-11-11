import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../logger.dart';
import '../../repositories/tracks_repository.dart';

part 'track_uploader_event.dart';
part 'track_uploader_state.dart';

class TracksUploaderBloc
    extends Bloc<TracksUploaderEvent, TracksUploaderState> {
  final TracksRepository _tracksRepository;

  TracksUploaderBloc(this._tracksRepository)
      : super(TracksUploaderFilesSelectStart()) {
    on<TracksUploaderStarted>(_onTracksUploaderStarted);
    on<TracksUploaderFilesSelected>(_onTracksUploaderFilesSelected);
    on<TracksUploaderFilesApproved>(_onTracksUploaderFilesApproved);
  }

  FutureOr<void> _onTracksUploaderStarted(
    TracksUploaderStarted event,
    Emitter<TracksUploaderState> emit,
  ) {
    emit(TracksUploaderFilesSelectStart());
  }

  FutureOr<void> _onTracksUploaderFilesSelected(
    TracksUploaderFilesSelected event,
    Emitter<TracksUploaderState> emit,
  ) {
    emit(TracksUploaderFilesSelectSuccess(files: event.files));
  }

  FutureOr<void> _onTracksUploaderFilesApproved(
    TracksUploaderFilesApproved event,
    Emitter<TracksUploaderState> emit,
  ) async {
    emit(TracksUploaderUploadInProgress());

    final files = event.files
        .where((e) => e.file.bytes != null)
        .map((file) => (bytes: file.file.bytes!.toList(), filename: file.name))
        .toList();

    try {
      await _tracksRepository.uploadLocalTracks(files);

      emit(TracksUploaderUploadSucces());
      await _tracksRepository.getAllTracks();
    } catch (e) {
      emit(TracksUploaderUploadError());
      logger.e('Error uploading files: $e');
    }
  }
}
