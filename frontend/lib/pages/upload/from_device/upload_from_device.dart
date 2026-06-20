import 'package:basement_music/bloc/track_uploader_cubit/track_uploader_cubit.dart';
import 'package:basement_music/pages/upload/from_device/files_input_page.dart';
import 'package:basement_music/pages/upload/result_page.dart';
import 'package:basement_music/pages/upload/upload_is_in_progress_page.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:basement_music/routing/routes.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/utils/track_data.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:basement_music/widgets/dialogs/track_edit_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UploadFromDevicePage extends StatelessWidget {
  const UploadFromDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TracksUploaderCubit(context.read<TracksRepository>()),
      child: const _UploadFromDevice(),
    );
  }
}

class _UploadFromDevice extends StatelessWidget {
  const _UploadFromDevice();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TracksUploaderCubit>();

    return Scaffold(
      appBar: BasementAppBar(title: 'Upload from device'),
      body: HorizontalSpaceReducer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<TracksUploaderCubit, TracksUploaderState>(
              builder: (context, state) => state.when(
                filesSelectStart: () =>
                    FilesInputPage(onSelectFiles: () => _onSelectFiles(context), onCancel: () => context.pop()),
                filesSelectSuccess: (files) => FilesInputPage(
                  selectedFiles: files,
                  onSelectFiles: () => _onSelectFiles(context, currentFiles: files),
                  onMoveNext: () => cubit.approveFiles(files),
                  onRemoveFile: (file) {
                    files.removeWhere((element) => element.file == file);
                    cubit.selectFiles(files);
                  },
                  onEditFileInfo: (fileInfo) {
                    final (artist, title) = getArtistAndTitle(fileInfo.name);

                    TrackEditDialog.show(
                      context: context,
                      artist: artist,
                      title: title,
                      onSubmit: (result) {
                        final fileIndex = files.indexWhere((element) => element.file == fileInfo.file);
                        files.removeAt(fileIndex);
                        files.insert(fileIndex, (
                          file: fileInfo.file,
                          name: constructFilename(result.artist, result.title),
                        ));
                        cubit.selectFiles(files);
                      },
                    );
                  },
                  onCancel: () => context.pop(),
                ),
                uploadInProgress: () => UploadIsInProgressPage(onUploadOtherTrack: () => _onUploadOtherTrack(context)),
                uploadSuccess: () => ResultPage(
                  result: Result.success,
                  successMessage: 'Track was successfully uploaded',
                  failMessage: 'Track uploading is failed, please try again later',
                  buttonText: 'OK',
                  onLeavePage: () => _onUploadOtherTrack(context),
                ),
                uploadError: () => ResultPage(
                  result: Result.fail,
                  successMessage: 'Track was successfully uploaded',
                  failMessage: 'Track uploading is failed, please try again later',
                  buttonText: 'OK',
                  onLeavePage: () => _onUploadOtherTrack(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSelectFiles(BuildContext context, {List<({String name, PlatformFile file})>? currentFiles}) async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['mp3', 'm4a'],
    );

    if (result == null) return;

    final newFiles = result.files.where((file) => currentFiles?.any((element) => element.file == file) != true);

    final selectedFiles = currentFiles ?? [];
    selectedFiles.addAll(newFiles.map((file) => (name: file.name, file: file)));

    if (context.mounted) {
      context.read<TracksUploaderCubit>().selectFiles(selectedFiles);
    }
  }

  void _onUploadOtherTrack(BuildContext context) {
    context.go(RouteName.upload);
    context.read<TracksUploaderCubit>().start();
  }
}
