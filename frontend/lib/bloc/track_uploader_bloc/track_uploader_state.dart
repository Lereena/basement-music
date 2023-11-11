part of 'track_uploader_bloc.dart';

@immutable
sealed class TracksUploaderState {}

final class TracksUploaderFilesSelectStart extends TracksUploaderState {}

final class TracksUploaderFilesSelectSuccess extends TracksUploaderState {
  final List<({String name, PlatformFile file})> files;

  TracksUploaderFilesSelectSuccess({required this.files});
}

class TracksUploaderUploadInProgress extends TracksUploaderState {}

class TracksUploaderUploadSucces extends TracksUploaderState {}

class TracksUploaderUploadError extends TracksUploaderState {}
