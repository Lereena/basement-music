import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'api_service.dart';
import 'bloc/add_to_playlist_bloc/add_to_playlist_bloc.dart';
import 'bloc/cacher_bloc/cacher_bloc.dart';
import 'bloc/connectivity_status_bloc/connectivity_status_cubit.dart';
import 'bloc/edit_track_bloc/edit_track_bloc.dart';
import 'bloc/home_content_cubit/home_content_cubit.dart';
import 'bloc/local_track_uploading_bloc/local_track_uploading_bloc.dart';
import 'bloc/player_bloc/player_bloc.dart';
import 'bloc/playlist_bloc/playlist_bloc.dart';
import 'bloc/playlist_creation_bloc/playlist_creation_bloc.dart';
import 'bloc/playlists_bloc/playlists_bloc.dart';
import 'bloc/remove_from_playlist_bloc/remove_from_playlist_cubit.dart';
import 'bloc/settings_bloc/settings_bloc.dart';
import 'bloc/track_progress_cubit/track_progress_cubit.dart';
import 'bloc/track_uploading_bloc/track_uploading_bloc.dart';
import 'bloc/tracks_bloc/tracks_bloc.dart';
import 'bloc/trackst_search_cubit/tracks_search_cubit.dart';
import 'repositories/playlists_repository.dart';
import 'repositories/tracks_repository.dart';
import 'shortcuts_wrapper.dart';

class BlocProviderWrapper extends StatefulWidget {
  final Widget child;
  final ApiService apiService;

  const BlocProviderWrapper({
    super.key,
    required this.apiService,
    required this.child,
  });

  @override
  State<BlocProviderWrapper> createState() => _BlocProviderWrapperState();
}

class _BlocProviderWrapperState extends State<BlocProviderWrapper> {
  late final _tracksRepository = TracksRepository(widget.apiService);
  late final _playlistsRepository = PlaylistsRepository(widget.apiService);

  late final _settingsBloc = SettingsBloc(widget.apiService);
  late final _tracksBloc = TracksBloc(_tracksRepository);
  late final _playlistsBloc = PlaylistsBloc(_playlistsRepository);
  late final _cacherBloc = CacherBloc(widget.apiService);
  late final _connectivityStatusCubit = ConnectivityStatusCubit(
    tracksBloc: _tracksBloc,
    playlistsBloc: _playlistsBloc,
  );
  late final _playerBloc = PlayerBloc(
    tracksRepository: _tracksRepository,
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
        BlocProvider<TrackUploadingBloc>(
          create: (_) => TrackUploadingBloc(_tracksRepository),
        ),
        BlocProvider<LocalTrackUploadingBloc>(
          create: (_) => LocalTrackUploadingBloc(_tracksRepository),
        ),
        BlocProvider<PlaylistsBloc>.value(
          value: _playlistsBloc,
        ),
        BlocProvider<PlaylistBloc>(
          create: (_) => PlaylistBloc(_playlistsRepository),
        ),
        BlocProvider<PlaylistCreationBloc>(
          create: (_) => PlaylistCreationBloc(
            _playlistsRepository,
            _playlistsBloc,
          ),
        ),
        BlocProvider<TracksSearchCubit>(
          create: (_) => TracksSearchCubit(
            tracksRepository: _tracksRepository,
            playlistsBloc: _playlistsBloc,
            cacherBloc: _cacherBloc,
            connectivityStatusCubit: _connectivityStatusCubit,
          ),
        ),
        BlocProvider<SettingsBloc>.value(
          value: _settingsBloc,
        ),
        BlocProvider<AddToPlaylistBloc>(
          create: (_) => AddToPlaylistBloc(
            _tracksRepository,
            _playlistsRepository,
          ),
        ),
        BlocProvider<RemoveFromPlaylistBloc>(
          create: (_) => RemoveFromPlaylistBloc(
            _tracksRepository,
            _playlistsRepository,
          ),
        ),
        BlocProvider<CacherBloc>.value(
          value: _cacherBloc,
        ),
        BlocProvider<TrackProgressCubit>(
          create: (_) => TrackProgressCubit(_playerBloc),
        ),
        BlocProvider<EditTrackBloc>(
          create: (_) => EditTrackBloc(_tracksRepository),
        ),
        BlocProvider<HomeContentCubit>(
          create: (_) => HomeContentCubit(),
        ),
      ],
      child: ShortcutsWrapper(
        playerBloc: _playerBloc,
        child: widget.child,
      ),
    );
  }
}
