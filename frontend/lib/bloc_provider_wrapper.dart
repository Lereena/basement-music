import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'api_service.dart';
import 'bloc/add_to_playlist_bloc/add_to_playlist_bloc.dart';
import 'bloc/cacher_bloc/bloc/cacher_bloc.dart';
import 'bloc/edit_track_bloc/edit_track_bloc.dart';
import 'bloc/home_content_cubit/home_content_cubit.dart';
import 'bloc/navigation_cubit/navigation_cubit.dart';
import 'bloc/player_bloc/player_bloc.dart';
import 'bloc/playlist_creation_bloc/playlist_creation_bloc.dart';
import 'bloc/playlists_bloc/playlists_bloc.dart';
import 'bloc/playlists_bloc/playlists_event.dart';
import 'bloc/remove_from_playlist_bloc/remove_from_playlist_cubit.dart';
import 'bloc/settings_bloc/settings_bloc.dart';
import 'bloc/side_navigation_bloc/side_navigation_cubit.dart';
import 'bloc/track_progress_cubit/track_progress_cubit.dart';
import 'bloc/track_uploading_bloc/track_uploading_bloc.dart';
import 'bloc/tracks_bloc/tracks_bloc.dart';
import 'bloc/tracks_bloc/tracks_event.dart';
import 'bloc/trackst_search_cubit/tracks_search_cubit.dart';
import 'repositories/playlists_repository.dart';
import 'repositories/tracks_repository.dart';
import 'shortcuts_wrapper.dart';

class BlocProviderWrapper extends StatefulWidget {
  final Widget child;

  const BlocProviderWrapper({super.key, required this.child});

  @override
  State<BlocProviderWrapper> createState() => _BlocProviderWrapperState();
}

class _BlocProviderWrapperState extends State<BlocProviderWrapper> {
  final _apiService = ApiService();

  late final _tracksRepository = TracksRepository(_apiService);
  late final _playlistsRepository = PlaylistsRepository(_apiService);

  late final _cacherBloc = CacherBloc(_apiService);
  late final _settingsBloc = SettingsBloc(_apiService);
  late final _tracksBloc = TracksBloc(_tracksRepository);
  late final _playlistsBloc = PlaylistsBloc(_playlistsRepository);
  late final _playerBloc = PlayerBloc(_apiService, _settingsBloc, _tracksRepository, _cacherBloc);

  @override
  void initState() {
    super.initState();

    _tracksBloc.add(TracksLoadEvent());
    _playlistsBloc.add(PlaylistsLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlayerBloc>(
          create: (context) => _playerBloc,
        ),
        BlocProvider<TracksBloc>.value(
          value: _tracksBloc,
        ),
        BlocProvider<TrackUploadingBloc>(
          create: (context) => TrackUploadingBloc(_tracksRepository),
        ),
        BlocProvider<PlaylistsBloc>.value(
          value: _playlistsBloc,
        ),
        BlocProvider<PlaylistCreationBloc>(
          create: (context) => PlaylistCreationBloc(
            _playlistsRepository,
            _playlistsBloc,
          ),
        ),
        BlocProvider<TracksSearchCubit>(
          create: (context) => TracksSearchCubit(
            _tracksRepository,
            _playlistsBloc,
          ),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => _settingsBloc,
        ),
        BlocProvider<AddToPlaylistBloc>(
          create: (context) => AddToPlaylistBloc(
            _tracksRepository,
            _playlistsRepository,
          ),
        ),
        BlocProvider<RemoveFromPlaylistBloc>(
          create: (context) => RemoveFromPlaylistBloc(
            _tracksRepository,
            _playlistsRepository,
          ),
        ),
        BlocProvider<CacherBloc>.value(
          value: _cacherBloc,
        ),
        BlocProvider<TrackProgressCubit>(
          create: (context) => TrackProgressCubit(_playerBloc),
        ),
        BlocProvider<SideNavigationCubit>.value(
          value: SideNavigationCubit(),
        ),
        BlocProvider<EditTrackBloc>(
          create: (context) => EditTrackBloc(_tracksRepository),
        ),
        BlocProvider<HomeContentCubit>(
          create: (context) => HomeContentCubit(),
        ),
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
      ],
      child: ShortcutsWrapper(
        playerBloc: _playerBloc,
        child: widget.child,
      ),
    );
  }
}
