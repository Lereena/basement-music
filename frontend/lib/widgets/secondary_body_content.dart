import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../bloc/player_bloc/player_bloc.dart';
import '../bloc/track_progress_cubit/track_progress_cubit.dart';
import '../models/track.dart';
import 'controls/next_button.dart';
import 'controls/pause_button.dart';
import 'controls/play_button.dart';
import 'controls/previous_button.dart';
import 'controls/repeat_toggle.dart';
import 'controls/shuffle_toggle.dart';
import 'cover.dart';
import 'track_name.dart';
import 'track_progress_indicator.dart';

class SecondaryBodyContent extends StatelessWidget {
  const SecondaryBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<TrackProgressCubit>().state;

    return BlocBuilder<PlayerBloc, PlayerState>(
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Cover(
                  key: const Key('album_cover'),
                  cover: track.cover,
                  size: 27.w,
                ),
                const SizedBox(height: 20),
                TrackName(track: track, moving: true),
                Text(
                  track.artist,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TrackProgressIndicator(
                  percentProgress: progress.percentProgress,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        progress.stringProgress,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    const PreviousButton(),
                    if (state is PlayerPlay)
                      const PauseButton()
                    else if (state is PlayerPause || state is PlayerInitial)
                      PlayButton(
                        track: track,
                        state: state,
                        isBottomPlayer: true,
                      ),
                    const NextButton(),
                    const Spacer(),
                    const SizedBox(
                      width: 60,
                      child: Row(
                        children: [
                          ShuffleToggle(),
                          RepeatToggle(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
