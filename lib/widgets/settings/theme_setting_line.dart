import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings_bloc/settings_bloc.dart';
import 'settings_line_decoration.dart';

class ThemeSettingLine extends StatefulWidget {
  const ThemeSettingLine({Key? key}) : super(key: key);

  @override
  State<ThemeSettingLine> createState() => _ThemeSettingLineState();
}

class _ThemeSettingLineState extends State<ThemeSettingLine> {
  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);

    return SettingsLineDecoration(
      child: Row(
        children: [
          const Text('Night theme'),
          const Spacer(),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Switch(
                value: state.darkTheme,
                onChanged: (value) => settingsBloc.add(SetDarkTheme(value)),
              );
            },
          ),
        ],
      ),
    );
  }
}
