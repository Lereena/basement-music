import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/playlist_bloc/playlist_bloc.dart';
import '../routing/routes.dart';
import '../widgets/app_bar.dart';
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

  late final _appBarActions = [
    IconButton(
      onPressed: () => context.go(RouteName.playlistEdit(widget.playlistId)),
      icon: const Icon(
        Icons.edit_outlined,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        if (state is PlaylistLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PlaylistEmptyState) {
          return Scaffold(
            appBar: BasementAppBar(
              title: state.title,
              actions: _appBarActions,
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
              actions: _appBarActions,
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

        return const SizedBox.shrink();
      },
    );
  }
}
