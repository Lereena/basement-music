import 'dart:async';

import 'package:audioplayers/audioplayers.dart' show PlayerState;
import 'package:basement_music/audio_player_handler.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/lyrics_repository.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:basement_music/utils/lrc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timing_editor_cubit.freezed.dart';
part 'timing_editor_state.dart';

/// Replay lead-in before a line's timestamp so the user hears the cue into it.
const _replayLeadIn = Duration(seconds: 1);

const _playbackRates = [1.0, 0.75, 0.5];

class TimingEditorCubit extends Cubit<TimingEditorState> {
  TimingEditorCubit(
    this._lyricsRepository,
    this._tracksRepository,
    this._audioHandler, {
    required this.track,
    required this.source,
  }) : super(const TimingEditorState.loading());

  final LyricsRepository _lyricsRepository;
  final TracksRepository _tracksRepository;
  final AudioPlayerHandler _audioHandler;
  final Track track;
  final LyricsSource source;

  // Each stamp/undo entry: line index, its previous time, previous focus.
  final _undoStack = <(int, Duration?, int)>[];

  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<dynamic>? _mediaItemSubscription;

  Future<void> init() async {
    // The editor stamps against the currently playing position, so the edited
    // track must be the loaded media item. Don't autoplay: the user starts
    // playback when ready to tap along.
    if (_audioHandler.mediaItem.valueOrNull?.id != track.id) {
      await _audioHandler.pause();
      _audioHandler.addMediaItem(track);
    }

    _playerStateSubscription = _audioHandler.onPlayerStateChanged.listen((playerState) {
      final editing = state;
      if (editing is _Editing) emit(editing.copyWith(isPlaying: playerState == PlayerState.playing));
    });
    _mediaItemSubscription = _audioHandler.mediaItem.listen((item) {
      final editing = state;
      if (editing is _Editing) emit(editing.copyWith(trackChanged: item?.id != track.id));
    });

    try {
      final lyrics = await _lyricsRepository.getLyrics(track, source);
      if (isClosed) return;

      final text = lyrics?.syncedLyrics ?? lyrics?.plainLyrics;
      final document = text == null ? null : LrcDocument.parse(text);
      if (document == null || document.lines.isEmpty) {
        emit(const TimingEditorState.error());
        return;
      }

      emit(
        TimingEditorState.editing(
          lines: document.lines,
          metaTags: document.metaTags,
          // Start at the first untimed line, if any.
          focusIndex: document.lines.indexWhere((line) => line.time == null).clamp(0, document.lines.length - 1),
        ),
      );
    } catch (_) {
      if (!isClosed) emit(const TimingEditorState.error());
    }
  }

  /// Assigns the current playback position to the focused line and advances
  /// focus. The position is queried fresh (not taken from the last stream
  /// event) for per-frame precision.
  Future<void> stamp() async {
    final editing = state;
    if (editing is! _Editing || editing.trackChanged || editing.saving) return;

    final position = await _audioHandler.getCurrentPosition();
    if (position == null || isClosed) return;

    final current = state;
    if (current is! _Editing) return;

    final index = current.focusIndex;
    final rounded = Duration(milliseconds: position.inMilliseconds - position.inMilliseconds % 10);

    _undoStack.add((index, current.lines[index].time, index));
    final lines = [...current.lines]..[index] = current.lines[index].copyWith(time: rounded);

    emit(
      current.copyWith(
        lines: lines,
        focusIndex: (index + 1).clamp(0, lines.length - 1),
        canUndo: true,
        dirty: true,
      ),
    );
  }

  void undo() {
    final editing = state;
    if (editing is! _Editing || _undoStack.isEmpty) return;

    final (index, previousTime, previousFocus) = _undoStack.removeLast();
    final lines = [...editing.lines]
      ..[index] = editing.lines[index].copyWith(time: previousTime, clearTime: previousTime == null);

    emit(editing.copyWith(lines: lines, focusIndex: previousFocus, canUndo: _undoStack.isNotEmpty));
  }

  void selectLine(int index) {
    final editing = state;
    if (editing is _Editing) emit(editing.copyWith(focusIndex: index));
  }

