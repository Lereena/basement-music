import 'package:basement_music/widgets/controls/next_button.dart';
import 'package:basement_music/widgets/controls/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/player_bloc.dart';
import 'bloc/states/audio_player_state.dart';
import 'widgets/controls/pause_button.dart';
import 'widgets/controls/play_button.dart';

class BottomBar extends StatefulWidget {
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      padding: EdgeInsets.all(10),
      child: BlocBuilder<PlayerBloc, AudioPlayerState>(
        builder: (context, state) {
          return Row(
            children: [
              PreviousButton(),
              if (state is PlayingPlayerState)
                PauseButton()
              else if (state is PausedPlayerState || state is InitialPlayerState)
                PlayButton(track: state.currentTrack, onTap: () {}),
              NextButton(),
              SizedBox(width: 15),
              Image.asset(
                'assets/cover_placeholder.png',
                height: 40,
                width: 40,
              ),
              SizedBox(width: 10),
              if (state is PlayingPlayerState || state is PausedPlayerState) ...[
                Text(
                  '${state.currentTrack.artist} - ${state.currentTrack.title}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Text(
                  state.currentTrack.durationStr,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
