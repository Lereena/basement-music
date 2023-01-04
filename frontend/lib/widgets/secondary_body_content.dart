import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../bloc/player_bloc/player_bloc.dart';
import '../bloc/player_bloc/player_state.dart';
import '../bloc/track_progress_cubit/track_progress_cubit.dart';
import '../models/track.dart';
import 'animated_progress_bar.dart';
import 'controls/next_button.dart';
import 'controls/pause_button.dart';
import 'controls/play_button.dart';
import 'controls/previous_button.dart';
import 'controls/repeat_toggle.dart';
import 'controls/shuffle_toggle.dart';
import 'cover.dart';
import 'track_name.dart';

class SecondaryBodyContent extends StatelessWidget {
  const SecondaryBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<TrackProgressCubit>().state;

    return BlocBuilder<PlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        if (state.currentTrack == Track.empty()) return const SizedBox.shrink();

        final track = state.currentTrack;

        return DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.grey,
                width: 0.1,
              ),
            ),
          ),
          child: Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Cover(cover: track.cover, size: 27.w),
                  const SizedBox(height: 20),
                  TrackName(track: track, moving: true),
                  Text(
                    track.artist,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  AnimatedProgressBar(value: progress.percentProgress),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Visibility(
                          visible: false,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: Row(
                            children: const [
                              ShuffleToggle(),
                              RepeatToggle(),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      PreviousButton(),
                      if (state is PlayingPlayerState || state is ResumedPlayerState)
                        const PauseButton()
                      else if (state is PausedPlayerState || state is InitialPlayerState)
                        PlayButton(track: track, state: state, isBottomPlayer: true),
                      NextButton(),
                      const Spacer(),
                      Row(
                        children: const [
                          ShuffleToggle(),
                          RepeatToggle(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
