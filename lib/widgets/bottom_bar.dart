import 'package:basement_music/bloc/player_bloc/player_event.dart';
import 'package:basement_music/utils/time.dart';
import 'package:basement_music/widgets/controls/next_button.dart';
import 'package:basement_music/widgets/controls/previous_button.dart';
import 'package:basement_music/widgets/track_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../audio_player.dart';
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
  var percentProgress = 0.0;
  var stringProgress = '00:00';

  @override
  void initState() {
    super.initState();
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    audioPlayer.onPlayerComplete.listen((event) {
      playerBloc.add(NextEvent());
    });
    audioPlayer.onPositionChanged.listen((event) {
      if (mounted)
        setState(() {
          percentProgress = event.inSeconds.toDouble() / playerBloc.state.currentTrack.duration;
          stringProgress = durationString(event.inSeconds);
        });
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
            LinearProgressIndicator(value: percentProgress),
            Container(
              height: 70,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  PreviousButton(),
                  if (state is PlayingPlayerState || state is ResumedPlayerState)
                    PauseButton()
                  else if (state is PausedPlayerState || state is InitialPlayerState)
                    PlayButton(track: state.currentTrack, state: state, isBottomPlayer: true),
                  NextButton(),
                  SizedBox(width: 15),
                  if (state is PausedPlayerState || state is PlayingPlayerState || state is ResumedPlayerState)
                    Image.asset(
                      state.currentTrack.cover,
                      height: 40,
                      width: 40,
                    ),
                  SizedBox(width: 10),
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
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      stringProgress,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 10),
                    ShuffleToggle(),
                    RepeatToggle(),
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
