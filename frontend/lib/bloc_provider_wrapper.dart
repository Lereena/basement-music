import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_config.dart';
import 'bloc/cacher_bloc/cacher_bloc.dart';
import 'bloc/player_bloc/player_bloc.dart';
import 'bloc/playlists_bloc/playlists_bloc.dart';
import 'bloc/playlists_bloc/playlists_event.dart';
import 'bloc/settings_bloc/settings_bloc.dart';
import 'bloc/track_progress_cubit/track_progress_cubit.dart';
import 'bloc/trackst_search_cubit/tracks_search_cubit.dart';
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

  late final _playlistsBloc = PlaylistsBloc(
    playlistsRepository: context.read<PlaylistsRepository>(),
    connectivityStatusRepository: context.read<ConnectivityStatusRepository>(),
  )..add(PlaylistsLoadEvent());

  late final _cacherBloc = CacherBloc(widget.appConfig);

  late final _playerBloc = PlayerBloc(
    tracksRepository: context.read<TracksRepository>(),
    settingsBloc: _settingsBloc,
    cacherBloc: _cacherBloc,
    connectivityStatusRepository: context.read<ConnectivityStatusRepository>(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlayerBloc>(
          create: (_) => _playerBloc,
        ),
        BlocProvider<PlaylistsBloc>.value(
          value: _playlistsBloc,
        ),
        BlocProvider<TracksSearchCubit>(
          create: (_) => TracksSearchCubit(
            tracksRepository: context.read<TracksRepository>(),
            playlistsBloc: _playlistsBloc,
            cacherBloc: _cacherBloc,
            connectivityStatusRepository:
                context.read<ConnectivityStatusRepository>(),
          ),
        ),
        BlocProvider<SettingsBloc>.value(
          value: _settingsBloc,
        ),
        BlocProvider<CacherBloc>.value(
          value: _cacherBloc,
        ),
        BlocProvider<TrackProgressCubit>(
          create: (_) => TrackProgressCubit(_playerBloc),
        ),
      ],
      child: ShortcutsWrapper(
        playerBloc: _playerBloc,
        child: widget.child,
      ),
    );
  }
}
