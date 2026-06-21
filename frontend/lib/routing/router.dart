import 'dart:async';

import 'package:basement_music/bloc/auth_cubit/auth_cubit.dart';
import 'package:basement_music/pages/artist_edit_page.dart';
import 'package:basement_music/pages/artist_page.dart';
import 'package:basement_music/pages/edit_playlist/playlist_edit_page.dart';
import 'package:basement_music/pages/library/library_page.dart';
import 'package:basement_music/pages/login_page.dart';
import 'package:basement_music/pages/playlist_page.dart';
import 'package:basement_music/pages/register_code_page.dart';
import 'package:basement_music/pages/search_page.dart';
import 'package:basement_music/pages/settings_page.dart';
import 'package:basement_music/pages/home_page_wrapper.dart';
import 'package:basement_music/pages/upload/from_device/upload_from_device.dart';
import 'package:basement_music/pages/upload/from_youtube/extract_from_youtube.dart';
import 'package:basement_music/pages/upload/upload_page.dart';
import 'package:basement_music/routing/app_scaffold_shell.dart';
import 'package:basement_music/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          unauthenticated: () => loc == RouteName.login ? null : RouteName.login,
          pendingRegistration: () => loc == RouteName.registerCode ? null : RouteName.registerCode,
          authenticated: (_) => (loc == RouteName.login || loc == RouteName.registerCode) ? RouteName.tracks : null,
          error: (_) => loc == RouteName.login ? null : RouteName.login,
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: RouteName.login,
          pageBuilder: (_, _) => const MaterialPage(child: LoginPage()),
        ),
        GoRoute(
          path: RouteName.registerCode,
          pageBuilder: (_, _) => const MaterialPage(child: RegisterCodePage()),
        ),
        GoRoute(path: RouteName.initial, redirect: (_, _) => RouteName.tracks),
        StatefulShellRoute.indexedStack(
          builder: (_, _, navigationShell) => AppScaffoldShell(navigationShell: navigationShell),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              initialLocation: RouteName.tracks,
              routes: [
                GoRoute(
                  path: RouteName.tracks,
                  pageBuilder: (_, _) => const MaterialPage(child: HomePageWrapper()),
                ),
              ],
            ),
            StatefulShellBranch(
              initialLocation: RouteName.library,
              routes: [
                GoRoute(
                  path: RouteName.library,
                  pageBuilder: (_, _) => const MaterialPage(child: LibraryPage(initialTab: LibraryPageTab.favourites)),
                  routes: [
                    GoRoute(
                      path: "playlist/:id",
                      pageBuilder: (_, state) =>
                          MaterialPage(child: PlaylistPage(playlistId: state.pathParameters['id']!)),
                    ),
                    GoRoute(
                      path: "playlist/:id/edit",
                      pageBuilder: (_, state) =>
                          MaterialPage(child: PlaylistEditPage(playlistId: state.pathParameters['id']!)),
                    ),
                    GoRoute(
                      path: "artist/:id",
                      pageBuilder: (_, state) => MaterialPage(child: ArtistPage(artistId: state.pathParameters['id']!)),
                    ),
                    GoRoute(
                      path: "artist/:id/edit",
                      pageBuilder: (_, state) => MaterialPage(child: ArtistEditPage(artistId: state.pathParameters['id']!)),
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
                  pageBuilder: (_, _) => const MaterialPage(child: SearchPage()),
                ),
              ],
            ),
            StatefulShellBranch(
              initialLocation: RouteName.upload,
              routes: [
                GoRoute(
                  path: RouteName.upload,
                  pageBuilder: (_, _) => const MaterialPage(child: UploadPage()),
                  routes: [
                    GoRoute(
                      path: 'fromDevice',
                      pageBuilder: (_, _) => const MaterialPage(child: UploadFromDevicePage()),
                    ),
                    GoRoute(
                      path: 'fromYoutube',
                      pageBuilder: (_, _) => const MaterialPage(child: ExtractFromYoutubePage()),
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
                  pageBuilder: (_, _) => const MaterialPage(child: SettingsPage()),
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
