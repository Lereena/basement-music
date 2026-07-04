import 'package:basement_music/bloc/player_cubit/player_cubit.dart';
import 'package:basement_music/bloc/track_progress_cubit/track_progress_cubit.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/widgets/controls/lyrics_toggle.dart';
import 'package:basement_music/widgets/controls/next_button.dart';
import 'package:basement_music/widgets/controls/pause_button.dart';
import 'package:basement_music/widgets/controls/play_button.dart';
import 'package:basement_music/widgets/controls/previous_button.dart';
import 'package:basement_music/widgets/controls/repeat_toggle.dart';
import 'package:basement_music/widgets/controls/shuffle_toggle.dart';
import 'package:basement_music/widgets/cover.dart';
import 'package:basement_music/widgets/lyrics_view.dart';
import 'package:basement_music/widgets/track_name.dart';
import 'package:basement_music/widgets/track_seek_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentTrackView extends StatefulWidget {
  final double coverSize;

  /// Expanded is the full-screen (sheet) presentation: bigger typography
  /// and controls. Compact is the large-screen side panel.
  final bool expanded;

  const CurrentTrackView({super.key, required this.coverSize, this.expanded = false});

  @override
  State<CurrentTrackView> createState() => _CurrentTrackViewState();
}

class _CurrentTrackViewState extends State<CurrentTrackView> {
  var _showLyrics = false;

  double get coverSize => widget.coverSize;

  bool get expanded => widget.expanded;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, PlayerState>(
      builder: (context, state) {
        if (state.currentTrack == Track.empty()) return const SizedBox.shrink();

        final track = state.currentTrack;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: coverSize,
              height: coverSize,
              child: Stack(
                children: [
                  if (_showLyrics)
                    LyricsView(track: track, size: coverSize)
                  else
                    Cover(key: const Key('album_cover'), cover: track.cover, size: coverSize),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: LyricsToggle(
                      active: _showLyrics,
                      size: expanded ? 24 : 20,
                      onToggle: () => setState(() => _showLyrics = !_showLyrics),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: expanded ? 30 : 20),
            TrackName(track: track, moving: true, fontSize: expanded ? 24 : 18),
            Text(
              track.artist,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: expanded ? 18 : 16,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: expanded ? 30 : 20),
            // Scoped so position ticks don't rebuild the cover/marquee/controls
            // above — keeps drag frames cheap.
            BlocBuilder<TrackProgressCubit, TrackProgressState>(
              builder: (context, progress) {
                final progressCubit = context.read<TrackProgressCubit>();

                return Column(
                  children: [
                    TrackSeekBar(
                      percentProgress: progress.percentProgress,
                      enabled: progressCubit.canSeek,
                      onSeek: progressCubit.seek,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          progress.stringProgress,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          progress.stringDuration,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            if (expanded)
              _ExpandedControls(track: track, state: state)
            else
              _CompactControls(track: track, state: state),
          ],
        );
      },
    );
  }
}

class _ExpandedControls extends StatelessWidget {
  final Track track;
  final PlayerState state;

  const _ExpandedControls({required this.track, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const ShuffleToggle(size: 28),
        const PreviousButton(size: 44),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2),
          ),
          child: state.isPlay
              ? const PauseButton(size: 44)
              : PlayButton(track: track, state: state, isBottomPlayer: true, size: 44),
        ),
        const NextButton(size: 44),
        const RepeatToggle(size: 28),
      ],
    );
  }
}

class _CompactControls extends StatelessWidget {
  final Track track;
  final PlayerState state;

  const _CompactControls({required this.track, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 60),
        const Spacer(),
        const PreviousButton(),
        if (state.isPlay)
          const PauseButton()
        else if (state.isPause || state.isInitial)
          PlayButton(track: track, state: state, isBottomPlayer: true),
        const NextButton(),
        const Spacer(),
        const SizedBox(width: 60, child: Row(children: [ShuffleToggle(), RepeatToggle()])),
      ],
    );
  }
}
