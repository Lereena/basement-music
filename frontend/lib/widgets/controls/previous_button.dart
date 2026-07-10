import 'package:basement_music/bloc/player_cubit/player_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviousButton extends StatelessWidget {
  final double size;

  const PreviousButton({super.key, this.size = 30});

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<PlayerCubit>();

    return InkWell(
      onTap: () {
        if (playerCubit.state.isInitial) return;
        playerCubit.previous();
      },
      child: Icon(Icons.fast_rewind, size: size),
    );
  }
}
