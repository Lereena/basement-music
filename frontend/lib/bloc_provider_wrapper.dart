import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_config.dart';
import 'bloc/cacher_bloc/cacher_bloc.dart';
import 'bloc/connectivity_status_bloc/connectivity_status_cubit.dart';
import 'bloc/edit_track_bloc/edit_track_bloc.dart';
import 'bloc/player_bloc/player_bloc.dart';
import 'bloc/playlist_bloc/playlist_bloc.dart';
import 'bloc/playlist_creation_bloc/playlist_creation_bloc.dart';
import 'bloc/playlist_edit_bloc/playlist_edit_bloc.dart';
import 'bloc/playlists_bloc/playlists_bloc.dart';
import 'bloc/remove_from_playlist_bloc/remove_from_playlist_cubit.dart';
import 'bloc/settings_bloc/settings_bloc.dart';
import 'bloc/track_progress_cubit/track_progress_cubit.dart';
import 'bloc/tracks_bloc/tracks_bloc.dart';
import 'bloc/trackst_search_cubit/tracks_search_cubit.dart';
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
  late final _tracksBloc = TracksBloc(context.read<TracksRepository>());
  late final _playlistBloc = PlaylistBloc(context.read<PlaylistsRepository>());
  late final _playlistsBloc =
      PlaylistsBloc(context.read<PlaylistsRepository>(), _playlistBloc);
  late final _cacherBloc = CacherBloc(widget.appConfig);
  late final _connectivityStatusCubit = ConnectivityStatusCubit(
    tracksBloc: _tracksBloc,
    playlistsBloc: _playlistsBloc,
  );
  late final _playerBloc = PlayerBloc(
    tracksRepository: context.read<TracksRepository>(),
    settingsBloc: _settingsBloc,
    cacherBloc: _cacherBloc,
    connectivityStatusCubit: _connectivityStatusCubit,
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityStatusCubit>.value(
          value: _connectivityStatusCubit,
        ),
        BlocProvider<PlayerBloc>(
          create: (_) => _playerBloc,
        ),
        BlocProvider<TracksBloc>.value(
          value: _tracksBloc,
        ),
        BlocProvider<PlaylistsBloc>.value(
          value: _playlistsBloc,
        ),
        BlocProvider<PlaylistBloc>.value(
          value: _playlistBloc,
        ),
        BlocProvider<PlaylistCreationBloc>(
          create: (_) => PlaylistCreationBloc(
            context.read<PlaylistsRepository>(),
            _playlistsBloc,
          ),
        ),
        BlocProvider<PlaylistEditBloc>(
          create: (_) => PlaylistEditBloc(
            context.read<PlaylistsRepository>(),
            _playlistsBloc,
          ),
        ),
        BlocProvider<TracksSearchCubit>(
          create: (_) => TracksSearchCubit(
            tracksRepository: context.read<TracksRepository>(),
            playlistsBloc: _playlistsBloc,
            cacherBloc: _cacherBloc,
            connectivityStatusCubit: _connectivityStatusCubit,
          ),
        ),
        BlocProvider<SettingsBloc>.value(
          value: _settingsBloc,
        ),
        BlocProvider<RemoveFromPlaylistBloc>(
          create: (_) => RemoveFromPlaylistBloc(
            context.read<TracksRepository>(),
            context.read<PlaylistsRepository>(),
          ),
        ),
        BlocProvider<CacherBloc>.value(
          value: _cacherBloc,
        ),
        BlocProvider<TrackProgressCubit>(
          create: (_) => TrackProgressCubit(_playerBloc),
        ),
        BlocProvider<EditTrackBloc>(
          create: (_) => EditTrackBloc(context.read<TracksRepository>()),
        ),
      ],
      child: ShortcutsWrapper(
        playerBloc: _playerBloc,
        child: widget.child,
      ),
    );
  }
}
