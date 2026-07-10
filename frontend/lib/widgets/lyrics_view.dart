import 'dart:async';

import 'package:basement_music/audio_player_handler.dart';
import 'package:basement_music/bloc/lyrics_cubit/lyrics_cubit.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/lyrics_repository.dart';
import 'package:basement_music/routing/routes.dart';
import 'package:basement_music/widgets/dialogs/confirm_action_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lyric/flutter_lyric.dart';
import 'package:go_router/go_router.dart';

/// Lyrics shown in place of the track cover, sized to the same box so
/// toggling causes no layout shift.
class LyricsView extends StatefulWidget {
  final Track track;
  final double size;
  final LyricsSource source;

  const LyricsView({super.key, required this.track, required this.size, required this.source});

  @override
  State<LyricsView> createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView> {
  @override
  void initState() {
    super.initState();
    context.read<LyricsCubit>().load(widget.track, widget.source);
  }

  @override
  void didUpdateWidget(LyricsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.track.id != widget.track.id || oldWidget.source != widget.source) {
      context.read<LyricsCubit>().load(widget.track, widget.source);
    }
  }

  Future<void> _onEditTiming() async {
    final saved = await context.push<bool>(RouteName.lyricsTiming(widget.track.id, widget.source.name));
    if (saved != true || !mounted) return;

    // The editor wrote into the track file; the cubit's memoized lyrics for
    // this view are now stale — refetch.
    await context.read<LyricsCubit>().retry(widget.track);
  }

  Future<void> _onSave() async {
    final confirmed = await ConfirmActionDialog.show(context: context, title: 'Save these lyrics into the track file?');
    if (!confirmed || !mounted) return;

    final ok = await context.read<LyricsCubit>().save(widget.track);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save lyrics')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: BlocBuilder<LyricsCubit, LyricsState>(
        builder: (context, state) => state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          notFound: () => const Center(child: Text('No lyrics found')),
          error: () => Center(
            child: TextButton(
              onPressed: () => context.read<LyricsCubit>().retry(widget.track),
              child: const Text('Failed to load lyrics — retry'),
            ),
          ),
          loaded: (lyrics, source, canSave, saving) => Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (lyrics.hasSynced) {
                      return _SyncedLyrics(
                        lrc: lyrics.syncedLyrics!,
                        width: widget.size,
                        height: constraints.maxHeight,
                      );
                    }
                    if (lyrics.hasPlain) {
                      return SingleChildScrollView(child: Text(lyrics.plainLyrics!, textAlign: TextAlign.center));
                    }
                    return const Center(child: Text('Instrumental'));
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (canSave)
                    TextButton.icon(
                      icon: saving
                          ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.save_outlined),
                      label: const Text('Save to track'),
                      onPressed: saving ? null : _onSave,
                    ),
                  if (!lyrics.instrumental)
                    TextButton.icon(
                      icon: const Icon(Icons.timer_outlined),
                      label: const Text('Edit timing'),
                      onPressed: saving ? null : _onEditTiming,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncedLyrics extends StatefulWidget {
  final String lrc;
  final double width;
  final double height;

  const _SyncedLyrics({required this.lrc, required this.width, required this.height});

  @override
  State<_SyncedLyrics> createState() => _SyncedLyricsState();
}

class _SyncedLyricsState extends State<_SyncedLyrics> {
  final _controller = LyricController();
  StreamSubscription<Duration>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _controller.loadLyric(widget.lrc);

    final audioHandler = context.read<AudioPlayerHandler>();
    _controller.setOnTapLineCallback(audioHandler.seek);
    _positionSubscription = audioHandler.onPositionChanged.listen(_controller.setProgress);
  }

  @override
  void didUpdateWidget(_SyncedLyrics oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lrc != widget.lrc) {
      _controller.loadLyric(widget.lrc);
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LyricView(
      controller: _controller,
      width: widget.width,
      height: widget.height,
      style: LyricStyle(
        textStyle: TextStyle(fontSize: 14, color: colorScheme.onSurface.withValues(alpha: 0.6)),
        activeStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.primary),
        translationStyle: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.6)),
        lineTextAlign: TextAlign.center,
        contentAlignment: CrossAxisAlignment.center,
        lineGap: 18,
        translationLineGap: 8,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        selectionAnchorPosition: 0.5,
        selectionAlignment: MainAxisAlignment.center,
        selectedColor: colorScheme.onSurface,
        selectedTranslationColor: colorScheme.onSurface,
        fadeRange: FadeRange(top: 20, bottom: 20),
        scrollDuration: const Duration(milliseconds: 240),
        selectionAutoResumeDuration: const Duration(milliseconds: 320),
        activeAutoResumeDuration: const Duration(milliseconds: 3000),
      ),
    );
  }
}
