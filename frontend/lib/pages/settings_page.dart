import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import '../widgets/settings/cache_all_tracks_settings_line.dart';
import '../widgets/settings/theme_setting_line.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasementAppBar(title: 'Settings'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Divider(),
          ThemeSettingLine(),
          Divider(),
          if (!kIsWeb) ...[
            CacheAllTracksSettingsLine(),
            Divider(),
          ],
        ],
      ),
    );
  }
}
