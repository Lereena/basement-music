import 'package:basement_music/models/lyrics.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/lyrics_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyrics_cubit.freezed.dart';
part 'lyrics_state.dart';

class LyricsCubit extends Cubit<LyricsState> {
  LyricsCubit(this._repo) : super(const LyricsState.initial());

  final LyricsRepository _repo;
  String? _trackId;

  Future<void> load(Track track) async {
    // No-op when lyrics for this track are already loading/loaded, so the view
    // can call this on every show without refetching.
    final alreadyHandled = state.maybeWhen(initial: () => false, error: () => false, orElse: () => true);
    if (_trackId == track.id && alreadyHandled) return;

    _trackId = track.id;
    emit(const LyricsState.loading());

    try {
      final lyrics = await _repo.getLyrics(track);
      if (_trackId != track.id) return; // stale response after track change

      if (lyrics == null || lyrics.isEmpty) {
        emit(const LyricsState.notFound());
      } else {
        emit(LyricsState.loaded(lyrics: lyrics));
      }
    } catch (_) {
      if (_trackId != track.id) return;
      emit(const LyricsState.error());
    }
  }

  Future<void> retry(Track track) {
    _trackId = null;
    return load(track);
  }
}
