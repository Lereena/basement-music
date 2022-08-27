import 'package:basement_music/bloc/cacher_bloc/bloc/cacher_bloc.dart';
import 'package:basement_music/bloc/player_bloc/player_state.dart';
import 'package:basement_music/widgets/buttons/more_button.dart';
import 'package:basement_music/widgets/controls/pause_button.dart';
import 'package:basement_music/widgets/cover_overlay.dart';
import 'package:basement_music/widgets/track_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/player_bloc/player_bloc.dart';
import '../models/track.dart';
import 'controls/play_button.dart';
import 'cover.dart';

class TrackCard extends StatelessWidget {
  final Track track;

  const TrackCard({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    return BlocBuilder<CacherBloc, CacherState>(
      builder: (context, cacherState) {
        final isCaching = cacherState.isCaching([track.id]);
        final isCached = cacherState.isCached([track.id]);

        return BlocBuilder<PlayerBloc, AudioPlayerState>(
          builder: (context, playerState) => ColoredBox(
            color:
                playerBloc.currentTrack == track ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
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
                        if (playerBloc.currentTrack == track &&
                            (playerState is PlayingPlayerState || playerState is ResumedPlayerState))
                          const PauseButton()
                        else
                          PlayButton(track: track, state: playerState),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TrackName(
                        track: track,
                        moving: playerBloc.currentTrack == track,
                      ),
                      Text(
                        track.artist,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  track.durationStr,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 15),
                MoreButton(track: track),
                const SizedBox(width: 15),
              ],
            ),
          ),
        );
      },
    );
  }
}
