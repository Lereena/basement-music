import 'package:basement_music/bloc/player_bloc/player_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/player_bloc/player_bloc.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    return InkWell(
      onTap: () {
        playerBloc.add(PauseEvent());
      },
      child: const Icon(
        Icons.pause,
        size: 30,
      ),
    );
  }
}
