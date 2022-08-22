import 'package:basement_music/widgets/bottom_bar.dart';
import 'package:basement_music/widgets/playlist_cache_action.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../library.dart';
import '../models/playlist.dart';
import '../widgets/track_card.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist playlist;

  const PlaylistPage({Key? key, required this.playlist}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  void initState() {
    super.initState();
    openedPlaylist = widget.playlist;
  }

  @override
  void dispose() {
    super.dispose();
    openedPlaylist = Playlist.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlist.title),
        actions: kIsWeb || widget.playlist.tracks.isEmpty
            ? null
            : [
                PlaylistCacheAction(
                  trackIds: widget.playlist.tracks.map((track) => track.id).toList(),
                ),
              ],
      ),
      body: widget.playlist.tracks.isEmpty
          ? Center(
              child: Text(
                'No tracks',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : ListView.separated(
              separatorBuilder: (context, _) => const Divider(height: 1),
              itemCount: widget.playlist.tracks.length,
              itemBuilder: (context, index) => TrackCard(
                track: widget.playlist.tracks[index],
              ),
            ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
