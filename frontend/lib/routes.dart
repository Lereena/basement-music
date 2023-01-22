import 'package:firebase_ui_auth/firebase_ui_auth.dart';
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
    case NavigationRoute.signIn:
      return MaterialPageRoute(
        builder: (context) => SelectionArea(
          child: SignInScreen(
            providers: [EmailAuthProvider()],
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, NavigationRoute.profile.name);
              }),
            ],
          ),
        ),
      );
    case NavigationRoute.profile:
      return MaterialPageRoute(
        builder: (context) => ProfileScreen(
          providers: [EmailAuthProvider()],
          actions: [
            SignedOutAction((context) {
              Navigator.pushReplacementNamed(context, NavigationRoute.signIn.name);
            }),
          ],
        ),
      );
  }

  throw Exception('No route with name ${settings.name}');
}

enum NavigationRoute { signIn, profile, initial, settings, playlist, upload }

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
      case NavigationRoute.signIn:
        return '/signIn';
      case NavigationRoute.profile:
        return '/profile';
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
      case '/signIn':
        return NavigationRoute.signIn;
      case '/profile':
        return NavigationRoute.profile;
      default:
        throw Exception('No route with name $this');
    }
  }
}
