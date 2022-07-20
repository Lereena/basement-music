import 'package:flutter/material.dart';

import '../models/playlist.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;

  const PlaylistCard({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tracksCount = playlist.tracksIds.length;

    return Column(
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
    );
  }

  String _tracksForm(int count) {
    return count == 1 ? 'track' : 'tracks';
  }
}
