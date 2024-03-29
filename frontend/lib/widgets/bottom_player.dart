import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/player_bloc/player_bloc.dart';
import '../bloc/track_progress_cubit/track_progress_cubit.dart';
import '../models/track.dart';
import 'controls/next_button.dart';
import 'controls/pause_button.dart';
import 'controls/play_button.dart';
import 'controls/previous_button.dart';
import 'controls/repeat_toggle.dart';
import 'controls/shuffle_toggle.dart';
import 'track_name.dart';
import 'track_progress_indicator.dart';

class BottomPlayer extends StatelessWidget {
  const BottomPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<TrackProgressCubit>().state;

    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state.currentTrack == Track.empty()) return Container(height: 0);

        return ColoredBox(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TrackProgressIndicator(percentProgress: progress.percentProgress),
              Container(
                height: 70,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const PreviousButton(),
                    if (state is PlayerPlay)
                      const PauseButton()
                    else if (state is PlayerPause || state is PlayerInitial)
                      PlayButton(
                        track: state.currentTrack,
                        state: state,
                        isBottomPlayer: true,
                      ),
                    const NextButton(),
                    const SizedBox(width: 15),
                    if (state is PlayerPause || state is PlayerPlay)
                      Image.asset(
                        state.currentTrack.cover,
                        height: 40,
                        width: 40,
                      ),
                    const SizedBox(width: 10),
                    if (state is PlayerPlay || state is PlayerPause) ...[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TrackName(
                              track: state.currentTrack,
                              moving: true,
                            ),
                            Text(
                              state.currentTrack.artist,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        progress.stringProgress,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      const ShuffleToggle(),
                      const RepeatToggle(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
