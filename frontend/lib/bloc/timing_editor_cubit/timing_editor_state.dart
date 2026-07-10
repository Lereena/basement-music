part of 'timing_editor_cubit.dart';

@freezed
abstract class TimingEditorState with _$TimingEditorState {
  const TimingEditorState._();

  const factory TimingEditorState.loading() = _Loading;
  const factory TimingEditorState.error() = _Error;
  const factory TimingEditorState.editing({
    required List<LrcLine> lines,
    required List<String> metaTags,
    // Line the next stamp lands on (and the nudge strip target).
    required int focusIndex,
    @Default(false) bool isPlaying,
    @Default(1.0) double playbackRate,
    @Default(false) bool canUndo,
    @Default(false) bool dirty,
    @Default(false) bool saving,
    // Playback moved on to another track: stamping is meaningless until the
    // edited track is resumed.
    @Default(false) bool trackChanged,
  }) = _Editing;

  int get timedCount =>
      maybeMap(editing: (s) => s.lines.where((line) => line.time != null).length, orElse: () => 0);

  bool get allTimed =>
      maybeMap(editing: (s) => s.lines.isNotEmpty && s.lines.every((line) => line.time != null), orElse: () => false);

  bool get canSave => maybeMap(editing: (s) => s.dirty && !s.saving, orElse: () => false) && allTimed;

  bool get hasOutOfOrderLines =>
      maybeMap(editing: (s) => List.generate(s.lines.length, (i) => i).any(isLineOutOfOrder), orElse: () => false);

  /// A timed line is out of order when some earlier timed line has a later
  /// timestamp — flags both mis-stamped lines and ones overtaken by nudging.
  bool isLineOutOfOrder(int index) {
    return maybeMap(
      orElse: () => false,
      editing: (s) {
        final time = s.lines[index].time;
        if (time == null) return false;

        for (var i = 0; i < index; i++) {
          final earlier = s.lines[i].time;
          if (earlier != null && earlier > time) return true;
        }
        return false;
      },
    );
  }
}
