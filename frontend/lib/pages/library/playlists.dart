part of 'library_page.dart';

// class _PlaylistsPage extends StatelessWidget {
//   const _PlaylistsPage();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => PlaylistsBloc(
//         playlistsRepository: context.read<PlaylistsRepository>(),
//         connectivityStatusRepository: context.read<ConnectivityStatusRepository>(),
//       )..add(PlaylistsLoadStarted()),
//       child: const _Playlists(),
//     );
//   }
// }

class _Playlists extends StatelessWidget {
  const _Playlists();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistsBloc, PlaylistsState>(
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
                  itemCount: state.playlists.length,
                  itemBuilder: (context, index) => PlaylistCard(
                    playlist: state.playlists[index],
                    onTap: () => context.go(
                      RouteName.playlist(state.playlists[index].id),
                    ),
                  ),
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
    );
  }
}
