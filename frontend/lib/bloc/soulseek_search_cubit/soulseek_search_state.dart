part of 'soulseek_search_cubit.dart';

@freezed
abstract class SoulseekSearchState with _$SoulseekSearchState {
  const factory SoulseekSearchState.initial() = _Initial;
  const factory SoulseekSearchState.loading() = _Loading;
  const factory SoulseekSearchState.connecting() = _Connecting;
  const factory SoulseekSearchState.connectionFailed({required String reason}) = _ConnectionFailed;
  const factory SoulseekSearchState.loaded({
    required List<SoulseekSearchResult> results,
    // Keyed by resultKey(result): per-card preload lifecycle.
    @Default({}) Map<String, SoulseekPreload> preloads,
    // True while peers are still responding (incremental polling in progress).
    @Default(false) bool searching,
  }) = _Loaded;
  const factory SoulseekSearchState.error() = _Error;
}

/// Per-result preload lifecycle shown in-place on each search result card.
@freezed
abstract class SoulseekPreload with _$SoulseekPreload {
  const factory SoulseekPreload.loading() = _PreloadLoading;
  const factory SoulseekPreload.ready(SoulseekTempTrack temp) = _PreloadReady;
  const factory SoulseekPreload.saved() = _PreloadSaved;
  const factory SoulseekPreload.error({required String message}) = _PreloadError;
}

String resultKey(SoulseekSearchResult result) => '${result.peerUsername}|${result.filename}';
