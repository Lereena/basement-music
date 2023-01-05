import 'package:flutter/material.dart';

import '../widgets/settings/theme_setting_line.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Divider(),
        ThemeSettingLine(),
      ],
    );
  }
}
