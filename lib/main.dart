import 'package:basement_music/routes.dart';
import 'package:basement_music/theme/config.dart';
import 'package:basement_music/theme/custom_theme.dart';

import 'pages/home_page.dart';
import 'pages/playlist_page.dart';
import 'pages/settings_page.dart';

import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';

import 'pages/upload/upload_page.dart';

void main() {
  runApp(BasementMusic());
}

class BasementMusic extends StatefulWidget {
  @override
  State<BasementMusic> createState() => _BasementMusicState();
}

class _BasementMusicState extends State<BasementMusic> {
  @override
  void initState() {
    super.initState();

    currentTheme.initTheme();

    currentTheme.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basement music',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentThemeMode,
      initialRoute: NavigationRoute.initial.name,
      routes: {
        NavigationRoute.settings.name: (context) => SettingsPage(),
        NavigationRoute.upload.name: (context) => UploadPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == NavigationRoute.playlist.name) {
          final playlistId = (settings.arguments as Map<String, String>)['playlistId']!;
          return MaterialPageRoute(builder: (context) => PlaylistPage(playlistId: playlistId));
        }
        return null;
      },
      home: ContextMenuOverlay(
        child: MyHomePage(title: 'Basement music'),
      ),
    );
  }
}
