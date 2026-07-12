import 'package:basement_music/bloc/player_cubit/player_cubit.dart';
import 'package:basement_music/bloc/track_progress_cubit/track_progress_cubit.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/widgets/controls/next_button.dart';
import 'package:basement_music/widgets/controls/pause_button.dart';
import 'package:basement_music/widgets/controls/play_button.dart';
import 'package:basement_music/widgets/controls/previous_button.dart';
import 'package:basement_music/widgets/controls/repeat_toggle.dart';
import 'package:basement_music/widgets/controls/shuffle_toggle.dart';
import 'package:basement_music/widgets/cover.dart';
import 'package:basement_music/widgets/current_track_sheet.dart';
import 'package:basement_music/widgets/track_name.dart';
import 'package:basement_music/widgets/track_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomPlayer extends StatelessWidget {
  const BottomPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<TrackProgressCubit>().state;

    return BlocBuilder<PlayerCubit, PlayerState>(
      builder: (context, state) {
        if (state.currentTrack == Track.empty()) return Container(height: 0);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => showCurrentTrackSheet(context),
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface,
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
                      if (state.isPlay)
                        const PauseButton()
                      else if (state.isPause || state.isInitial)
                        PlayButton(track: state.currentTrack, state: state, isBottomPlayer: true),
                      const NextButton(),
                      const SizedBox(width: 15),
                      if (state.isPause || state.isPlay)
                        Cover(cover: state.currentTrack.cover, version: state.currentTrack.updatedAt),
                      const SizedBox(width: 10),
                      if (state.isPlay || state.isPause) ...[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TrackName(track: state.currentTrack, moving: true),
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
          ),
        );
      },
    );
  }
}
