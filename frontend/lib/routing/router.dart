import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:basement_music/bloc/auth_cubit/auth_cubit.dart';
import 'package:basement_music/pages/artist_page.dart';
import 'package:basement_music/pages/edit_playlist/playlist_edit_page.dart';
import 'package:basement_music/pages/library/library_page.dart';
import 'package:basement_music/pages/favourites_page.dart';
import 'package:basement_music/pages/login_page.dart';
import 'package:basement_music/pages/playlist_page.dart';
import 'package:basement_music/pages/register_code_page.dart';
import 'package:basement_music/pages/search_page.dart';
import 'package:basement_music/pages/settings_page.dart';
import 'package:basement_music/pages/tracks_page.dart';
import 'package:basement_music/pages/upload/from_device/upload_from_device.dart';
import 'package:basement_music/pages/upload/from_youtube/extract_from_youtube.dart';
import 'package:basement_music/pages/upload/upload_page.dart';
import 'package:basement_music/routing/app_scaffold_shell.dart';
import 'package:basement_music/routing/routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter createRouter(AuthCubit authCubit) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: RouteName.initial,
      debugLogDiagnostics: true,
      refreshListenable: _GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) {
        final loc = state.matchedLocation;
        final authState = authCubit.state;

        return authState.when(
          loading: () => null,
          unauthenticated: () =>
              loc == RouteName.login ? null : RouteName.login,
          pendingRegistration: () =>
              loc == RouteName.registerCode ? null : RouteName.registerCode,
          authenticated: (_) =>
              (loc == RouteName.login || loc == RouteName.registerCode)
                  ? RouteName.tracks
                  : null,
          error: (_) => loc == RouteName.login ? null : RouteName.login,
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: RouteName.login,
          pageBuilder: (_, _) =>
              const NoTransitionPage(child: LoginPage()),
        ),
        GoRoute(
          path: RouteName.registerCode,
          pageBuilder: (_, _) =>
              const NoTransitionPage(child: RegisterCodePage()),
        ),
        GoRoute(
          path: RouteName.initial,
          redirect: (_, _) => RouteName.tracks,
        ),
        StatefulShellRoute.indexedStack(
          builder: (_, _, navigationShell) => AppScaffoldShell(
            navigationShell: navigationShell,
          ),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              initialLocation: RouteName.tracks,
              routes: [
                GoRoute(
                  path: RouteName.tracks,
                  pageBuilder: (_, _) => const NoTransitionPage(
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
                  pageBuilder: (_, _) => const NoTransitionPage(
                    child: LibraryPage(initialTab: LibraryPageTab.playlists),
                  ),
                  routes: [
                    GoRoute(
                      path: "playlist/:id",
                      pageBuilder: (_, state) => NoTransitionPage(
                        child: PlaylistPage(
                          playlistId: state.pathParameters['id']!,
                        ),
                      ),
                    ),
                    GoRoute(
                      path: "playlist/:id/edit",
                      pageBuilder: (_, state) => NoTransitionPage(
                        child: PlaylistEditPage(
                          playlistId: state.pathParameters['id']!,
                        ),
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
                  pageBuilder: (_, _) => const NoTransitionPage(
                    child: SearchPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              initialLocation: RouteName.favourites,
              routes: [
                GoRoute(
                  path: RouteName.favourites,
                  pageBuilder: (_, _) => const NoTransitionPage(
                    child: FavouritesPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              initialLocation: RouteName.upload,
              routes: [
                GoRoute(
                  path: RouteName.upload,
                  pageBuilder: (_, _) => const NoTransitionPage(
                    child: UploadPage(),
                  ),
                  routes: [
                    GoRoute(
                      path: 'fromDevice',
                      pageBuilder: (_, _) => const NoTransitionPage(
                        child: UploadFromDevicePage(),
                      ),
                    ),
                    GoRoute(
                      path: 'fromYoutube',
                      pageBuilder: (_, _) => const NoTransitionPage(
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
                  pageBuilder: (_, _) => const NoTransitionPage(
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
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
