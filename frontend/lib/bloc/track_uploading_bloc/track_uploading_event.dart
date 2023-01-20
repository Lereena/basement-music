part of 'track_uploading_bloc.dart';

abstract class TrackUploadingEvent extends Equatable {
  const TrackUploadingEvent();

  @override
  List<Object> get props => [];
}

class Start extends TrackUploadingEvent {
  final String? url;

  const Start({this.url});
}

class LinkEntered extends TrackUploadingEvent {
  final String link;

  const LinkEntered(this.link);
}

class InfoChecked extends TrackUploadingEvent {
  final String url;
  final String artist;
  final String title;

  const InfoChecked(this.url, this.artist, this.title);
}
