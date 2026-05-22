import 'package:basement_music/bloc/cacher_cubit/cacher_cubit.dart';
import 'package:basement_music/bloc/player_cubit/player_cubit.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/widgets/buttons/more_button.dart';
import 'package:basement_music/widgets/controls/pause_button.dart';
import 'package:basement_music/widgets/controls/play_button.dart';
import 'package:basement_music/widgets/cover.dart';
import 'package:basement_music/widgets/cover_overlay.dart';
import 'package:basement_music/widgets/track_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackCard extends StatelessWidget {
  final Track track;
  final bool active;
  final Playlist? containingPlaylist;
  final Playlist? openedPlaylist;

  const TrackCard({super.key, required this.track, this.active = true, this.containingPlaylist, this.openedPlaylist});

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<PlayerCubit>();

    return BlocBuilder<CacherCubit, CacherState>(
      builder: (context, cacherState) {
        final isCaching = cacherState.isCaching([track.id]);
        final isCached = cacherState.isCached([track.id]);
        final canBePlayed = active || isCached;

        return IgnorePointer(
          ignoring: !canBePlayed,
          child: Opacity(
            opacity: canBePlayed ? 1 : 0.5,
            child: BlocBuilder<PlayerCubit, PlayerState>(
              builder: (context, playerState) => ColoredBox(
                color: playerCubit.state.currentTrack == track
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Cover(
                              cover: track.cover,
                              overlay: CoverOverlay(isCaching: isCaching, isCached: isCached),
                            ),
                            if (playerCubit.state.currentTrack == track && playerState.isPlay)
                              const PauseButton()
                            else
                              PlayButton(track: track, state: playerState, openedPlaylist: openedPlaylist),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TrackName(track: track, moving: playerCubit.state.currentTrack == track),
                          Text(track.artist, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(track.durationStr, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 15),
                    MoreButton(track: track, playlist: containingPlaylist),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
