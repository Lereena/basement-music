import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sizer/sizer.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app_config.dart';
import 'audio_player_handler.dart';
import 'bloc/settings_bloc/settings_bloc.dart';
import 'bloc_provider_wrapper.dart';
import 'firebase_options.dart';
import 'rest_client.dart';
import 'routing/router.dart';
import 'theme/custom_theme.dart';
import 'utils/json_response_converter.dart';

late final AudioPlayerHandler audioHandler;

Future<void> runBasement(AppConfig config) async {
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

  await initAudioHandler(config);

  final dio = Dio(BaseOptions(baseUrl: config.baseUrl))
    ..interceptors.addAll([
      JsonResponseConverter(),
      PrettyDioLogger(maxWidth: 120),
    ]);

  final restClient = RestClient(dio);

  runApp(BasementMusic(config: config, restClient: restClient));
}

final _router = AppRouter.router;

class BasementMusic extends StatelessWidget {
  final AppConfig config;
  final RestClient restClient;

  const BasementMusic({
    super.key,
    required this.config,
    required this.restClient,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProviderWrapper(
      appConfig: config,
      restClient: restClient,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return Sizer(
            builder: (context, orientation, deviceType) => MaterialApp.router(
              title: 'Basement',
              theme: CustomTheme.lightTheme,
              darkTheme: CustomTheme.darkTheme,
              themeMode: settingsState.themeMode,
              routeInformationProvider: _router.routeInformationProvider,
              routeInformationParser: _router.routeInformationParser,
              routerDelegate: _router.routerDelegate,
            ),
          );
        },
      ),
    );
  }
}
