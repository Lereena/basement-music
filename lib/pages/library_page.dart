import 'package:basement_music/interactors/playlist_interactor.dart';
import 'package:basement_music/library.dart';
import 'package:flutter/material.dart';

import '../models/playlist.dart';
import '../widgets/playlist_card.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Playlist>>(
        future: fetchAllPlaylists(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) => PlaylistCard(playlist: playlists[index]),
                separatorBuilder: (context, _) => Divider(height: 1),
                itemCount: playlists.length),
          );
        });
  }
}
