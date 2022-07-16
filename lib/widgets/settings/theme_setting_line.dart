import 'package:basement_music/settings.dart';
import 'package:flutter/material.dart';

import '../../theme/config.dart';
import 'settings_line_decoration.dart';

class ThemeSettingLine extends StatefulWidget {
  const ThemeSettingLine({Key? key}) : super(key: key);

  @override
  State<ThemeSettingLine> createState() => _ThemeSettingLineState();
}

class _ThemeSettingLineState extends State<ThemeSettingLine> {
  @override
  Widget build(BuildContext context) {
    return SettingsLineDecoration(
      child: Row(
        children: [
          Text('Night theme'),
          Spacer(),
          Switch(
              value: currentTheme.isDarkTheme,
              onChanged: (value) async {
                await setDarkTheme(value);

                setState(() => currentTheme.toggleTheme());
              }),
        ],
      ),
    );
  }
}
