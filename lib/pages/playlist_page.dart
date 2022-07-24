import 'package:basement_music/library.dart';
import 'package:basement_music/widgets/buttons/cache_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/playlist.dart';
import '../widgets/track_card.dart';
import '../widgets/wrappers/track_context_menu.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistId;

  PlaylistPage({Key? key, required this.playlistId}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late Playlist playlist;

  @override
  void initState() {
    super.initState();
    playlist = playlists.firstWhere((element) => element.id == widget.playlistId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.title),
        actions: kIsWeb || playlist.tracks.isEmpty ? null : [CacheButton(listToCache: playlist.tracks)],
      ),
      body: ListView.separated(
        separatorBuilder: (context, _) => Divider(height: 1),
        itemCount: playlist.tracks.length,
        itemBuilder: (context, index) => TrackContextMenu(
          trackCard: TrackCard(track: playlist.tracks[index]),
        ),
      ),
    );
  }
}
