part of 'local_track_uploading_bloc.dart';

@immutable
sealed class LocalTrackUploadingState {}

final class LoadingState extends LocalTrackUploadingState {}

final class NoFileSelectedState extends LocalTrackUploadingState {}

final class FilesSelectedState extends LocalTrackUploadingState {
  final List<({String name, PlatformFile file})> files;

  FilesSelectedState({required this.files});
}

class UploadingStartedState extends LocalTrackUploadingState {}

class SuccessfulUploadState extends LocalTrackUploadingState {}

class ErrorState extends LocalTrackUploadingState {}
