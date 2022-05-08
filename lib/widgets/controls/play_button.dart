import 'package:basement_music/models/track.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/player_bloc.dart';

class PlayButton extends StatelessWidget {
  final Track track;
  final Function() onTap;
  const PlayButton({Key? key, required this.track, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    return InkWell(
      onTap: onTap,
      child: const Icon(
        Icons.play_arrow_rounded,
        color: Colors.grey,
        size: 30,
      ),
    );
  }
}
