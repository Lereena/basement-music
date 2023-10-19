import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/player_bloc/player_bloc.dart';
import '../../bloc/player_bloc/player_event.dart';
import '../../bloc/player_bloc/player_state.dart';

class PreviousButton extends StatelessWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.read<PlayerBloc>();

    return InkWell(
      onTap: () {
        if (playerBloc.state is InitialPlayerState) return;
        playerBloc.add(PreviousEvent());
      },
      child: const Icon(
        Icons.fast_rewind,
        size: 30,
      ),
    );
  }
}
