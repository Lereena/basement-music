import 'package:basement_music/models/artist.dart';
import 'package:flutter/material.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;
  final void Function() onTap;

  const ArtistCard({super.key, required this.artist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final trackCount = artist.tracks?.length ?? 0;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            const SizedBox(width: 12),
            SizedBox(
              width: 56,
              height: 56,
              child: artist.image != null
                  ? Image.network(artist.image!, fit: BoxFit.cover, errorBuilder: (_, _, _) => const _Placeholder())
                  : const _Placeholder(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(artist.name, style: theme.textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text(
                    '$trackCount ${trackCount == 1 ? 'track' : 'tracks'}',
                    style: theme.textTheme.bodySmall?.copyWith(
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
      child: const Icon(Icons.person, size: 48),
    );
  }
}
