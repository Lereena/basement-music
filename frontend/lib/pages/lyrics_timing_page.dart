import 'dart:async';

import 'package:basement_music/audio_player_handler.dart';
import 'package:basement_music/bloc/timing_editor_cubit/timing_editor_cubit.dart';
import 'package:basement_music/bloc/track_progress_cubit/track_progress_cubit.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:basement_music/utils/lrc.dart';
import 'package:basement_music/widgets/dialogs/confirm_action_dialog.dart';
import 'package:basement_music/widgets/track_seek_bar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const _nudgeSmall = Duration(milliseconds: 100);
const _nudgeLarge = Duration(milliseconds: 500);

/// Tap-along editor for LRC line timestamps. Expects a [TimingEditorCubit]
/// provided above it (see the route builder). Pops `true` after a save.
class LyricsTimingPage extends StatefulWidget {
  const LyricsTimingPage({super.key});

  @override
  State<LyricsTimingPage> createState() => _LyricsTimingPageState();
}

class _LyricsTimingPageState extends State<LyricsTimingPage> {
  var _rowKeys = <GlobalKey>[];
  StreamSubscription<Duration>? _positionSubscription;

  // Line the playback position is currently inside — a listening aid, kept
  // out of cubit state so per-frame position events don't rebuild the page.
  int? _activeLineIndex;

  @override
  void initState() {
    super.initState();
    _positionSubscription = context.read<AudioPlayerHandler>().onPositionChanged.listen(_updateActiveLine);
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  void _updateActiveLine(Duration position) {
    final lines = context.read<TimingEditorCubit>().state.maybeMap(editing: (s) => s.lines, orElse: () => null);
    if (lines == null) return;

    int? active;
    for (var i = 0; i < lines.length; i++) {
      final time = lines[i].time;
      if (time != null && time <= position) active = i;
    }
    if (active != _activeLineIndex) setState(() => _activeLineIndex = active);
  }

  void _scrollToLine(int index) {
    if (index < 0 || index >= _rowKeys.length) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rowContext = _rowKeys[index].currentContext;
      if (rowContext == null || !mounted) return;
      Scrollable.ensureVisible(
        rowContext,
        alignment: 0.4,
        duration: const Duration(milliseconds: 240),
      );
    });
  }

  Future<void> _onClose() async {
    final dirty = context.read<TimingEditorCubit>().state.maybeMap(editing: (s) => s.dirty, orElse: () => false);
    if (dirty) {
      final confirmed = await ConfirmActionDialog.show(context: context, title: 'Discard timing changes?');
      if (!confirmed || !mounted) return;
    }
    if (mounted) context.pop(false);
  }

  Future<void> _onSave() async {
    final cubit = context.read<TimingEditorCubit>();

    // Resolve fresh: Track equality is id-only, the repository copy is current.
    final track = context.read<TracksRepository>().items.firstWhereOrNull((t) => t.id == cubit.track.id) ?? cubit.track;
    final title = track.hasLyrics ? 'Overwrite the lyrics in the track file?' : 'Save these lyrics into the track file?';
    final warning = cubit.state.hasOutOfOrderLines ? ' Some lines are out of order.' : '';

    final confirmed = await ConfirmActionDialog.show(context: context, title: '$title$warning');
    if (!confirmed || !mounted) return;

    final ok = await cubit.save();
    if (!mounted) return;

    if (ok) {
      context.pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save lyrics')));
    }
  }

  Future<void> _onEditLineText(int index, LrcLine line) async {
    final cubit = context.read<TimingEditorCubit>();
    final text = await _EditLineDialog.show(context: context, title: 'Edit line', initialText: line.text);
    if (text != null) cubit.editLineText(index, text);
  }

  Future<void> _onInsertLine(int index) async {
    final cubit = context.read<TimingEditorCubit>();
    final text = await _EditLineDialog.show(context: context, title: 'Add line', initialText: '');
    if (text != null) cubit.insertLine(index, text);
  }

  Map<ShortcutActivator, VoidCallback> _shortcuts(TimingEditorCubit cubit, int focusIndex, int lineCount) {
    void moveFocus(int delta) {
      cubit.selectLine((focusIndex + delta).clamp(0, lineCount - 1));
    }

    return {
      const SingleActivator(LogicalKeyboardKey.space): cubit.stamp,
      const SingleActivator(LogicalKeyboardKey.backspace): cubit.undo,
      const SingleActivator(LogicalKeyboardKey.arrowLeft): () => cubit.nudge(focusIndex, -_nudgeSmall),
      const SingleActivator(LogicalKeyboardKey.arrowRight): () => cubit.nudge(focusIndex, _nudgeSmall),
      const SingleActivator(LogicalKeyboardKey.arrowUp): () => moveFocus(-1),
      const SingleActivator(LogicalKeyboardKey.arrowDown): () => moveFocus(1),
      const SingleActivator(LogicalKeyboardKey.keyP): cubit.togglePlay,
    };
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TimingEditorCubit>();

    return BlocConsumer<TimingEditorCubit, TimingEditorState>(
      listenWhen: (previous, current) => current.maybeMap(editing: (_) => true, orElse: () => false),
      listener: (context, state) {
        state.maybeMap(
          orElse: () {},
          editing: (editing) {
            if (_rowKeys.length != editing.lines.length) {
              _rowKeys = List.generate(editing.lines.length, (_) => GlobalKey());
            }
            _scrollToLine(editing.focusIndex);
          },
        );
      },
      builder: (context, state) {
        final body = state.map(
          loading: (_) => const Center(child: CircularProgressIndicator()),
          error: (_) => const Center(child: Text('No lyrics to edit')),
          editing: (editing) => _buildEditor(
            context,
            cubit,
            lines: editing.lines,
            focusIndex: editing.focusIndex,
            trackChanged: editing.trackChanged,
          ),
        );

        final page = PopScope(
          canPop: !state.maybeMap(editing: (s) => s.dirty, orElse: () => false),
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _onClose();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: CloseButton(onPressed: _onClose),
              title: Text('Edit timing — ${cubit.track.title}', overflow: TextOverflow.ellipsis),
              actions: [
                if (state.maybeMap(editing: (_) => true, orElse: () => false))
                  Center(
                    child: Text(
                      '${state.timedCount}/${state.maybeMap(editing: (s) => s.lines.length, orElse: () => 0)} timed',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: state.maybeMap(editing: (s) => s.saving, orElse: () => false)
                      ? const Center(
                          child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                      : TextButton(onPressed: state.canSave ? _onSave : null, child: const Text('Save')),
                ),
              ],
            ),
            body: body,
          ),
        );

        return state.maybeMap(
          orElse: () => page,
          editing: (editing) => CallbackShortcuts(
            bindings: _shortcuts(cubit, editing.focusIndex, editing.lines.length),
            child: Focus(autofocus: true, child: page),
          ),
        );
      },
    );
  }

  Widget _buildEditor(
    BuildContext context,
    TimingEditorCubit cubit, {
    required List<LrcLine> lines,
    required int focusIndex,
    required bool trackChanged,
  }) {
    return Column(
      children: [
        if (trackChanged) _TrackChangedBanner(onResume: cubit.resumeEditedTrack),
        Expanded(
          // Non-lazy list so ensureVisible can always find off-screen rows;
          // lyric line rows are cheap enough for that.
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              for (var i = 0; i < lines.length; i++)
                _LineRow(
                  key: _rowKeys.length == lines.length ? _rowKeys[i] : null,
                  line: lines[i],
                  focused: i == focusIndex,
                  isActive: i == _activeLineIndex,
                  outOfOrder: cubit.state.isLineOutOfOrder(i),
                  onTap: () => cubit.selectLine(i),
                  onEdit: () => _onEditLineText(i, lines[i]),
                  onTimeTap: () => cubit.seekToLine(i),
                  onNudge: (delta) => cubit.nudge(i, delta),
                  onInsert: (below) => _onInsertLine(below ? i + 1 : i),
                ),
            ],
          ),
        ),
        _ControlPanel(cubit: cubit),
      ],
    );
  }
}

