import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/playlists_bloc/playlists_bloc.dart';
import '../models/playlist.dart';
import '../widgets/buttons/underlined_button.dart';
import '../widgets/track_card.dart';
import '../widgets/wrappers/content_narrower.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist playlist;

  const PlaylistPage({super.key, required this.playlist});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late final PlaylistsBloc _playlistsBloc;

  @override
  void initState() {
    super.initState();
    _playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    _playlistsBloc.openedPlaylist = widget.playlist;
  }

  @override
  void dispose() {
    super.dispose();
    _playlistsBloc.openedPlaylist = Playlist.empty();
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
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, _) => const Divider(height: 1),
                itemCount: widget.playlist.tracks.length,
                itemBuilder: (context, index) => TrackCard(
                  track: widget.playlist.tracks[index],
                  containingPlaylist: widget.playlist,
                  openedPlaylist: widget.playlist,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
