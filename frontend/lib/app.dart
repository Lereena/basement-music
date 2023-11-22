import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sizer/sizer.dart';
import 'package:url_strategy/url_strategy.dart';

import 'adapters/theme_mode_adapter.dart';
import 'app_config.dart';
import 'audio_player_handler.dart';
import 'bloc/settings_bloc/settings_bloc.dart';
import 'firebase_options.dart';
import 'provider_wrapper.dart';
import 'repositories/repositories.dart';
import 'rest_client.dart';
import 'routing/router.dart';
import 'shortcuts_wrapper.dart';
import 'theme/custom_theme.dart';
import 'utils/json_response_converter.dart';

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

  final dio = Dio(BaseOptions(baseUrl: config.baseUrl))
    ..interceptors.addAll([
      JsonResponseConverter(),
      PrettyDioLogger(maxWidth: 120),
    ]);

  final restClient = RestClient(dio);

  await Hive.initFlutter();
  Hive.registerAdapter(ThemeModeAdapter());

  final cacheBox = await Hive.openBox<String>('tracks_cache');
  final settingsBox = await Hive.openBox<Object>('settings');

  final settingsRepository = SettingsRepository(settingsBox);
  final connectivityStatusRepository = ConnectivityStatusRepository();
  final cacheRepository = CacheRepository(config, cacheBox);

  final audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(
      appConfig: config,
      settingsRepository: settingsRepository,
      connectivityStatusRepository: connectivityStatusRepository,
      cacheRepository: cacheRepository,
    ),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.lereena.basement.channel.audio',
      androidNotificationChannelName: 'Basement',
      androidNotificationOngoing: true,
    ),
  );

  runApp(
    BasementMusic(
      audioHandler: audioHandler,
      cacheRepository: cacheRepository,
      tracksRepository: TracksRepository(restClient),
      settingsRepository: settingsRepository,
      playlistsRepository: PlaylistsRepository(restClient),
      connectivityStatusRepository: connectivityStatusRepository,
    ),
  );
}

final _router = AppRouter.router;

class BasementMusic extends StatelessWidget {
  final AudioPlayerHandler audioHandler;
  final CacheRepository cacheRepository;
  final TracksRepository tracksRepository;
  final SettingsRepository settingsRepository;
  final PlaylistsRepository playlistsRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;

  const BasementMusic({
    super.key,
    required this.audioHandler,
    required this.cacheRepository,
    required this.tracksRepository,
    required this.settingsRepository,
    required this.playlistsRepository,
    required this.connectivityStatusRepository,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderWrapper(
      tracksRepository: tracksRepository,
      playlistsRepository: playlistsRepository,
      connectivityStatusRepository: connectivityStatusRepository,
      audioHandler: audioHandler,
      cacheRepository: cacheRepository,
      settingsRepository: settingsRepository,
      child: ShortcutsWrapper(
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (_, settingsState) {
            return Sizer(
              builder: (_, __, ___) => MaterialApp.router(
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
      ),
    );
  }
}
