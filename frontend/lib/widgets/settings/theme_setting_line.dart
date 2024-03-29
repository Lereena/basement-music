import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings_bloc/settings_bloc.dart';

extension ThemeModeTitle on ThemeMode {
  String get title => switch (this) {
        ThemeMode.system => 'Device settings',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };
}

class ThemeSettingLine extends StatefulWidget {
  const ThemeSettingLine({super.key});

  @override
  State<ThemeSettingLine> createState() => _ThemeSettingLineState();
}

class _ThemeSettingLineState extends State<ThemeSettingLine> {
  final _themeFocusNode = FocusNode();

  @override
  void dispose() {
    _themeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          Text(
            'Theme mode',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return DropdownButton<ThemeMode>(
                value: state.themeMode,
                items: ThemeMode.values
                    .map(
                      (mode) => DropdownMenuItem(
                        value: mode,
                        child: Text(mode.title),
                      ),
                    )
                    .toList(),
                focusNode: _themeFocusNode,
                focusColor: Colors.transparent,
                onChanged: (value) {
                  if (value != null) {
                    settingsBloc.add(SetThemeMode(value));
                  }
                  _themeFocusNode.unfocus();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
