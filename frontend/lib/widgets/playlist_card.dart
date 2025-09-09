import 'package:flutter/material.dart';

import '../models/playlist.dart';

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
    final tracksCount = playlist.tracks.length;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                playlist.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                "$tracksCount ${_tracksForm(tracksCount)}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _tracksForm(int count) {
    return count == 1 ? 'track' : 'tracks';
  }
}
