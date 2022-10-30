import 'package:basement_music/bloc/playlists_bloc/playlists_state.dart';
import 'package:basement_music/widgets/wrappers/content_narrower.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/playlists_bloc/playlists_bloc.dart';
import '../widgets/create_playlist.dart';
import '../widgets/dialog.dart';
import '../widgets/playlist_card.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlaylistsBloc, PlaylistsState>(
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
            return ContentNarrower(
              child: ListView.builder(
                itemBuilder: (context, index) => PlaylistCard(playlist: state.playlists[index]),
                itemCount: state.playlists.length,
              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const CustomDialog(child: CreatePlaylist()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}