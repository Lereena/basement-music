import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../repositories/tracks_repository.dart';

part 'local_track_uploading_event.dart';
part 'local_track_uploading_state.dart';

class LocalTrackUploadingBloc
    extends Bloc<LocalTrackUploadingEvent, LocalTrackUploadingState> {
  final TracksRepository _tracksRepository;

  LocalTrackUploadingBloc(this._tracksRepository)
      : super(NoFileSelectedState()) {
    on<Start>(_onStart);
    on<FilesSelected>(_onFilesSelected);
    on<FilesApproved>(_onFilesApproved);
  }

  FutureOr<void> _onStart(
    Start event,
    Emitter<LocalTrackUploadingState> emit,
  ) {
    emit(NoFileSelectedState());
  }

  FutureOr<void> _onFilesSelected(
    FilesSelected event,
    Emitter<LocalTrackUploadingState> emit,
  ) {
    emit(FilesSelectedState(files: event.files));
  }

  FutureOr<void> _onFilesApproved(
    FilesApproved event,
    Emitter<LocalTrackUploadingState> emit,
  ) async {
    emit(LoadingState());
    final files = event.files
        .where((e) => e.file.bytes != null)
        .map((file) => (bytes: file.file.bytes!.toList(), filename: file.name))
        .toList();

    emit(UploadingStartedState());

    final result = await _tracksRepository.uploadLocalTracks(files);

    if (result) {
      await _tracksRepository.getAllTracks();
      emit(SuccessfulUploadState());
    } else {
      emit(ErrorState());
    }
  }
}
