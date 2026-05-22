import 'dart:async';

import 'package:basement_music/logger.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_uploader_cubit.freezed.dart';
part 'track_uploader_state.dart';

class TracksUploaderCubit extends Cubit<TracksUploaderState> {
  final TracksRepository _tracksRepository;

  TracksUploaderCubit(this._tracksRepository) : super(const TracksUploaderState.filesSelectStart());

  void start() {
    emit(const TracksUploaderState.filesSelectStart());
  }

  void selectFiles(List<({String name, PlatformFile file})> files) {
    emit(TracksUploaderState.filesSelectSuccess(files: files));
  }

  Future<void> approveFiles(List<({String name, PlatformFile file})> files) async {
    emit(const TracksUploaderState.uploadInProgress());

    final uploadReady = files
        .where((e) => e.file.bytes != null)
        .map((file) => (bytes: file.file.bytes!.toList(), filename: file.name))
        .toList();

    try {
      await _tracksRepository.uploadLocalTracks(uploadReady);

      emit(const TracksUploaderState.uploadSuccess());

      await _tracksRepository.getAllTracks();
    } catch (e) {
      emit(const TracksUploaderState.uploadError());
      logger.e('Error uploading files: $e');
    }
  }
}
