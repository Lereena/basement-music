import 'package:audio_service/audio_service.dart';
import 'package:basement_music/adapters/theme_mode_adapter.dart';
import 'package:basement_music/app_config.dart';
import 'package:basement_music/audio_player_handler.dart';
import 'package:basement_music/bloc/auth_cubit/auth_cubit.dart';
import 'package:basement_music/bloc/settings_cubit/settings_cubit.dart';
import 'package:basement_music/firebase_options.dart';
import 'package:basement_music/provider_wrapper.dart';
import 'package:basement_music/repositories/admin_repository.dart';
import 'package:basement_music/repositories/albums_repository.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/repositories/auth_repository.dart';
import 'package:basement_music/repositories/favourites_repository.dart';
import 'package:basement_music/repositories/lyrics_repository.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:basement_music/repositories/soulseek_repository.dart';
import 'package:basement_music/rest_client.dart';
import 'package:basement_music/routing/router.dart';
import 'package:basement_music/services/listen_tracker.dart';
import 'package:basement_music/shortcuts_wrapper.dart';
import 'package:basement_music/theme/custom_theme.dart';
import 'package:basement_music/utils/auth_interceptor.dart';
import 'package:basement_music/utils/json_response_converter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sizer/sizer.dart';

Future<void> runBasement(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  // On mobile, Firebase auto-initializes the default app natively from
  // GoogleService-Info.plist / google-services.json. Passing options here would
  // try to create [DEFAULT] again and throw `duplicate-app`. Web has no native
  // init, so it needs the explicit options.
  if (kIsWeb) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } else {
    await Firebase.initializeApp();
  }
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  usePathUrlStrategy();

  final authInterceptor = AuthInterceptor();
  final dio = Dio(BaseOptions(baseUrl: config.baseUrl))
    ..interceptors.addAll([
      authInterceptor,
      JsonResponseConverter(),
      PrettyDioLogger(maxWidth: 120, responseBody: false),
    ]);
  authInterceptor.attach(dio);

  final restClient = RestClient(dio);

  await Hive.initFlutter();
  Hive.registerAdapter(ThemeModeAdapter());

  final cacheBox = await Hive.openBox<String>('tracks_cache');
  final settingsBox = await Hive.openBox<Object>('settings');
  final tracksPersistenceBox = await Hive.openBox<String>('tracks_persistent');
  final playlistsPersistenceBox = await Hive.openBox<String>('playlists_persistent');
  final statsBox = await Hive.openBox<String>('listen_stats');

  final settingsRepository = SettingsRepository(settingsBox);
  final connectivityStatusRepository = ConnectivityStatusRepository();
  final cacheRepository = CacheRepository(config, cacheBox);
  final authRepository = AuthRepository(restClient);
  final favouritesRepository = FavouritesRepository(restClient, baseUrl: config.baseUrl);
  final adminRepository = AdminRepository(restClient);
  final soulseekRepository = SoulseekRepository(restClient);
  final statsRepository = StatsRepository(restClient, connectivityStatusRepository, persistenceBox: statsBox);
  final lyricsRepository = LyricsRepository(restClient, dio);

  final authCubit = AuthCubit(authRepository, statsRepository);
  final router = AppRouter.createRouter(authCubit);

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

  final artistsRepository = ArtistsRepository(restClient, baseUrl: config.baseUrl);
  final listenTracker = ListenTracker(audioHandler, statsRepository);

  runApp(
    BasementMusic(
      audioHandler: audioHandler,
      cacheRepository: cacheRepository,
      tracksRepository: TracksRepository(restClient, persistenceBox: tracksPersistenceBox),
      settingsRepository: settingsRepository,
      playlistsRepository: PlaylistsRepository(
        restClient,
        persistenceBox: playlistsPersistenceBox,
        baseUrl: config.baseUrl,
      ),
      artistsRepository: artistsRepository,
      albumsRepository: AlbumsRepository(restClient, baseUrl: config.baseUrl, artistsRepository: artistsRepository),
      connectivityStatusRepository: connectivityStatusRepository,
      authRepository: authRepository,
      favouritesRepository: favouritesRepository,
      adminRepository: adminRepository,
      soulseekRepository: soulseekRepository,
      statsRepository: statsRepository,
      listenTracker: listenTracker,
      lyricsRepository: lyricsRepository,
      authCubit: authCubit,
      router: router,
    ),
  );
}

class BasementMusic extends StatelessWidget {
  final AudioPlayerHandler audioHandler;
  final CacheRepository cacheRepository;
  final TracksRepository tracksRepository;
  final SettingsRepository settingsRepository;
  final PlaylistsRepository playlistsRepository;
  final ArtistsRepository artistsRepository;
  final AlbumsRepository albumsRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;
  final AuthRepository authRepository;
  final FavouritesRepository favouritesRepository;
  final AdminRepository adminRepository;
  final SoulseekRepository soulseekRepository;
  final StatsRepository statsRepository;
  final ListenTracker listenTracker;
  final LyricsRepository lyricsRepository;
  final AuthCubit authCubit;
  final GoRouter router;

  const BasementMusic({
    super.key,
    required this.audioHandler,
    required this.cacheRepository,
    required this.tracksRepository,
    required this.settingsRepository,
    required this.playlistsRepository,
    required this.artistsRepository,
    required this.albumsRepository,
    required this.connectivityStatusRepository,
    required this.authRepository,
    required this.favouritesRepository,
    required this.adminRepository,
    required this.soulseekRepository,
    required this.statsRepository,
    required this.listenTracker,
    required this.lyricsRepository,
    required this.authCubit,
    required this.router,
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
      artistsRepository: artistsRepository,
      albumsRepository: albumsRepository,
      authRepository: authRepository,
      favouritesRepository: favouritesRepository,
      adminRepository: adminRepository,
      soulseekRepository: soulseekRepository,
      statsRepository: statsRepository,
      lyricsRepository: lyricsRepository,
      authCubit: authCubit,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (_, settingsState) => Sizer(
          builder: (_, _, _) => MaterialApp.router(
            title: 'Basement',
            theme: CustomTheme.lightTheme,
            darkTheme: CustomTheme.darkTheme,
            themeMode: settingsState.themeMode,
            routerConfig: router,
            builder: (context, child) => ShortcutsWrapper(child: child ?? const SizedBox.shrink()),
          ),
        ),
      ),
    );
  }
}
