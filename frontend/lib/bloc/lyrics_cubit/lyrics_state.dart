part of 'lyrics_cubit.dart';

@freezed
abstract class LyricsState with _$LyricsState {
  const factory LyricsState.initial() = _Initial;
  const factory LyricsState.loading() = _Loading;
  const factory LyricsState.loaded({
    required Lyrics lyrics,
    required LyricsSource source,
    required bool canSave,
    @Default(false) bool saving,
  }) = _Loaded;
  const factory LyricsState.notFound() = _NotFound;
  const factory LyricsState.error() = _Error;
}
