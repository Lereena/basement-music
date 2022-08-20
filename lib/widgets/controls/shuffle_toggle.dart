import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings_bloc/settings_bloc.dart';

class ShuffleToggle extends StatelessWidget {
  ShuffleToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);

    return InkWell(
      onTap: () => settingsBloc.add(SetShuffle(!settingsBloc.state.shuffle)),
      child: Icon(
        settingsBloc.state.shuffle ? Icons.shuffle_on_outlined : Icons.shuffle,
        size: 30,
      ),
    );
  }
}
