import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/playlist_bloc/playlist_bloc.dart';
import '../repositories/playlists_repository.dart';
import '../routing/routes.dart';
import '../widgets/app_bar.dart';
import '../widgets/playlist_cache_action.dart';
import '../widgets/track_card.dart';

class PlaylistPage extends StatelessWidget {
  final String playlistId;

  const PlaylistPage({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaylistBloc(
        playlistsRepository: context.read<PlaylistsRepository>(),
        playlistId: playlistId,
      )..add(PlaylistLoadStarted()),
      child: _PlaylistPage(playlistId: playlistId),
    );
  }
}

class _PlaylistPage extends StatelessWidget {
  final String playlistId;

  const _PlaylistPage({required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        if (state is PlaylistLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PlaylistLoadedEmpty) {
          return Scaffold(
            appBar: BasementAppBar(
              title: state.title,
              actions: _appBarActions(),
            ),
            body: Center(
              child: Text(
                'No tracks',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        if (state is PlaylistLoaded) {
          return Scaffold(
            appBar: BasementAppBar(
              title: state.playlist.title,
              actions: _appBarActions(
                tracksIds: state.playlist.tracks.map((e) => e.id).toList(),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, _) => const Divider(height: 1),
                    itemCount: state.playlist.tracks.length,
                    itemBuilder: (context, index) => TrackCard(
                      track: state.playlist.tracks[index],
                      containingPlaylist: state.playlist,
                      openedPlaylist: state.playlist,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is PlaylistError) {
          return Scaffold(
            appBar: BasementAppBar(
              title: '',
            ),
            body: const Center(child: Text('Error loading playlist')),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  List<Widget> _appBarActions({List<String>? tracksIds}) => [
        if (!kIsWeb && Platform.isAndroid && tracksIds != null)
          PlaylistCacheAction(trackIds: tracksIds),
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
