part of 'youtube_extractor_cubit.dart';

@freezed
abstract class YoutubeExtractorState with _$YoutubeExtractorState {
  const factory YoutubeExtractorState.linkInputInProgress({String? url}) = _LinkInputInProgress;
  const factory YoutubeExtractorState.linkInputError() = _LinkInputError;
  const factory YoutubeExtractorState.loadInProgress() = _LoadInProgress;
  const factory YoutubeExtractorState.infoObserve({
    required String url,
    required String artist,
    required String title,
  }) = _InfoObserve;
  const factory YoutubeExtractorState.extractInProgress() = _ExtractInProgress;
  const factory YoutubeExtractorState.extractSuccess() = _ExtractSuccess;
  const factory YoutubeExtractorState.extractError() = _ExtractError;
}
