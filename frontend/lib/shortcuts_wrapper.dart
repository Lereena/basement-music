import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/player_bloc/player_bloc.dart';

class ShortcutsWrapper extends StatelessWidget {
  final Widget child;

  const ShortcutsWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.read<PlayerBloc>();

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): () =>
            _spaceAction(playerBloc),
      },
      child: Focus(autofocus: true, child: child),
    );
  }

  void _spaceAction(PlayerBloc playerBloc) {
    if (playerBloc.state is PlayerInitial) return;

    if (playerBloc.state is PlayerPause) {
      playerBloc.add(PlayerPlayStarted(track: playerBloc.state.currentTrack));
    } else if (playerBloc.state is PlayerPlay) {
      playerBloc.add(PlayerPaused());
    }
  }
}
