import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings_bloc/settings_bloc.dart';

class RepeatToggle extends StatelessWidget {
  const RepeatToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);

    return InkWell(
      onTap: () => settingsBloc.add(SetRepeat(!settingsBloc.state.repeat)),
      child: Icon(
        settingsBloc.state.repeat ? Icons.repeat_on_outlined : Icons.repeat,
        size: 30,
      ),
    );
  }
}
