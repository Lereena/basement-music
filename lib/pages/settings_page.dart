import 'package:basement_music/widgets/bottom_bar.dart';
import 'package:basement_music/widgets/settings/server_setting_line.dart';
import 'package:basement_music/widgets/settings/theme_setting_line.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          ThemeSettingLine(),
          ServerSettingLine(),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
