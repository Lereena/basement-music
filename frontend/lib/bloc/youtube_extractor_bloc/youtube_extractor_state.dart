part of 'youtube_extractor_bloc.dart';

abstract class YoutubeExtractorState extends Equatable {
  const YoutubeExtractorState();

  @override
  List<Object> get props => [];
}

class YoutubeExtractorLoadInProgress extends YoutubeExtractorState {}

class YoutubeExtractorLinkInputInProgress extends YoutubeExtractorState {
  final String? url;

  const YoutubeExtractorLinkInputInProgress({this.url});
}

class YoutubeExtractorLinkInputError extends YoutubeExtractorState {}

class YoutubeExtractorInfoObserve extends YoutubeExtractorState {
  final String url;
  final String artist;
  final String title;

  const YoutubeExtractorInfoObserve(this.url, this.artist, this.title);
}

class YoutubeExtractorExtractInProgress extends YoutubeExtractorState {}

class YoutubeExtractorExtractSuccess extends YoutubeExtractorState {}

class YoutubeExtractorExtractError extends YoutubeExtractorState {}
