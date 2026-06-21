import 'package:basement_music/models/artist.dart';
import 'package:flutter/material.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;
  final void Function() onTap;
  final void Function()? onImageEdit;

  const ArtistCard({super.key, required this.artist, required this.onTap, this.onImageEdit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final trackCount = artist.tracks?.length ?? 0;

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
                      artist.image != null
                          ? Image.network(
                              artist.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const _Placeholder(),
                            )
                          : const _Placeholder(),
                      if (onImageEdit != null)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: onImageEdit,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              color: Colors.black54,
                              child: const Icon(Icons.edit, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
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
                    artist.name,
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
      child: const Icon(Icons.person, size: 48),
    );
  }
}