class _LineRow extends StatelessWidget {
  final LrcLine line;
  final bool focused;
  final bool isActive;
  final bool outOfOrder;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onTimeTap;
  final ValueChanged<Duration> onNudge;
  final void Function(bool below) onInsert;

  const _LineRow({
    super.key,
    required this.line,
    required this.focused,
    required this.isActive,
    required this.outOfOrder,
    required this.onTap,
    required this.onEdit,
    required this.onTimeTap,
    required this.onNudge,
    required this.onInsert,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final time = line.time;

    return Material(
      color: focused ? colorScheme.primary.withValues(alpha: 0.08) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onEdit,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Timestamp chip: tap replays from just before the line.
                  InkWell(
                    onTap: time == null ? null : onTimeTap,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: outOfOrder
                            ? colorScheme.error.withValues(alpha: 0.15)
                            : colorScheme.primary.withValues(alpha: time == null ? 0.04 : 0.1),
                      ),
                      child: Text(
                        time == null ? '--:--.--' : _timeLabel(time),
                        style: TextStyle(
                          fontSize: 13,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          color: outOfOrder
                              ? colorScheme.error
                              : time == null
                                  ? colorScheme.onSurface.withValues(alpha: 0.4)
                                  : colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      line.text,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: focused || isActive ? FontWeight.w600 : FontWeight.w400,
                        color: focused
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: isActive ? 1 : 0.75),
                      ),
                    ),
                  ),
                ],
              ),
              if (focused)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (time != null)
                        for (final (label, delta) in [
                          ('−0.5s', -_nudgeLarge),
                          ('−0.1s', -_nudgeSmall),
                          ('+0.1s', _nudgeSmall),
                          ('+0.5s', _nudgeLarge),
                        ])
                          ActionChip(
                            label: Text(label),
                            visualDensity: VisualDensity.compact,
                            onPressed: () => onNudge(delta),
                          ),
                      IconButton(
                        tooltip: 'Edit text',
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: onEdit,
                      ),
                      PopupMenuButton<bool>(
                        tooltip: 'Add line',
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        onSelected: onInsert,
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: false, child: Text('Add line above')),
                          PopupMenuItem(value: true, child: Text('Add line below')),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeLabel(Duration time) {
    String pad(int value) => value.toString().padLeft(2, '0');
    return '${pad(time.inMinutes)}:${pad(time.inSeconds % 60)}.${pad(time.inMilliseconds % 1000 ~/ 10)}';
  }
}

