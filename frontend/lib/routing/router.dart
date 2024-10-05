import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../pages/artist_page.dart';
import '../pages/edit_playlist/playlist_edit_page.dart';
import '../pages/library/library_page.dart';
import '../pages/playlist_page.dart';
import '../pages/search_page.dart';
import '../pages/settings_page.dart';
import '../pages/tracks_page.dart';
import '../pages/upload/from_device/upload_from_device.dart';
import '../pages/upload/from_youtube/extract_from_youtube.dart';
import '../pages/upload/upload_page.dart';
import 'app_scaffold_shell.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteName.initial,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: RouteName.initial,
        redirect: (_, __) => RouteName.tracks,
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) => AppScaffoldShell(
          navigationShell: navigationShell,
        ),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            initialLocation: RouteName.tracks,
            routes: [
              GoRoute(
                path: RouteName.tracks,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: TracksPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            initialLocation: RouteName.library,
            routes: [
              GoRoute(
                path: RouteName.library,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: LibraryPage(initialTab: LibraryPageTab.playlists),
                ),
                routes: [
                  GoRoute(
                    path: ":id",
                    pageBuilder: (_, state) => NoTransitionPage(
                      child: PlaylistPage(
                        playlistId: state.pathParameters['id']!,
                      ),
                    ),
                    routes: [
                      GoRoute(
                        path: "edit",
                        pageBuilder: (_, state) => NoTransitionPage(
                          child: PlaylistEditPage(
                            playlistId: state.pathParameters['id']!,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: "artists",
                    pageBuilder: (_, __) => const NoTransitionPage(
                      child: LibraryPage(initialTab: LibraryPageTab.artists),
                    ),
                  ),
                  GoRoute(
                    path: "artist/:id",
                    pageBuilder: (_, state) => NoTransitionPage(
                      child: ArtistPage(
                        artistId: state.pathParameters['id']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            initialLocation: RouteName.search,
            routes: [
              GoRoute(
                path: RouteName.search,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: SearchPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            initialLocation: RouteName.upload,
            routes: [
              GoRoute(
                path: RouteName.upload,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: UploadPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'fromDevice',
                    pageBuilder: (_, __) => const NoTransitionPage(
                      child: UploadFromDevicePage(),
                    ),
                  ),
                  GoRoute(
                    path: 'fromYoutube',
                    pageBuilder: (_, __) => const NoTransitionPage(
                      child: ExtractFromYoutubePage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            initialLocation: RouteName.settings,
            routes: [
              GoRoute(
                path: RouteName.settings,
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
