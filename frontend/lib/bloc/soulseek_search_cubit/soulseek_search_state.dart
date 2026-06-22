part of 'soulseek_search_cubit.dart';

@freezed
abstract class SoulseekSearchState with _$SoulseekSearchState {
  const factory SoulseekSearchState.initial() = _Initial;
  const factory SoulseekSearchState.loading() = _Loading;
  const factory SoulseekSearchState.loaded({
    required List<SoulseekSearchResult> results,
    required List<SoulseekTempTrack> preloaded,
    @Default(false) bool preloadInProgress,
    String? preloadError,
  }) = _Loaded;
  const factory SoulseekSearchState.error() = _Error;
}
