part of 'track_uploading_bloc.dart';

abstract class TrackUploadingState extends Equatable {
  const TrackUploadingState();

  @override
  List<Object> get props => [];
}

class LoadingState extends TrackUploadingState {}

class LinkInputState extends TrackUploadingState {}

class LinkInputErrorState extends TrackUploadingState {}

class InfoState extends TrackUploadingState {
  final String url;
  final String artist;
  final String title;

  InfoState(this.url, this.artist, this.title);
}

class InfoInputErrorState extends TrackUploadingState {}

class UploadingStartedState extends TrackUploadingState {}

class SuccessfulUploadState extends TrackUploadingState {}

class ErrorState extends TrackUploadingState {}
