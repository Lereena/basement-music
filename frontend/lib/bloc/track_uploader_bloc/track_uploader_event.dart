part of 'track_uploader_bloc.dart';

@immutable
sealed class TracksUploaderEvent {}

class TracksUploaderStarted extends TracksUploaderEvent {}

class TracksUploaderFilesSelected extends TracksUploaderEvent {
  final List<({String name, PlatformFile file})> files;

  TracksUploaderFilesSelected({required this.files});
}

class TracksUploaderFilesApproved extends TracksUploaderEvent {
  final List<({String name, PlatformFile file})> files;

  TracksUploaderFilesApproved({required this.files});
}
