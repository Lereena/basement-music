import 'dart:io';

import 'package:basement_music/bloc/playlist_cubit/playlist_cubit.dart';
import 'package:basement_music/repositories/playlists_repository.dart';
import 'package:basement_music/routing/routes.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:basement_music/widgets/playlist_cache_action.dart';
import 'package:basement_music/widgets/track_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PlaylistPage extends StatelessWidget {
  final String playlistId;

  const PlaylistPage({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PlaylistCubit(playlistsRepository: context.read<PlaylistsRepository>(), playlistId: playlistId)..load(),
      child: _PlaylistPage(playlistId: playlistId),
    );
  }
}

class _PlaylistPage extends StatelessWidget {
  final String playlistId;

  const _PlaylistPage({required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (context, state) => state.when(
        initial: () => const SizedBox.shrink(),
        loadInProgress: () => const Center(child: CircularProgressIndicator()),
        loadedEmpty: (title) => Scaffold(
          appBar: BasementAppBar(title: title, actions: _appBarActions()),
          body: Center(child: Text('No tracks', style: Theme.of(context).textTheme.bodyLarge)),
        ),
        loaded: (playlist) => Scaffold(
          appBar: BasementAppBar(
            title: playlist.title,
            actions: _appBarActions(tracksIds: playlist.tracks.map((e) => e.id).toList()),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, _) => const Divider(height: 1),
                  itemCount: playlist.tracks.length,
                  itemBuilder: (context, index) =>
                      TrackCard(track: playlist.tracks[index], containingPlaylist: playlist, openedPlaylist: playlist),
                ),
              ),
            ],
          ),
        ),
        error: () => Scaffold(
          appBar: BasementAppBar(title: ''),
          body: const Center(child: Text('Error loading playlist')),
        ),
      ),
    );
  }

  List<Widget> _appBarActions({List<String>? tracksIds}) => [
    if (!kIsWeb && Platform.isAndroid && tracksIds != null) PlaylistCacheAction(trackIds: tracksIds),
    Builder(
      builder: (context) {
        return IconButton(
          onPressed: () => context.go(RouteName.playlistEdit(playlistId)),
          icon: const Icon(Icons.edit_outlined),
        );
      },
    ),
  ];
}