class _TrackChangedBanner extends StatelessWidget {
  final VoidCallback onResume;

  const _TrackChangedBanner({required this.onResume});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.errorContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text('Playback moved to another track', style: TextStyle(color: colorScheme.onErrorContainer)),
          ),
          TextButton(onPressed: onResume, child: const Text('Resume this track')),
        ],
      ),
    );
  }
}

class _ControlPanel extends StatelessWidget {
  final TimingEditorCubit cubit;

  const _ControlPanel({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = cubit.state;
    final (isPlaying, playbackRate, canUndo, trackChanged, saving, focusLineText) = state.maybeMap(
      editing: (s) => (s.isPlaying, s.playbackRate, s.canUndo, s.trackChanged, s.saving, s.lines[s.focusIndex].text),
      orElse: () => (false, 1.0, false, false, false, ''),
    );

    return Material(
      elevation: 8,
      color: colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<TrackProgressCubit, TrackProgressState>(
                builder: (context, progress) {
                  final progressCubit = context.read<TrackProgressCubit>();

                  return Row(
                    children: [
                      Text(progress.stringProgress, style: const TextStyle(fontSize: 13)),
                      Expanded(
                        child: TrackSeekBar(
                          percentProgress: progress.percentProgress,
                          enabled: progressCubit.canSeek,
                          onSeek: progressCubit.seek,
                        ),
                      ),
                      Text(progress.stringDuration, style: const TextStyle(fontSize: 13)),
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    tooltip: 'Restart',
                    icon: const Icon(Icons.replay),
                    onPressed: cubit.restart,
                  ),
                  IconButton(
                    tooltip: isPlaying ? 'Pause' : 'Play',
                    iconSize: 36,
                    icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
                    onPressed: cubit.togglePlay,
                  ),
                  TextButton(
                    onPressed: cubit.cyclePlaybackRate,
                    child: Text('$playbackRate×'),
                  ),
                  IconButton(
                    tooltip: 'Undo last stamp',
                    icon: const Icon(Icons.undo),
                    onPressed: canUndo ? cubit.undo : null,
                  ),
                  IconButton(
                    tooltip: 'Shift all timestamps',
                    icon: const Icon(Icons.swap_vert),
                    onPressed: cubit.state.timedCount == 0 ? null : () => _OffsetDialog.show(context: context, cubit: cubit),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: FilledButton(
                  onPressed: trackChanged || saving ? null : cubit.stamp,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('STAMP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
                      Text(
                        focusLineText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditLineDialog extends StatefulWidget {
  final String title;
  final String initialText;

  const _EditLineDialog({required this.title, required this.initialText});

  static Future<String?> show({required BuildContext context, required String title, required String initialText}) =>
      showDialog<String>(
        context: context,
        builder: (_) => _EditLineDialog(title: title, initialText: initialText),
      );

  @override
  State<_EditLineDialog> createState() => _EditLineDialogState();
}

class _EditLineDialogState extends State<_EditLineDialog> {
  late final _controller = TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        onSubmitted: (value) => context.pop(value),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(onPressed: () => context.pop(_controller.text), child: const Text('Save')),
        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
      ],
    );
  }
}

class _OffsetDialog extends StatelessWidget {
  final TimingEditorCubit cubit;

  const _OffsetDialog({required this.cubit});

  static Future<void> show({required BuildContext context, required TimingEditorCubit cubit}) => showDialog<void>(
        context: context,
        builder: (_) => _OffsetDialog(cubit: cubit),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Shift all timestamps'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Earlier if lines appear late, later if they appear early. Applies immediately.'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              for (final (label, delta) in [
                ('−0.5s', -_nudgeLarge),
                ('−0.1s', -_nudgeSmall),
                ('+0.1s', _nudgeSmall),
                ('+0.5s', _nudgeLarge),
              ])
                ActionChip(label: Text(label), onPressed: () => cubit.shiftAll(delta)),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Done')),
      ],
    );
  }
}
