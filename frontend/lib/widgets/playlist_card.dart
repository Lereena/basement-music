import 'package:flutter/material.dart';

import 'package:basement_music/models/playlist.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final void Function() onTap;

  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trackCount = playlist.tracks.length;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      playlist.image != null
                          ? Image.network(
                              playlist.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const _Placeholder(),
                            )
                          : const _Placeholder(),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    playlist.title,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$trackCount ${trackCount == 1 ? 'track' : 'tracks'}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.64),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.queue_music, size: 48),
    );
  }
}