  /// Seeks slightly before the line's time and plays — instant verification.
  Future<void> seekToLine(int index) async {
    final editing = state;
    if (editing is! _Editing || editing.trackChanged) return;

    final time = editing.lines[index].time;
    if (time == null) return;

    final target = time - _replayLeadIn;
    await _audioHandler.seek(target.isNegative ? Duration.zero : target);
    if (!editing.isPlaying) await _audioHandler.play();
  }

  /// Adjusts a line's time by [delta] and replays from just before it so the
  /// user immediately hears whether the timing now matches.
  Future<void> nudge(int index, Duration delta) async {
    final editing = state;
    if (editing is! _Editing) return;

    final time = editing.lines[index].time;
    if (time == null) return;

    final shifted = time + delta;
    final lines = [...editing.lines]
      ..[index] = editing.lines[index].copyWith(time: shifted.isNegative ? Duration.zero : shifted);

    emit(editing.copyWith(lines: lines, dirty: true));
    await seekToLine(index);
  }

  /// Shifts all timed lines by [delta] — the fix for uniformly-late/early
  /// lyrics fetched from the server.
  void shiftAll(Duration delta) {
    final editing = state;
    if (editing is! _Editing) return;

    final lines = editing.lines.map((line) {
      final time = line.time;
      if (time == null) return line;
      final shifted = time + delta;
      return line.copyWith(time: shifted.isNegative ? Duration.zero : shifted);
    }).toList();

    emit(editing.copyWith(lines: lines, dirty: true));
  }

  /// Inserts a new untimed line at [index] and focuses it for stamping.
  void insertLine(int index, String text) {
    final editing = state;
    if (editing is! _Editing) return;

    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final lines = [...editing.lines]..insert(index, LrcLine(text: trimmed));
    // Undo entries hold line indices, which just shifted — drop them rather
    // than restore a stamp onto the wrong line.
    _undoStack.clear();

    emit(editing.copyWith(lines: lines, focusIndex: index, canUndo: false, dirty: true));
  }

  void editLineText(int index, String text) {
    final editing = state;
    if (editing is! _Editing) return;

    final trimmed = text.trim();
    if (trimmed.isEmpty || trimmed == editing.lines[index].text) return;

    final lines = [...editing.lines]..[index] = editing.lines[index].copyWith(text: trimmed);
    emit(editing.copyWith(lines: lines, dirty: true));
  }

  Future<void> cyclePlaybackRate() async {
    final editing = state;
    if (editing is! _Editing) return;

    final index = _playbackRates.indexOf(editing.playbackRate);
    final rate = _playbackRates[(index + 1) % _playbackRates.length];
    await _audioHandler.setPlaybackRate(rate);
    final current = state;
    if (current is _Editing) emit(current.copyWith(playbackRate: rate));
  }

  Future<void> togglePlay() async {
    final editing = state;
    if (editing is! _Editing) return;

    if (editing.trackChanged) return resumeEditedTrack();
    editing.isPlaying ? await _audioHandler.pause() : await _audioHandler.play();
  }

  Future<void> restart() async {
    final editing = state;
    if (editing is! _Editing) return;

    if (editing.trackChanged) return resumeEditedTrack();
    await _audioHandler.seek(Duration.zero);
    if (!editing.isPlaying) await _audioHandler.play();
  }

  /// Re-loads the edited track after playback moved on to another one.
  Future<void> resumeEditedTrack() async {
    await _audioHandler.pause();
    _audioHandler.addMediaItem(track);
    await _audioHandler.play();
  }

  /// Returns false on failure so the caller can surface an error.
  Future<bool> save() async {
    final editing = state;
    if (editing is! _Editing || !state.canSave) return false;

    emit(editing.copyWith(saving: true));
    try {
      final text = LrcDocument(metaTags: editing.metaTags, lines: editing.lines).serialize();
      final updated = await _lyricsRepository.saveLyrics(track, text);
      _tracksRepository.applyTrackUpdate(updated);
      emit(editing.copyWith(saving: false, dirty: false));
      return true;
    } catch (_) {
      if (!isClosed) emit(editing.copyWith(saving: false));
      return false;
    }
  }

  @override
  Future<void> close() async {
    await _playerStateSubscription?.cancel();
    await _mediaItemSubscription?.cancel();
    // Editor-only slow-down must never leak into normal listening.
    await _audioHandler.setPlaybackRate(1.0);
    return super.close();
  }
}
