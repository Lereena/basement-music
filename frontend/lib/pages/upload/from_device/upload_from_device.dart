import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/track_uploader_bloc/track_uploader_bloc.dart';
import '../../../repositories/tracks_repository.dart';
import '../../../routing/routes.dart';
import '../../../utils/track_data.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/dialogs/track_edit_dialog.dart';
import '../result_page.dart';
import '../upload_is_in_progress_page.dart';
import 'files_input_page.dart';

class UploadFromDevicePage extends StatelessWidget {
  const UploadFromDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TracksUploaderBloc(context.read<TracksRepository>()),
      child: const _UploadFromDevice(),
    );
  }
}

class _UploadFromDevice extends StatelessWidget {
  const _UploadFromDevice();

  @override
  Widget build(BuildContext context) {
    final trackUploadingBloc = context.read<TracksUploaderBloc>();

    return Scaffold(
      appBar: BasementAppBar(title: 'Upload from device'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<TracksUploaderBloc, TracksUploaderState>(
            builder: (context, state) {
              if (state is TracksUploaderFilesSelectStart) {
                return FilesInputPage(
                  onSelectFiles: () => _onSelectFiles(context),
                  onCancel: () => context.pop(),
                );
              }

              if (state is TracksUploaderFilesSelectSuccess) {
                return FilesInputPage(
                  selectedFiles: state.files,
                  onSelectFiles: () => _onSelectFiles(
                    context,
                    currentFiles: state.files,
                  ),
                  onMoveNext: () => trackUploadingBloc
                      .add(TracksUploaderFilesApproved(files: state.files)),
                  onRemoveFile: (file) {
                    state.files.removeWhere((element) => element.file == file);
                    trackUploadingBloc
                        .add(TracksUploaderFilesSelected(files: state.files));
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

                        trackUploadingBloc.add(
                          TracksUploaderFilesSelected(files: state.files),
                        );
                      },
                    );
                  },
                  onCancel: () => context.pop(),
                );
              }

              if (state is TracksUploaderUploadInProgress) {
                return UploadIsInProgressPage(
                  onUploadOtherTrack: () => _onUploadOtherTrack(context),
                );
              }

              if (state is TracksUploaderUploadSucces ||
                  state is TracksUploaderUploadError) {
                return ResultPage(
                  result: state is TracksUploaderUploadSucces
                      ? Result.success
                      : Result.fail,
                  successMessage: 'Track was successfully uploaded',
                  failMessage:
                      'Track uploading is failed, please try again later',
                  buttonText: 'OK',
                  onLeavePage: () => _onUploadOtherTrack(context),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onSelectFiles(
    BuildContext context, {
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

    if (context.mounted) {
      context
          .read<TracksUploaderBloc>()
          .add(TracksUploaderFilesSelected(files: selectedFiles));
    }
  }

  void _onUploadOtherTrack(BuildContext context) {
    context.go(RouteName.upload);
    context.read<TracksUploaderBloc>().add(TracksUploaderStarted());
  }
}
