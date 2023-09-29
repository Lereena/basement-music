part of 'local_track_uploading_bloc.dart';

@immutable
sealed class LocalTrackUploadingEvent {}

class FilesSelected extends LocalTrackUploadingEvent {
  final List<({String name, PlatformFile file})> files;

  FilesSelected({required this.files});
}

class FilesApproved extends LocalTrackUploadingEvent {
  final List<({String name, PlatformFile file})> files;

  FilesApproved({required this.files});
}
