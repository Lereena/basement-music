part of 'track_uploader_cubit.dart';

@freezed
abstract class TracksUploaderState with _$TracksUploaderState {
  const factory TracksUploaderState.filesSelectStart() = _FilesSelectStart;
  const factory TracksUploaderState.filesSelectSuccess({required List<({String name, PlatformFile file})> files}) =
      _FilesSelectSuccess;
  const factory TracksUploaderState.uploadInProgress() = _UploadInProgress;
  const factory TracksUploaderState.uploadSuccess() = _UploadSuccess;
  const factory TracksUploaderState.uploadError() = _UploadError;
}
