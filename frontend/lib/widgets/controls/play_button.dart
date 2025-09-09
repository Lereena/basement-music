import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/player_bloc/player_bloc.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';

class PlayButton extends StatelessWidget {
  final Track track;
  final PlayerState state;
  final bool isBottomPlayer;
  final Playlist? openedPlaylist;

  const PlayButton({
    super.key,
    required this.track,
    required this.state,
    this.isBottomPlayer = false,
    this.openedPlaylist,
  });

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.read<PlayerBloc>();

    return InkWell(
      onTap: () {
        if (isBottomPlayer && state is PlayerInitial) return;
        playerBloc.add(
          PlayerPlayStarted(track: track, playlist: openedPlaylist),
        );
      },
      child: const Icon(Icons.play_arrow_rounded, size: 30),
    );
  }
}
