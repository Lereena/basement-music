import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/playlists_bloc/playlists_bloc.dart';
import '../repositories/repositories.dart';
import '../routing/routes.dart';
import '../widgets/app_bar.dart';
import '../widgets/create_playlist.dart';
import '../widgets/playlist_card.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaylistsBloc(
        playlistsRepository: context.read<PlaylistsRepository>(),
        connectivityStatusRepository:
            context.read<ConnectivityStatusRepository>(),
      )..add(PlaylistsLoadEvent()),
      child: const _LibraryPage(),
    );
  }
}

class _LibraryPage extends StatelessWidget {
  const _LibraryPage();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      child: Scaffold(
        appBar: BasementAppBar(title: 'Library'),
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
                            RouteName.playlist(state.playlists[index].id),
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
