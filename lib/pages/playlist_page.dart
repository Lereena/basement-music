import 'package:basement_music/widgets/buttons/cache_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/playlist.dart';
import '../widgets/track_card.dart';
import '../widgets/wrappers/track_context_menu.dart';

class PlaylistPage extends StatelessWidget {
  final Playlist playlist;

  PlaylistPage({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.title),
        actions: kIsWeb || playlist.tracks.isEmpty ? null : [CacheButton(listToCache: playlist.tracks)],
      ),
      body: playlist.tracks.isEmpty
          ? Center(
              child: Text(
                'No tracks',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : ListView.separated(
              separatorBuilder: (context, _) => Divider(height: 1),
              itemCount: playlist.tracks.length,
              itemBuilder: (context, index) => TrackContextMenu(
                trackCard: TrackCard(track: playlist.tracks[index]),
              ),
            ),
    );
  }
}
