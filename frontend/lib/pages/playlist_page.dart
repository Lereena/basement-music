import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/playlist_bloc/playlist_bloc.dart';
import '../widgets/track_card.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistId;
  // TODO
  // final Playlist playlist;

  const PlaylistPage({super.key, required this.playlistId});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late final PlaylistBloc _playlistBloc;

  @override
  void initState() {
    super.initState();
    _playlistBloc = BlocProvider.of<PlaylistBloc>(context);
    _playlistBloc.add(PlaylistLoadEvent(widget.playlistId));
    // _playlistsBloc.openedPlaylist = widget.playlist;
  }

  @override
  void dispose() {
    super.dispose();
    // _playlistsBloc.openedPlaylist = Playlist.empty();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        if (state is PlaylistLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PlaylistEmptyState) {
          return Scaffold(
            appBar: AppBar(title: Text(state.title)),
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
            appBar: AppBar(title: Text(state.playlist.title)),
            body: Column(
              children: [
                ListView.separated(
                  separatorBuilder: (context, _) => const Divider(height: 1),
                  itemCount: state.playlist.tracks.length,
                  itemBuilder: (context, index) => TrackCard(
                    track: state.playlist.tracks[index],
                    containingPlaylist: state.playlist,
                    openedPlaylist: state.playlist,
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
