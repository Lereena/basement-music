import 'package:basement_music/bloc/playlist_creation_bloc/playlist_creation_bloc.dart';
import 'package:basement_music/bloc/playlists_bloc/playlists_event.dart';
import 'package:basement_music/bloc/tracks_bloc/tracks_event.dart';
import 'package:basement_music/bloc/player_bloc/player_bloc.dart';
import 'package:basement_music/repositories/playlists_repository.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:basement_music/routes.dart';
import 'package:basement_music/theme/config.dart';
import 'package:basement_music/theme/custom_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/playlists_bloc/playlists_bloc.dart';
import 'bloc/tracks_bloc/tracks_bloc.dart';
import 'models/playlist.dart';
import 'pages/home_page.dart';
import 'pages/playlist_page.dart';
import 'pages/settings_page.dart';

import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';

import 'pages/upload/upload_page.dart';
import 'platform_settings/platform_settings_stub.dart'
    if (dart.library.io) 'platform_settings/platform_settings_io.dart'
    if (dart.library.html) 'platform_settings/platform_settings_web.dart';

void main() {
  runApp(BasementMusic());
}

class BasementMusic extends StatefulWidget {
  @override
  State<BasementMusic> createState() => _BasementMusicState();
}

class _BasementMusicState extends State<BasementMusic> {
  final _playlistsRepository = PlaylistsRepository();

  final _tracksBloc = TracksBloc(TracksRepository());
  late final _playlistsBloc = PlaylistsBloc(_playlistsRepository);

  @override
  void initState() {
    super.initState();

    currentTheme.initTheme();
    currentTheme.addListener(() => setState(() {}));

    if (kIsWeb) preventDefault();

    _tracksBloc.add(TracksLoadEvent());
    _playlistsBloc.add(PlaylistsLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlayerBloc>(
          create: (context) => PlayerBloc(),
        ),
        BlocProvider<TracksBloc>.value(
          value: _tracksBloc,
        ),
        BlocProvider<PlaylistsBloc>.value(
          value: _playlistsBloc,
        ),
        BlocProvider<PlaylistCreationBloc>(
          create: (context) => PlaylistCreationBloc(
            _playlistsRepository,
            _playlistsBloc,
          ),
        )
      ],
      child: MaterialApp(
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
            final playlist = (settings.arguments as Map<String, Playlist>)['playlist']!;
            return MaterialPageRoute(builder: (context) => PlaylistPage(playlist: playlist));
          }
          return null;
        },
        home: ContextMenuOverlay(
          child: MyHomePage(title: 'Basement music'),
        ),
      ),
    );
  }
}
