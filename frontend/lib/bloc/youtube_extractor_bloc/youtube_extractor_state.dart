part of 'youtube_extractor_bloc.dart';

@immutable
sealed class YoutubeExtractorState extends Equatable {
  const YoutubeExtractorState();

  @override
  List<Object> get props => [];
}

final class YoutubeExtractorLoadInProgress extends YoutubeExtractorState {}

final class YoutubeExtractorLinkInputInProgress extends YoutubeExtractorState {
  final String? url;

  const YoutubeExtractorLinkInputInProgress({this.url});
}

final class YoutubeExtractorLinkInputError extends YoutubeExtractorState {}

final class YoutubeExtractorInfoObserve extends YoutubeExtractorState {
  final String url;
  final String artist;
  final String title;

  const YoutubeExtractorInfoObserve(this.url, this.artist, this.title);
}

final class YoutubeExtractorExtractInProgress extends YoutubeExtractorState {}

final class YoutubeExtractorExtractSuccess extends YoutubeExtractorState {}

final class YoutubeExtractorExtractError extends YoutubeExtractorState {}
