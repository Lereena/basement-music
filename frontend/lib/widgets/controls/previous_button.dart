import 'package:basement_music/bloc/player_cubit/player_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviousButton extends StatelessWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<PlayerCubit>();

    return InkWell(
      onTap: () {
        if (playerCubit.state.isInitial) return;
        playerCubit.previous();
      },
      child: const Icon(Icons.fast_rewind, size: 30),
    );
  }
}
