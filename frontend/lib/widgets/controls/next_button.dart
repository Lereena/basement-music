import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/player_bloc/player_bloc.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.read<PlayerBloc>();

    return InkWell(
      onTap: () {
        if (playerBloc.state is PlayerInitial) return;
        playerBloc.add(PlayerNextStarted());
      },
      child: const Icon(
        Icons.fast_forward,
        size: 30,
      ),
    );
  }
}
