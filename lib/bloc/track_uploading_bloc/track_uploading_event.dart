part of 'track_uploading_bloc.dart';

abstract class TrackUploadingEvent extends Equatable {
  const TrackUploadingEvent();

  @override
  List<Object> get props => [];
}

class Start extends TrackUploadingEvent {}

class LinkEntered extends TrackUploadingEvent {
  final String link;

  LinkEntered(this.link);
}

class InfoChecked extends TrackUploadingEvent {
  final String url;
  final String artist;
  final String title;

  InfoChecked(this.url, this.artist, this.title);
}
