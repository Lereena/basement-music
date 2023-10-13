import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../pages/library_page.dart';
import '../pages/playlist_page.dart';
import '../pages/search_page.dart';
import '../pages/settings_page.dart';
import '../pages/tracks_page.dart';
import '../pages/upload/upload_page.dart';
import 'app_scaffold_shell.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: NavigationRoute.initial.name,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: NavigationRoute.initial.name,
        redirect: (_, __) => NavigationRoute.tracks.name,
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) => AppScaffoldShell(
          navigationShell: navigationShell,
        ),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            initialLocation: NavigationRoute.tracks.name,
            routes: [
              GoRoute(
                name: NavigationRoute.tracks.title,
                path: NavigationRoute.tracks.name,
                pageBuilder: (_, __) => NoTransitionPage(
                  child: TracksPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            initialLocation: NavigationRoute.library.name,
            routes: [
              GoRoute(
                name: NavigationRoute.library.title,
                path: NavigationRoute.library.name,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: LibraryPage(),
                ),
                routes: [
                  GoRoute(
                    name: NavigationRoute.playlist.name,
                    path: ":id",
                    pageBuilder: (_, state) => NoTransitionPage(
                      child: PlaylistPage(
                        playlistId: state.pathParameters['id']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            initialLocation: NavigationRoute.search.name,
            routes: [
              GoRoute(
                name: NavigationRoute.search.title,
                path: NavigationRoute.search.name,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: SearchPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            initialLocation: NavigationRoute.upload.name,
            routes: [
              GoRoute(
                name: NavigationRoute.upload.title,
                path: NavigationRoute.upload.name,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: UploadPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            initialLocation: NavigationRoute.settings.name,
            routes: [
              GoRoute(
                name: NavigationRoute.settings.title,
                path: NavigationRoute.settings.name,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: SettingsPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
