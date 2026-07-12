import 'package:basement_music/models/artist.dart';
import 'package:basement_music/widgets/keep_alive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;
  final void Function() onTap;

  const ArtistCard({super.key, required this.artist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trackCount = artist.tracks?.length ?? 0;

    return KeepAliveWrapper(
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              artist.image != null
                  ? CachedNetworkImage(
                      imageUrl: artist.image!,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => _Placeholder(name: artist.name),
                    )
                  : _Placeholder(name: artist.name),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                  ),
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artist.name,
                      style: theme.textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$trackCount ${trackCount == 1 ? 'track' : 'tracks'}',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
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
  final String name;

  const _Placeholder({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      color: theme.colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Text(letter, style: theme.textTheme.displayMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
    );
  }
}
