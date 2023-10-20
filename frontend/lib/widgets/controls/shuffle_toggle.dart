import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings_bloc/settings_bloc.dart';

class ShuffleToggle extends StatelessWidget {
  const ShuffleToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();

    return InkWell(
      onTap: () => settingsBloc.add(SetShuffle(!settingsBloc.state.shuffle)),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return Icon(
            state.shuffle ? Icons.shuffle_on_outlined : Icons.shuffle,
            size: 30,
          );
        },
      ),
    );
  }
}
