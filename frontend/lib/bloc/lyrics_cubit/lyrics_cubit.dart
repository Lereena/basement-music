import 'package:basement_music/models/lyrics.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/lyrics_repository.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyrics_cubit.freezed.dart';
part 'lyrics_state.dart';

class LyricsCubit extends Cubit<LyricsState> {
  LyricsCubit(this._lyricsRepository, this._tracksRepository) : super(const LyricsState.initial());

  final LyricsRepository _lyricsRepository;
  final TracksRepository _tracksRepository;
  String? _trackId;
  LyricsSource? _source;

  Future<void> load(Track track, LyricsSource source) async {
    // No-op when this (track, source) is already loading/loaded, so the view
    // can call this on every show without refetching. A source switch or track
    // change reloads.
    final alreadyHandled = state.maybeWhen(initial: () => false, error: () => false, orElse: () => true);
    if (_trackId == track.id && _source == source && alreadyHandled) return;

    _trackId = track.id;
    _source = source;
    emit(const LyricsState.loading());

    try {
      final lyrics = await _lyricsRepository.getLyrics(track, source);
      if (_trackId != track.id || _source != source) return; // stale response

      if (lyrics == null || lyrics.isEmpty) {
        emit(const LyricsState.notFound());
      } else {
        emit(
          LyricsState.loaded(
            lyrics: lyrics,
            source: source,
            // Unconfirmed lyrics (any source) are saveable; saving marks the
            // track lyrics-having and locks the source to the file.
            canSave: !track.hasLyrics && !lyrics.instrumental,
          ),
        );
      }
    } catch (_) {
      if (_trackId == track.id && _source == source) emit(const LyricsState.error());
    }
  }

  Future<void> retry(Track track) {
    final source = _source ?? LyricsSource.server;
    _trackId = null;
    return load(track, source);
  }

  /// Returns false on failure so the caller can surface an error.
  Future<bool> save(Track track) async {
    final current = state;
    if (current is! _Loaded || !current.canSave || current.saving) return false;

    emit(current.copyWith(saving: true));
    try {
      final text = current.lyrics.hasSynced ? current.lyrics.syncedLyrics! : current.lyrics.plainLyrics!;
      final updated = await _lyricsRepository.saveLyrics(track, text);
      _tracksRepository.applyTrackUpdate(updated);
      // Saved lyrics are now the file lyrics: flip source so a subsequent
      // load(track, file) is a no-op (no refetch, no flicker).
      _source = LyricsSource.file;
      emit(current.copyWith(saving: false, canSave: false, source: LyricsSource.file));
      return true;
    } catch (_) {
      emit(current.copyWith(saving: false));
      return false;
    }
  }
}
