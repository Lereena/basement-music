import 'package:basement_music/utils/time.dart';
import 'package:basement_music/widgets/controls/next_button.dart';
import 'package:basement_music/widgets/controls/previous_button.dart';
import 'package:basement_music/widgets/track_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/player_bloc/player_bloc.dart';
import '../bloc/player_bloc/player_state.dart';
import '../models/track.dart';
import 'controls/pause_button.dart';
import 'controls/play_button.dart';
import 'controls/repeat_toggle.dart';
import 'controls/shuffle_toggle.dart';

class BottomBar extends StatefulWidget {
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  var _percentProgress = 0.0;
  var _stringProgress = '00:00';

  @override
  void initState() {
    super.initState();
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    playerBloc.onPositionChanged.listen((event) {
      if (mounted) {
        setState(() {
          _percentProgress = event.inSeconds.toDouble() / playerBloc.state.currentTrack.duration;
          _stringProgress = durationString(event.inSeconds);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        if (state.currentTrack == Track.empty()) return Container(height: 0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LinearProgressIndicator(value: _percentProgress),
            Container(
              height: 70,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  PreviousButton(),
                  if (state is PlayingPlayerState || state is ResumedPlayerState)
                    const PauseButton()
                  else if (state is PausedPlayerState || state is InitialPlayerState)
                    PlayButton(track: state.currentTrack, state: state, isBottomPlayer: true),
                  NextButton(),
                  const SizedBox(width: 15),
                  if (state is PausedPlayerState || state is PlayingPlayerState || state is ResumedPlayerState)
                    Image.asset(
                      state.currentTrack.cover,
                      height: 40,
                      width: 40,
                    ),
                  const SizedBox(width: 10),
                  if (state is PlayingPlayerState || state is PausedPlayerState || state is ResumedPlayerState) ...[
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
                      _stringProgress,
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
        );
      },
    );
  }
}
