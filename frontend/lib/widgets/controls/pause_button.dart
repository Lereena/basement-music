import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/player_bloc/player_bloc.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.read<PlayerBloc>();

    return InkWell(
      onTap: () => playerBloc.add(PlayerPaused()),
      child: const Icon(
        Icons.pause,
        size: 30,
      ),
    );
  }
}
