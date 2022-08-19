import 'package:basement_music/bloc/playlist_creation_bloc/playlist_creation_bloc.dart';
import 'package:basement_music/bloc/playlists_bloc/playlists_event.dart';
import 'package:basement_music/bloc/settings_bloc/bloc/settings_bloc.dart';
import 'package:basement_music/bloc/track_uploading_bloc/bloc/track_uploading_bloc.dart';
import 'package:basement_music/bloc/tracks_bloc/tracks_event.dart';
import 'package:basement_music/bloc/player_bloc/player_bloc.dart';
import 'package:basement_music/repositories/playlists_repository.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:basement_music/routes.dart';
import 'package:basement_music/theme/custom_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/playlists_bloc/playlists_bloc.dart';
import 'bloc/tracks_bloc/tracks_bloc.dart';
import 'models/playlist.dart';
import 'pages/home_page.dart';
import 'pages/playlist_page.dart';
import 'pages/settings_page.dart';

import 'pages/upload/upload_page.dart';
import 'platform_settings/platform_settings_stub.dart'
    if (dart.library.io) 'platform_settings/platform_settings_io.dart'
    if (dart.library.html) 'platform_settings/platform_settings_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
  );

  HydratedBlocOverrides.runZoned(
    () => runApp(BasementMusic()),
    storage: storage,
  );
}

class BasementMusic extends StatefulWidget {
  @override
  State<BasementMusic> createState() => _BasementMusicState();
}

class _BasementMusicState extends State<BasementMusic> {
  final _playlistsRepository = PlaylistsRepository();

  final _settingsBloc = SettingsBloc();
  final _tracksBloc = TracksBloc(TracksRepository());
  late final _playlistsBloc = PlaylistsBloc(_playlistsRepository);

  @override
  void initState() {
    super.initState();

    if (kIsWeb) preventDefault();

    _tracksBloc.add(TracksLoadEvent());
    _playlistsBloc.add(PlaylistsLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlayerBloc>(
          create: (context) => PlayerBloc(_settingsBloc),
        ),
        BlocProvider<TracksBloc>.value(
          value: _tracksBloc,
        ),
        BlocProvider<TrackUploadingBloc>(
          create: (context) => TrackUploadingBloc(),
        ),
        BlocProvider<PlaylistsBloc>.value(
          value: _playlistsBloc,
        ),
        BlocProvider<PlaylistCreationBloc>(
          create: (context) => PlaylistCreationBloc(
            _playlistsRepository,
            _playlistsBloc,
          ),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => _settingsBloc,
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Basement music',
            theme: CustomTheme.lightTheme,
            darkTheme: CustomTheme.darkTheme,
            themeMode: state.darkTheme ? ThemeMode.dark : ThemeMode.light,
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
          );
        },
      ),
    );
  }
}
