import 'package:basement_music/bloc/player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    return InkWell(
      onTap: () {},
      child: Icon(
        Icons.fast_forward,
        color: Colors.grey,
        size: 30,
      ),
    );
  }
}
