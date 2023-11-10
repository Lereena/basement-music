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
import 'bloc/cacher_bloc/cacher_bloc.dart';
import 'bloc/connectivity_status_bloc/connectivity_status_cubit.dart';
import 'bloc/settings_bloc/settings_bloc.dart';
import 'bloc/track_progress_cubit/track_progress_cubit.dart';
import 'bloc_provider_wrapper.dart';
import 'firebase_options.dart';
import 'repositories/cache_repository.dart';
import 'repositories/connectivity_status_repository.dart';
import 'repositories/playlists_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/tracks_repository.dart';
import 'rest_client.dart';
import 'routing/router.dart';
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

  final audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(config),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.lereena.basement-music.channel.audio',
      androidNotificationChannelName: 'Basement music',
      androidNotificationOngoing: true,
    ),
  );

  final dio = Dio(BaseOptions(baseUrl: config.baseUrl))
    ..interceptors.addAll([
      JsonResponseConverter(),
      PrettyDioLogger(maxWidth: 120),
    ]);

  final restClient = RestClient(dio);

  final tracksRepository = TracksRepository(restClient);
  final playlistsRepository = PlaylistsRepository(restClient);
  final connectivityStatusRepository = ConnectivityStatusRepository();

  await Hive.initFlutter();
  Hive.registerAdapter(ThemeModeAdapter());

  final cacheBox = await Hive.openBox<String>('tracks_cache');
  final cacheRepository = CacheRepository(config, cacheBox);

  final settingsBox = await Hive.openBox<Object>('settings');
  final settingsRepository = SettingsRepository(settingsBox);

  runApp(
    BasementMusic(
      config: config,
      audioHandler: audioHandler,
      tracksRepository: tracksRepository,
      playlistsRepository: playlistsRepository,
      connectivityStatusRepository: connectivityStatusRepository,
      cacheRepository: cacheRepository,
      settingsRepository: settingsRepository,
    ),
  );
}

final _router = AppRouter.router;

class BasementMusic extends StatelessWidget {
  final AppConfig config;
  final AudioPlayerHandler audioHandler;
  final TracksRepository tracksRepository;
  final PlaylistsRepository playlistsRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;
  final CacheRepository cacheRepository;
  final SettingsRepository settingsRepository;

  const BasementMusic({
    super.key,
    required this.config,
    required this.audioHandler,
    required this.tracksRepository,
    required this.playlistsRepository,
    required this.connectivityStatusRepository,
    required this.cacheRepository,
    required this.settingsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: tracksRepository),
        RepositoryProvider.value(value: playlistsRepository),
        RepositoryProvider.value(value: connectivityStatusRepository),
        RepositoryProvider.value(value: audioHandler),
        RepositoryProvider.value(value: cacheRepository),
        RepositoryProvider.value(value: settingsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                ConnectivityStatusCubit(connectivityStatusRepository),
          ),
          BlocProvider(create: (_) => TrackProgressCubit(audioHandler)),
          BlocProvider(create: (_) => CacherBloc(cacheRepository)),
          BlocProvider(
            create: (_) =>
                SettingsBloc(settingsRepository)..add(RetrieveSettings()),
          ),
        ],
        child: BlocProviderWrapper(
          appConfig: config,
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingsState) {
              return Sizer(
                builder: (context, orientation, deviceType) =>
                    MaterialApp.router(
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
      ),
    );
  }
}
