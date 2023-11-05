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

import 'api_service.dart';
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

  final apiService = ApiService(config.baseUrl);
  await initAudioHandler(apiService);

  final dio = Dio(BaseOptions(baseUrl: config.baseUrl))
    ..interceptors.addAll([
      JsonResponseConverter(),
      PrettyDioLogger(maxWidth: 180),
    ]);

  final restClient = RestClient(dio);

  runApp(BasementMusic(apiService: apiService, restClient: restClient));
}

final _router = AppRouter.router;

class BasementMusic extends StatelessWidget {
  final ApiService apiService;
  final RestClient restClient;

  const BasementMusic({
    super.key,
    required this.apiService,
    required this.restClient,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProviderWrapper(
      apiService: apiService,
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
