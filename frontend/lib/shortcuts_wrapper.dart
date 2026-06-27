import 'package:flutter/material.dart';

class ShortcutsWrapper extends StatelessWidget {
  final Widget child;

  const ShortcutsWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;

    // TODO: Fix space shortcut for text fields
    // final playerCubit = context.read<PlayerCubit>();

    // return CallbackShortcuts(
    // bindings: {const SingleActivator(LogicalKeyboardKey.space): () => _spaceAction(playerCubit)},
    // child: Focus(autofocus: true, child: child),
    // );
  }

  // void _spaceAction(PlayerCubit playerCubit) {
  //   if (playerCubit.state.isInitial) return;

  //   if (playerCubit.state.isPause) {
  //     playerCubit.playByShortcut();
  //   } else if (playerCubit.state.isPlay) {
  //     playerCubit.pause();
  //   }
  // }
}
