import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/lyrics_repository.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum _LyricsMenuAction { showFile, showServer, hide }

class LyricsMenuButton extends StatelessWidget {
  final Track track;
  final bool lyricsShown;
  final double size;
  final void Function(LyricsSource source) onShowLyrics;
  final VoidCallback onHideLyrics;

  const LyricsMenuButton({
    super.key,
    required this.track,
    required this.lyricsShown,
    required this.onShowLyrics,
    required this.onHideLyrics,
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
      return const [PopupMenuItem(value: _LyricsMenuAction.hide, child: Text('Hide lyrics'))];
    }

    // Resolve fresh: PlayerState won't re-emit on a hasLyrics-only change
    // (Track equality is id-only), but the repository copy is current.
    final effectiveTrack =
        context.read<TracksRepository>().items.firstWhereOrNull((t) => t.id == track.id) ?? track;

    if (effectiveTrack.hasLyrics) {
      return const [PopupMenuItem(value: _LyricsMenuAction.showFile, child: Text('Show lyrics'))];
    }

    // Read-only: the play-start warmup probe (PlayerCubit) is what populates
    // this cache — opening the menu never triggers a fetch itself.
    final hasFileLyrics =
        context.read<LyricsRepository>().cachedHasLyrics(effectiveTrack.id, LyricsSource.file) ?? false;

    return [
      if (hasFileLyrics)
        const PopupMenuItem(value: _LyricsMenuAction.showFile, child: Text('Show in-file lyrics')),
      const PopupMenuItem(value: _LyricsMenuAction.showServer, child: Text('Fetch server lyrics')),
    ];
  }
}
