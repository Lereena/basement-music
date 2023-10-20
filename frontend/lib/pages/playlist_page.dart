import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/playlist_bloc/playlist_bloc.dart';
import '../routing/routes.dart';
import '../widgets/app_bar.dart';
import '../widgets/playlist_cache_action.dart';
import '../widgets/track_card.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistId;

  const PlaylistPage({super.key, required this.playlistId});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late final PlaylistBloc _playlistBloc;

  @override
  void initState() {
    super.initState();
    _playlistBloc = context.read<PlaylistBloc>();
    _playlistBloc.add(PlaylistLoadEvent(widget.playlistId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        if (state is PlaylistLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is PlaylistEmptyState) {
          return Scaffold(
            appBar: BasementAppBar(
              title: state.title,
              actions: _getAppBarActions(),
            ),
            body: Center(
              child: Text(
                'No tracks',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        if (state is PlaylistLoadedState) {
          return Scaffold(
            appBar: BasementAppBar(
              title: state.playlist.title,
              actions: _getAppBarActions(
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

        if (state is PlaylistErrorState) {
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

  List<Widget> _getAppBarActions({List<String>? tracksIds}) => [
        if (!kIsWeb && Platform.isAndroid && tracksIds != null)
          PlaylistCacheAction(trackIds: tracksIds),
        IconButton(
          onPressed: () =>
              context.go(RouteName.playlistEdit(widget.playlistId)),
          icon: const Icon(
            Icons.edit_outlined,
          ),
        ),
      ];
}
