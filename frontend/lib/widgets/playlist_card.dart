import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/theme/theme.dart';
import 'package:basement_music/widgets/keep_alive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final void Function() onTap;

  const PlaylistCard({super.key, required this.playlist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trackCount = playlist.tracks.length;

    return KeepAliveWrapper(
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: ClipRRect(
                    borderRadius: AppRadius.smAll,
                    child: playlist.image != null
                        ? CachedNetworkImage(
                            imageUrl: playlist.image!,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => const _Placeholder(),
                          )
                        : const _Placeholder(),
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
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
