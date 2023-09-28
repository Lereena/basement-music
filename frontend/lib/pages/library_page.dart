import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/navigation_cubit/navigation_cubit.dart';
import '../bloc/playlists_bloc/playlists_bloc.dart';
import '../bloc/playlists_bloc/playlists_event.dart';
import '../bloc/playlists_bloc/playlists_state.dart';
import '../widgets/playlist_card.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    final navigationCubit = BlocProvider.of<NavigationCubit>(context);

    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
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
            return Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => PlaylistCard(
                      playlist: state.playlists[index],
                      onTap: () => navigationCubit
                          .navigatePlaylist(state.playlists[index]),
                    ),
                    itemCount: state.playlists.length,
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
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    final playilstsBloc = context.read<PlaylistsBloc>();

    final newState = playilstsBloc.stream.first;
    playilstsBloc.add(PlaylistsLoadEvent());
    await newState;
  }
}
