import 'package:basement_music/bloc/events/player_event.dart';
import 'package:basement_music/bloc/states/audio_player_state.dart';
import 'package:basement_music/models/track.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/player_bloc.dart';

class PlayButton extends StatelessWidget {
  final Track track;
  final AudioPlayerState state;
  const PlayButton({Key? key, required this.track, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    return InkWell(
      onTap: () {
        if (state is PausedPlayerState)
          playerBloc.add(ResumeEvent());
        else
          playerBloc.add(PlayEvent(track));
      },
      child: Icon(
        Icons.play_arrow_rounded,
        color: Theme.of(context).primaryColor,
        size: 30,
      ),
    );
  }
}
