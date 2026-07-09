import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/lyrics_repository.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum _LyricsMenuAction { showFile, showServer, hide, editTimingFile, editTimingServer }

class LyricsMenuButton extends StatelessWidget {
  final Track track;
  final bool lyricsShown;
  // Source of the currently shown lyrics; only meaningful when lyricsShown.
  final LyricsSource activeSource;
  final double size;
  final void Function(LyricsSource source) onShowLyrics;
  final VoidCallback onHideLyrics;
  final void Function(LyricsSource source) onEditTiming;

  const LyricsMenuButton({
    super.key,
    required this.track,
    required this.lyricsShown,
    required this.activeSource,
    required this.onShowLyrics,
    required this.onHideLyrics,
    required this.onEditTiming,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_LyricsMenuAction>(
      padding: EdgeInsets.zero,
      onSelected: (action) => switch (action) {
        _LyricsMenuAction.showFile => onShowLyrics(LyricsSource.file),
        _LyricsMenuAction.showServer => onShowLyrics(LyricsSource.server),
        _LyricsMenuAction.hide => onHideLyrics(),
        _LyricsMenuAction.editTimingFile => onEditTiming(LyricsSource.file),
        _LyricsMenuAction.editTimingServer => onEditTiming(LyricsSource.server),
      },
      itemBuilder: (context) => _buildItems(context),
      child: Material(
        // Translucent backdrop so the icon stays readable over cover art.
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
        shape: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(Icons.more_vert, size: size),
        ),
      ),
    );
  }

  List<PopupMenuEntry<_LyricsMenuAction>> _buildItems(BuildContext context) {
    if (lyricsShown) {
      return [
        const PopupMenuItem(value: _LyricsMenuAction.hide, child: Text('Hide lyrics')),
        PopupMenuItem(value: _editTimingAction(activeSource), child: const Text('Edit timing')),
      ];
    }

    // Resolve fresh: PlayerState won't re-emit on a hasLyrics-only change
    // (Track equality is id-only), but the repository copy is current.
    final effectiveTrack =
        context.read<TracksRepository>().items.firstWhereOrNull((t) => t.id == track.id) ?? track;

    if (effectiveTrack.hasLyrics) {
      return const [
        PopupMenuItem(value: _LyricsMenuAction.showFile, child: Text('Show lyrics')),
        PopupMenuItem(value: _LyricsMenuAction.editTimingFile, child: Text('Edit timing')),
      ];
    }

    // Read-only: the play-start warmup probe (PlayerCubit) is what populates
    // this cache — opening the menu never triggers a fetch itself.
    final hasFileLyrics =
        context.read<LyricsRepository>().cachedHasLyrics(effectiveTrack.id, LyricsSource.file) ?? false;

    return [
      if (hasFileLyrics)
        const PopupMenuItem(value: _LyricsMenuAction.showFile, child: Text('Show in-file lyrics')),
      const PopupMenuItem(value: _LyricsMenuAction.showServer, child: Text('Fetch server lyrics')),
      PopupMenuItem(
        value: _editTimingAction(hasFileLyrics ? LyricsSource.file : LyricsSource.server),
        child: const Text('Edit timing'),
      ),
    ];
  }

  _LyricsMenuAction _editTimingAction(LyricsSource source) =>
      source == LyricsSource.file ? _LyricsMenuAction.editTimingFile : _LyricsMenuAction.editTimingServer;
}
