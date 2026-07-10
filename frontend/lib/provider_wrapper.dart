import 'package:basement_music/audio_player_handler.dart';
import 'package:basement_music/bloc/auth_cubit/auth_cubit.dart';
import 'package:basement_music/bloc/cacher_cubit/cacher_cubit.dart';
import 'package:basement_music/bloc/connectivity_status_cubit/connectivity_status_cubit.dart';
import 'package:basement_music/bloc/favourites_cubit/favourites_cubit.dart';
import 'package:basement_music/bloc/lyrics_cubit/lyrics_cubit.dart';
import 'package:basement_music/bloc/player_cubit/player_cubit.dart';
import 'package:basement_music/bloc/settings_cubit/settings_cubit.dart';
import 'package:basement_music/bloc/soulseek_login_cubit/soulseek_login_cubit.dart';
import 'package:basement_music/bloc/soulseek_settings_cubit/soulseek_settings_cubit.dart';
import 'package:basement_music/bloc/track_progress_cubit/track_progress_cubit.dart';
import 'package:basement_music/repositories/admin_repository.dart';
import 'package:basement_music/repositories/albums_repository.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/repositories/auth_repository.dart';
import 'package:basement_music/repositories/favourites_repository.dart';
import 'package:basement_music/repositories/lyrics_repository.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:basement_music/repositories/soulseek_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderWrapper extends StatelessWidget {
  const ProviderWrapper({
    super.key,
    required this.child,
    required this.audioHandler,
    required this.cacheRepository,
    required this.tracksRepository,
    required this.settingsRepository,
    required this.playlistsRepository,
    required this.connectivityStatusRepository,
    required this.artistsRepository,
    required this.albumsRepository,
    required this.authRepository,
    required this.favouritesRepository,
    required this.adminRepository,
    required this.soulseekRepository,
    required this.statsRepository,
    required this.lyricsRepository,
    required this.authCubit,
  });

  final Widget child;
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
  final LyricsRepository lyricsRepository;
  final AuthCubit authCubit;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: audioHandler),
        RepositoryProvider.value(value: cacheRepository),
        RepositoryProvider.value(value: tracksRepository),
        RepositoryProvider.value(value: settingsRepository),
        RepositoryProvider.value(value: playlistsRepository),
        RepositoryProvider.value(value: connectivityStatusRepository),
        RepositoryProvider.value(value: artistsRepository),
        RepositoryProvider.value(value: albumsRepository),
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: favouritesRepository),
        RepositoryProvider.value(value: adminRepository),
        RepositoryProvider.value(value: soulseekRepository),
        RepositoryProvider.value(value: statsRepository),
        RepositoryProvider.value(value: lyricsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authCubit),
          BlocProvider(create: (_) => SoulseekLoginCubit(soulseekRepository)..loadStatus()),
          BlocProvider(create: (_) => SoulseekSettingsCubit(soulseekRepository)..load()),
          BlocProvider(create: (_) => FavouritesCubit(favouritesRepository)..loadFavourites()),
          BlocProvider(create: (_) => ConnectivityStatusCubit(connectivityStatusRepository)),
          BlocProvider(create: (_) => TrackProgressCubit(audioHandler)),
          BlocProvider(create: (_) => LyricsCubit(lyricsRepository, tracksRepository)),
          BlocProvider(
            create: (_) =>
                CacherCubit(cacheRepository: cacheRepository, tracksRepository: tracksRepository)..initialize(),
          ),
          BlocProvider(create: (_) => SettingsCubit(settingsRepository)..retrieveSettings()),
          BlocProvider(
            create: (_) => PlayerCubit(
              audioHandler: audioHandler,
              tracksRepository: tracksRepository,
              lyricsRepository: lyricsRepository,
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}
