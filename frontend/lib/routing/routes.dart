import 'package:flutter/material.dart';

abstract class Routes {
  static String playlist(String id) => '/library/$id';
}

enum NavigationRoute {
  initial,
  tracks,
  library,
  search,
  playlist,
  upload,
  settings
}

extension Name on NavigationRoute {
  String get name {
    switch (this) {
      case NavigationRoute.initial:
        return '/';
      case NavigationRoute.tracks:
        return '/tracks';
      case NavigationRoute.library:
        return '/library';
      case NavigationRoute.search:
        return '/search';
      case NavigationRoute.settings:
        return '/settings';
      case NavigationRoute.playlist:
        return '/library/:id';
      case NavigationRoute.upload:
        return '/upload';
    }
  }

  String get title {
    switch (this) {
      case NavigationRoute.initial:
        return '/';
      case NavigationRoute.tracks:
        return 'All tracks';
      case NavigationRoute.library:
        return 'Library';
      case NavigationRoute.search:
        return 'Search';
      case NavigationRoute.settings:
        return 'Settings';
      case NavigationRoute.playlist:
        return 'Playlist';
      case NavigationRoute.upload:
        return 'Upload';
    }
  }

  Widget get icon {
    switch (this) {
      case NavigationRoute.initial:
        return const SizedBox.shrink();
      case NavigationRoute.tracks:
        return const Icon(Icons.home);
      case NavigationRoute.library:
        return const Icon(Icons.library_music);
      case NavigationRoute.search:
        return const Icon(Icons.search);
      case NavigationRoute.settings:
        return const Icon(Icons.settings, size: 30);
      case NavigationRoute.playlist:
        return const Icon(Icons.library_music);
      case NavigationRoute.upload:
        return const Icon(Icons.upload);
    }
  }
}

// TODO
// MaterialPageRoute<dynamic> onGenerateRoute(RouteSettings settings) {
  // switch (settings.name!.route) {
  //   case NavigationRoute.initial:
  //     break;
  //   case NavigationRoute.settings:
  //     return MaterialPageRoute(builder: (context) => const SettingsPage());
  //   case NavigationRoute.playlist:
  //     final playlist =
  //         (settings.arguments! as Map<String, Playlist>)['playlist']!;
  //     return MaterialPageRoute(
  //       builder: (context) => PlaylistPage(playlist: playlist),
  //     );
  //   case NavigationRoute.upload:
  //     return MaterialPageRoute(builder: (context) => const UploadPage());
  // }

  // throw Exception('No route with name ${settings.name}');
// }

// extension Route on String {
//   NavigationRoute get route {
//     switch (this) {
//       case '/':
//         return NavigationRoute.initial;
//       case '/settings':
//         return NavigationRoute.settings;
//       case '/playlist':
//         return NavigationRoute.playlist;
//       case '/upload':
//         return NavigationRoute.upload;
//       default:
//         throw Exception('No route with name $this');
//     }
//   }
// }
