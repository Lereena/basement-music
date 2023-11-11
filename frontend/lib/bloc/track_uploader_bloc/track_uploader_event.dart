part of 'track_uploader_bloc.dart';

@immutable
sealed class TracksUploaderEvent {}

final class TracksUploaderStarted extends TracksUploaderEvent {}

final class TracksUploaderFilesSelected extends TracksUploaderEvent {
  final List<({String name, PlatformFile file})> files;

  TracksUploaderFilesSelected({required this.files});
}

final class TracksUploaderFilesApproved extends TracksUploaderEvent {
  final List<({String name, PlatformFile file})> files;

  TracksUploaderFilesApproved({required this.files});
}
