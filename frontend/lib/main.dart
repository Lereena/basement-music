import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_strategy/url_strategy.dart';

import 'api_service.dart';
import 'audio_player_handler.dart';
import 'bloc/settings_bloc/settings_bloc.dart';
import 'bloc_provider_wrapper.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'routes.dart';
import 'theme/custom_theme.dart';

late final AudioPlayerHandler audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  setPathUrlStrategy();

  final apiService = ApiService();
  initAudioHandler(apiService);

  runApp(BasementMusic(apiService: apiService));
}

class BasementMusic extends StatelessWidget {
  final ApiService apiService;

  const BasementMusic({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return BlocProviderWrapper(
      apiService: apiService,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return Sizer(
            builder: (context, orientation, deviceType) => MaterialApp(
              title: 'Basement',
              theme: CustomTheme.lightTheme,
              darkTheme: CustomTheme.darkTheme,
              themeMode:
                  settingsState.darkTheme ? ThemeMode.dark : ThemeMode.light,
              initialRoute: NavigationRoute.initial.name,
              onGenerateRoute: onGenerateRoute,
              home: const Material(child: HomePage()),
            ),
          );
        },
      ),
    );
  }
}
