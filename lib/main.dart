import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/settings_bloc/settings_bloc.dart';
import 'bloc_provider_wrapper.dart';
import 'models/playlist.dart';
import 'pages/home_page.dart';
import 'pages/playlist_page.dart';
import 'pages/settings_page.dart';
import 'pages/upload/upload_page.dart';
import 'platform_settings/platform_settings_stub.dart'
    if (dart.library.html) 'platform_settings/platform_settings_web.dart'
    if (dart.library.io) 'platform_settings/platform_settings_io.dart';
import 'routes.dart';
import 'theme/custom_theme.dart';

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
  @override
  void initState() {
    super.initState();

    if (kIsWeb) preventDefault();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderWrapper(
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            title: 'Basement music',
            theme: CustomTheme.lightTheme,
            darkTheme: CustomTheme.darkTheme,
            themeMode: settingsState.darkTheme ? ThemeMode.dark : ThemeMode.light,
            initialRoute: NavigationRoute.initial.name,
            routes: {
              NavigationRoute.settings.name: (context) => const SettingsPage(),
              NavigationRoute.upload.name: (context) => const UploadPage(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == NavigationRoute.playlist.name) {
                final playlist = (settings.arguments! as Map<String, Playlist>)['playlist']!;
                return MaterialPageRoute(builder: (context) => PlaylistPage(playlist: playlist));
              }
              return null;
            },
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}
