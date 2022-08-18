import 'package:basement_music/bloc/playlists_bloc/playlists_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/playlists_bloc/playlists_bloc.dart';
import '../widgets/playlist_card.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<PlaylistsBloc, PlaylistsState>(
        builder: (context, state) {
          if (state is PlaylistsLoadingState) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is PlaylistsEmptyState) {
            return Center(
              child: Text(
                'No playlists',
                style: TextStyle(fontSize: 24),
              ),
            );
          }

          if (state is PlaylistsLoadedState) {
            return ListView.separated(
              itemBuilder: (context, index) => PlaylistCard(playlist: state.playlists[index]),
              separatorBuilder: (context, _) => Divider(height: 1),
              itemCount: state.playlists.length,
            );
          }

          if (state is PlaylistsErrorState) {
            return Center(
              child: Text('Error loading playlists'),
            );
          }

          return Container();
        },
      ),
    );
  }
}
