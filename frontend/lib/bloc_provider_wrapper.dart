import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_config.dart';
import 'audio_player_handler.dart';
import 'bloc/player_bloc/player_bloc.dart';
import 'bloc/settings_bloc/settings_bloc.dart';
import 'bloc/trackst_search_cubit/tracks_search_cubit.dart';
import 'repositories/cache_repository.dart';
import 'repositories/connectivity_status_repository.dart';
import 'repositories/playlists_repository.dart';
import 'repositories/tracks_repository.dart';
import 'shortcuts_wrapper.dart';

class BlocProviderWrapper extends StatefulWidget {
  final Widget child;
  final AppConfig appConfig;

  const BlocProviderWrapper({
    super.key,
    required this.appConfig,
    required this.child,
  });

  @override
  State<BlocProviderWrapper> createState() => _BlocProviderWrapperState();
}

class _BlocProviderWrapperState extends State<BlocProviderWrapper> {
  late final _settingsBloc = SettingsBloc();

  late final _playerBloc = PlayerBloc(
    audioHandler: context.read<AudioPlayerHandler>(),
    tracksRepository: context.read<TracksRepository>(),
    settingsBloc: _settingsBloc,
    cacheRepository: context.read<CacheRepository>(),
    connectivityStatusRepository: context.read<ConnectivityStatusRepository>(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlayerBloc>(
          create: (_) => _playerBloc,
        ),
        BlocProvider<TracksSearchCubit>(
          create: (_) => TracksSearchCubit(
            tracksRepository: context.read<TracksRepository>(),
            playlistsRepository: context.read<PlaylistsRepository>(),
            connectivityStatusRepository:
                context.read<ConnectivityStatusRepository>(),
          ),
        ),
        BlocProvider<SettingsBloc>.value(
          value: _settingsBloc,
        ),
      ],
      child: ShortcutsWrapper(
        playerBloc: _playerBloc,
        child: widget.child,
      ),
    );
  }
}
