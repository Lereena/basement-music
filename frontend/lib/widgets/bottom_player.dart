import 'package:basement_music/bloc/player_cubit/player_cubit.dart';
import 'package:basement_music/bloc/track_progress_cubit/track_progress_cubit.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/theme/theme.dart';
import 'package:basement_music/widgets/controls/next_button.dart';
import 'package:basement_music/widgets/controls/pause_button.dart';
import 'package:basement_music/widgets/controls/play_button.dart';
import 'package:basement_music/widgets/controls/previous_button.dart';
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
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: AppRadius.smAll,
                        child: Cover(cover: state.currentTrack.cover, version: state.currentTrack.updatedAt, size: 48),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TrackName(track: state.currentTrack, moving: true),
                            Text(
                              state.currentTrack.artist,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const PreviousButton(),
                      const SizedBox(width: AppSpacing.xs),
                      if (state.isPlay)
                        const PauseButton(size: 34)
                      else if (state.isPause || state.isInitial)
                        PlayButton(track: state.currentTrack, state: state, isBottomPlayer: true, size: 34),
                      const SizedBox(width: AppSpacing.xs),
                      const NextButton(),
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
