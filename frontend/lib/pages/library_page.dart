import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/playlists_bloc/playlists_bloc.dart';
import '../bloc/playlists_bloc/playlists_event.dart';
import '../bloc/playlists_bloc/playlists_state.dart';
import '../routing/routes.dart';
import '../widgets/create_playlist.dart';
import '../widgets/playlist_card.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('Library')),
        body: BlocBuilder<PlaylistsBloc, PlaylistsState>(
          builder: (context, state) {
            if (state is PlaylistsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PlaylistsEmptyState) {
              return Center(
                child: Text(
                  'No playlists',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            if (state is PlaylistsLoadedState) {
              return Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index == state.playlists.length) {
                          return const SizedBox(height: 64);
                        }
                        return PlaylistCard(
                          playlist: state.playlists[index],
                          onTap: () => context.go(
                            Routes.playlist(state.playlists[index].id),
                          ),
                        );
                      },
                      itemCount: state.playlists.length + 1,
                    ),
                  ),
                ],
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
          child: const Icon(Icons.add),
          onPressed: () => CreatePlaylistDialog.show(context: context),
        ),
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    final playilstsBloc = context.read<PlaylistsBloc>();

    final newState = playilstsBloc.stream.first;
    playilstsBloc.add(PlaylistsLoadEvent());
    await newState;
  }
}
