import 'package:basement_music/bloc/player_cubit/player_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<PlayerCubit>();

    return InkWell(onTap: () => playerCubit.pause(), child: const Icon(Icons.pause, size: 30));
  }
}
