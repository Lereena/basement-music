import 'package:basement_music/widgets/wrappers/content_narrower.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../library.dart';
import '../models/playlist.dart';
import '../widgets/buttons/underlined_button.dart';
import '../widgets/track_card.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist playlist;

  const PlaylistPage({super.key, required this.playlist});

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
    return Padding(
      padding: kIsWeb ? const EdgeInsets.only(top: 60) : EdgeInsets.zero,
      child: Column(
        children: [
          UnderlinedButton(
            text: widget.playlist.title,
            onPressed: () {},
            underlined: false,
          ),
          if (kIsWeb) const SizedBox(height: 40) else const SizedBox(height: 10),
          if (widget.playlist.tracks.isEmpty)
            Center(
              child: Text(
                'No tracks',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          else
            ContentNarrower(
              child: ListView.separated(
                separatorBuilder: (context, _) => const Divider(height: 1),
                itemCount: widget.playlist.tracks.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => TrackCard(
                  track: widget.playlist.tracks[index],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
