import 'package:basement_music/bloc/states/audio_player_state.dart';
import 'package:basement_music/widgets/controls/pause_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/events/player_event.dart';
import 'models/track.dart';
import 'bloc/player_bloc.dart';
import 'widgets/controls/play_button.dart';

class TrackCard extends StatefulWidget {
  final Track track;

  TrackCard({Key? key, required this.track}) : super(key: key);

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  @override
  Widget build(BuildContext context) {
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    return BlocBuilder<PlayerBloc, AudioPlayerState>(
      builder: (context, state) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              'assets/cover_placeholder.png',
              width: 40,
              height: 40,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.track.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                widget.track.artist,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Spacer(),
          Text(
            widget.track.durationStr,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: 20),
          if (state.currentTrack != widget.track || !(state is PlayingPlayerState))
            PlayButton(
              track: widget.track,
              onTap: state is PausedPlayerState
                  ? () => playerBloc.add(ResumeEvent())
                  : () => playerBloc.add(PlayEvent(widget.track)),
            )
          else if (state is PlayingPlayerState)
            PauseButton(),
          SizedBox(width: 20)
        ],
      ),
    );
  }
}
