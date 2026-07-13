import 'dart:async';

import 'package:basement_music/audio_player_handler.dart';
import 'package:basement_music/bloc/auth_cubit/auth_cubit.dart';
import 'package:basement_music/bloc/timing_editor_cubit/timing_editor_cubit.dart';
import 'package:basement_music/pages/album_edit_page.dart';
import 'package:basement_music/pages/album_page.dart';
import 'package:basement_music/pages/artist_edit_page.dart';
import 'package:basement_music/pages/artist_page.dart';
import 'package:basement_music/pages/artist_tracks_page.dart';
import 'package:basement_music/pages/edit_playlist/playlist_edit_page.dart';
import 'package:basement_music/pages/home_page_wrapper.dart';
import 'package:basement_music/pages/library/library_page.dart';
import 'package:basement_music/pages/login_page.dart';
import 'package:basement_music/pages/lyrics_timing_page.dart';
import 'package:basement_music/pages/playlist_page.dart';
import 'package:basement_music/pages/register_code_page.dart';
import 'package:basement_music/pages/search_page.dart';
import 'package:basement_music/pages/settings_page.dart';
import 'package:basement_music/pages/upload/from_device/upload_from_device.dart';
import 'package:basement_music/pages/upload/from_soulseek/soulseek_search_page.dart';
import 'package:basement_music/pages/upload/from_youtube/extract_from_youtube.dart';
import 'package:basement_music/pages/upload/upload_page.dart';
import 'package:basement_music/repositories/lyrics_repository.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:basement_music/routing/app_scaffold_shell.dart';
import 'package:basement_music/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        GoRoute(
          path: '/track/:id/lyricsTiming',
          parentNavigatorKey: _rootNavigatorKey,
          // Direct navigation (web refresh) before tracks load: no track to
          // edit against, fall back to the tracks page.
          redirect: (context, state) {
            final id = state.pathParameters['id'];
            final known = context.read<TracksRepository>().items.any((track) => track.id == id);
            return known ? null : RouteName.tracks;
          },
          pageBuilder: (context, state) {
            final track = context.read<TracksRepository>().items.firstWhere(
              (track) => track.id == state.pathParameters['id'],
            );
            final source = state.uri.queryParameters['source'] == LyricsSource.file.name
                ? LyricsSource.file
                : LyricsSource.server;

            return MaterialPage(
              key: ValueKey(state.uri.toString()),
              child: BlocProvider(
                create: (context) => TimingEditorCubit(
                  context.read<LyricsRepository>(),
                  context.read<TracksRepository>(),
                  context.read<AudioPlayerHandler>(),
                  track: track,
                  source: source,
                )..init(),
                child: const LyricsTimingPage(),
              ),
            );
          },
        ),
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
                      pageBuilder: (_, state) => MaterialPage(
                        key: ValueKey(state.uri.toString()),
                        child: PlaylistPage(playlistId: state.pathParameters['id']!),
                      ),
                    ),
                    GoRoute(
                      path: "playlist/:id/edit",
                      pageBuilder: (_, state) => MaterialPage(
                        key: ValueKey(state.uri.toString()),
                        child: PlaylistEditPage(playlistId: state.pathParameters['id']!),
                      ),
                    ),
                    GoRoute(
                      path: "artist/:id",
                      pageBuilder: (_, state) => MaterialPage(
                        key: ValueKey(state.uri.toString()),
                        child: ArtistPage(artistId: state.pathParameters['id']!),
                      ),
                    ),
                    GoRoute(
                      path: "artist/:id/tracks",
                      pageBuilder: (_, state) => MaterialPage(
                        key: ValueKey(state.uri.toString()),
                        child: ArtistTracksPage(artistId: state.pathParameters['id']!),
                      ),
                    ),
                    GoRoute(
                      path: "artist/:id/edit",
                      pageBuilder: (_, state) => MaterialPage(
                        key: ValueKey(state.uri.toString()),
                        child: ArtistEditPage(artistId: state.pathParameters['id']!),
                      ),
                    ),
                    GoRoute(
                      path: "album/:id",
                      pageBuilder: (_, state) => MaterialPage(
                        key: ValueKey(state.uri.toString()),
                        child: AlbumPage(albumId: state.pathParameters['id']!),
                      ),
                    ),
                    GoRoute(
                      path: "album/:id/edit",
                      pageBuilder: (_, state) => MaterialPage(
                        key: ValueKey(state.uri.toString()),
                        child: AlbumEditPage(
                          albumId: state.pathParameters['id']!,
                          isNew: state.uri.queryParameters['new'] == '1',
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
                    GoRoute(
                      path: 'fromSoulseek',
                      pageBuilder: (_, _) => const MaterialPage(child: SoulseekSearchPage()),
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
