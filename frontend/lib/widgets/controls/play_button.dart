import 'package:basement_music/bloc/player_cubit/player_cubit.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayButton extends StatelessWidget {
  final Track track;
  final PlayerState state;
  final bool isBottomPlayer;
  final Playlist? openedPlaylist;
  final double size;
  final Color? color;

  const PlayButton({
    super.key,
    required this.track,
    required this.state,
    this.isBottomPlayer = false,
    this.openedPlaylist,
    this.size = 30,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<PlayerCubit>();

    return InkWell(
      onTap: () {
        if (isBottomPlayer && state.isInitial) return;
        playerCubit.play(track: track, playlist: openedPlaylist);
      },
      child: Icon(Icons.play_arrow_rounded, size: size, color: color),
    );
  }
}
