import 'package:basement_music/bloc/player_bloc/player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bloc/player_bloc/player_event.dart';
import 'bloc/player_bloc/player_state.dart';

class ShortcutsWrapper extends StatelessWidget {
  final PlayerBloc playerBloc;
  final Widget child;

  const ShortcutsWrapper({
    super.key,
    required this.playerBloc,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): () => _spaceAction(playerBloc),
      },
      child: Focus(autofocus: true, child: child),
    );
  }

  void _spaceAction(PlayerBloc playerBloc) {
    if (playerBloc.state is InitialPlayerState) return;

    if (playerBloc.state is PausedPlayerState) {
      playerBloc.add(ResumeEvent());
    } else if (playerBloc.state is PlayingPlayerState || playerBloc.state is ResumedPlayerState) {
      playerBloc.add(PauseEvent());
    }
  }
}
