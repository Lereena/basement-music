import 'package:flutter/material.dart';

import 'models/playlist.dart';
import 'pages/playlist_page.dart';
import 'pages/settings_page.dart';
import 'pages/upload/upload_page.dart';

MaterialPageRoute<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name!.route) {
    case NavigationRoute.initial:
      break;
    case NavigationRoute.settings:
      return MaterialPageRoute(builder: (context) => const SettingsPage());
    case NavigationRoute.playlist:
      final playlist = (settings.arguments! as Map<String, Playlist>)['playlist']!;
      return MaterialPageRoute(builder: (context) => PlaylistPage(playlist: playlist));
    case NavigationRoute.upload:
      return MaterialPageRoute(builder: (context) => const UploadPage());
  }

  throw Exception('No route with name ${settings.name}');
}

enum NavigationRoute { initial, settings, playlist, upload }

extension Name on NavigationRoute {
  String get name {
    switch (this) {
      case NavigationRoute.initial:
        return '/';
      case NavigationRoute.settings:
        return '/settings';
      case NavigationRoute.playlist:
        return '/playlist';
      case NavigationRoute.upload:
        return '/upload';
    }
  }
}

extension Route on String {
  NavigationRoute get route {
    switch (this) {
      case '/':
        return NavigationRoute.initial;
      case '/settings':
        return NavigationRoute.settings;
      case '/playlist':
        return NavigationRoute.playlist;
      case '/upload':
        return NavigationRoute.upload;
      default:
        throw Exception('No route with name $this');
    }
  }
}
