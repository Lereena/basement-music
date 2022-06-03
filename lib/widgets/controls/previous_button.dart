import 'package:basement_music/bloc/events/player_event.dart';
import 'package:basement_music/bloc/player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviousButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    return InkWell(
      onTap: () {
        playerBloc.add(PreviousEvent());
      },
      child: Icon(
        Icons.fast_rewind,
        color: Theme.of(context).primaryColor,
        size: 30,
      ),
    );
  }
}
