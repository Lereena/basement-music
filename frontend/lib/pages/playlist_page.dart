import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/connectivity_status_bloc/connectivity_status_cubit.dart';
import '../bloc/playlists_bloc/playlists_bloc.dart';
import '../models/playlist.dart';
import '../widgets/track_card.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist playlist;

  const PlaylistPage({super.key, required this.playlist});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late final PlaylistsBloc _playlistsBloc;

  @override
  void initState() {
    super.initState();
    _playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    _playlistsBloc.openedPlaylist = widget.playlist;
  }

  @override
  void dispose() {
    _playlistsBloc.openedPlaylist = Playlist.empty();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.playlist.tracks.isEmpty)
          Center(
            child: Text(
              'No tracks',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        else
          BlocBuilder<ConnectivityStatusCubit, ConnectivityStatusState>(
            builder: (_, state) {
              return Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, _) => const Divider(height: 1),
                  itemCount: widget.playlist.tracks.length,
                  itemBuilder: (context, index) => TrackCard(
                    track: widget.playlist.tracks[index],
                    containingPlaylist: widget.playlist,
                    openedPlaylist: widget.playlist,
                    active: state is HasConnectionState,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
