import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'audio_player_handler.dart';
import 'bloc/cacher_bloc/cacher_bloc.dart';
import 'bloc/connectivity_status_bloc/connectivity_status_cubit.dart';
import 'bloc/player_bloc/player_bloc.dart';
import 'bloc/settings_bloc/settings_bloc.dart';
import 'bloc/track_progress_cubit/track_progress_cubit.dart';
import 'repositories/repositories.dart';

class ProviderWrapper extends StatelessWidget {
  final Widget child;

  final AudioPlayerHandler audioHandler;
  final CacheRepository cacheRepository;
  final TracksRepository tracksRepository;
  final SettingsRepository settingsRepository;
  final PlaylistsRepository playlistsRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;

  const ProviderWrapper({
    super.key,
    required this.child,
    required this.audioHandler,
    required this.cacheRepository,
    required this.tracksRepository,
    required this.settingsRepository,
    required this.playlistsRepository,
    required this.connectivityStatusRepository,
  });

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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                ConnectivityStatusCubit(connectivityStatusRepository),
          ),
          BlocProvider(create: (_) => TrackProgressCubit(audioHandler)),
          BlocProvider(
            create: (_) => CacherBloc(
              cacheRepository: cacheRepository,
              tracksRepository: tracksRepository,
            )..add(CacherValidateStarted()),
          ),
          BlocProvider(
            create: (_) =>
                SettingsBloc(settingsRepository)..add(RetrieveSettings()),
          ),
          BlocProvider(
            create: (_) => PlayerBloc(
              audioHandler: audioHandler,
              tracksRepository: tracksRepository,
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}
