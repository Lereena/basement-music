part of 'youtube_extractor_bloc.dart';

abstract class YoutubeExtractorEvent extends Equatable {
  const YoutubeExtractorEvent();

  @override
  List<Object> get props => [];
}

class YoutubeExtractorStarted extends YoutubeExtractorEvent {
  final String? url;

  const YoutubeExtractorStarted({this.url});
}

class YoutubeExtractorLinkEntered extends YoutubeExtractorEvent {
  final String link;

  const YoutubeExtractorLinkEntered(this.link);
}

class YoutubeExtractorInfoChecked extends YoutubeExtractorEvent {
  final String url;
  final String artist;
  final String title;

  const YoutubeExtractorInfoChecked(this.url, this.artist, this.title);
}
