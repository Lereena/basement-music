import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:basement_music/bloc/player_cubit/player_cubit.dart';

class ShortcutsWrapper extends StatelessWidget {
  final Widget child;

  const ShortcutsWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<PlayerCubit>();

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): () =>
            _spaceAction(playerCubit),
      },
      child: Focus(autofocus: true, child: child),
    );
  }

  void _spaceAction(PlayerCubit playerCubit) {
    if (playerCubit.state.isInitial) return;

    if (playerCubit.state.isPause) {
      playerCubit.playByShortcut();
    } else if (playerCubit.state.isPlay) {
      playerCubit.pause();
    }
  }
}
