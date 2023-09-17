import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/local_track_uploading_bloc/local_track_uploading_bloc.dart';
import '../../utils/track_data.dart';
import '../../widgets/dialogs/track_edit_dialog.dart';
import 'files_input_page.dart';
import 'upload_is_in_progress_page.dart';
import 'youtube/error_page.dart';
import 'youtube/result_page.dart';

class UploadFromDevice extends StatelessWidget {
  final Function onCancelPressed;
  final LocalTrackUploadingBloc trackUploadingBloc;

  const UploadFromDevice({
    required this.onCancelPressed,
    required this.trackUploadingBloc,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<LocalTrackUploadingBloc, LocalTrackUploadingState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NoFileSelectedState) {
              return FilesInputPage(
                onSelectFiles: () => _onSelectFiles(),
              );
            }

            if (state is FilesSelectedState) {
              return FilesInputPage(
                selectedFiles: state.files,
                onSelectFiles: () => _onSelectFiles(currentFiles: state.files),
                onMoveNext: () =>
                    trackUploadingBloc.add(FilesApproved(files: state.files)),
                onRemoveFile: (file) {
                  state.files.removeWhere((element) => element.file == file);
                  trackUploadingBloc.add(FilesSelected(files: state.files));
                },
                onEditFileInfo: (fileInfo) {
                  final (artist, title) = getArtistAndTitle(fileInfo.name);

                  TrackEditDialog.show(
                    context: context,
                    artist: artist,
                    title: title,
                    onSubmit: (result) {
                      final fileIndex = state.files.indexWhere(
                        (element) => element.file == fileInfo.file,
                      );
                      state.files.removeAt(fileIndex);
                      state.files.insert(
                        fileIndex,
                        (
                          file: fileInfo.file,
                          name: constructFilename(result.artist, result.title)
                        ),
                      );

                      trackUploadingBloc.add(FilesSelected(files: state.files));
                    },
                  );
                },
              );
            }

            if (state is UploadingStartedState) {
              return UploadIsInProgressPage(
                onUploadOtherTrack: () => trackUploadingBloc.add(Start()),
              );
            }

            if (state is SuccessfulUploadState) {
              return ResultPage(
                result: true,
                onUploadOtherTrackPress: () => trackUploadingBloc.add(Start()),
              );
            }

            return ErrorPage(
              onTryAgainPress: () => trackUploadingBloc.add(Start()),
            );
          },
        ),
      ],
    );
  }

  Future<void> _onSelectFiles({
    List<({String name, PlatformFile file})>? currentFiles,
  }) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['mp3', 'm4a'],
    );

    if (result == null) return;

    final newFiles = result.files.where(
      (file) => currentFiles?.any((element) => element.file == file) != true,
    );

    final selectedFiles = currentFiles ?? [];
    selectedFiles.addAll(newFiles.map((file) => (name: file.name, file: file)));

    trackUploadingBloc.add(FilesSelected(files: selectedFiles));
  }
}
