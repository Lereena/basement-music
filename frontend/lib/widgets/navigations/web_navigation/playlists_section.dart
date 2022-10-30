import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/playlists_bloc/playlists_bloc.dart';
import '../../../bloc/playlists_bloc/playlists_state.dart';
import '../../playlist_card.dart';

class PlaylistsSection extends StatelessWidget {
  const PlaylistsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<PlaylistsBloc, PlaylistsState>(
        builder: (context, state) {
          if (state is PlaylistsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PlaylistsEmptyState) {
            return const Center(
              child: Text(
                'No playlists',
                style: TextStyle(fontSize: 24),
              ),
            );
          }

          if (state is PlaylistsLoadedState) {
            return ListView.builder(
              itemBuilder: (context, index) => PlaylistCard(playlist: state.playlists[index]),
              itemCount: state.playlists.length,
            );
          }

          if (state is PlaylistsErrorState) {
            return const Center(
              child: Text('Error loading playlists'),
            );
          }

          return Container();
        },
      ),
    );
  }
}