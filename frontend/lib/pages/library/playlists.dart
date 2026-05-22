part of 'library_page.dart';

class _Playlists extends StatelessWidget {
  const _Playlists();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistsCubit, PlaylistsState>(
      builder: (context, state) => state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        empty: () => Center(child: Text('No playlists', style: Theme.of(context).textTheme.bodyLarge)),
        loaded: (playlists) => Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: playlists.length,
                itemBuilder: (context, index) => PlaylistCard(
                  playlist: playlists[index],
                  onTap: () => context.go(RouteName.playlist(playlists[index].id)),
                ),
              ),
            ),
          ],
        ),
        error: () => const Center(child: Text('Error loading playlists')),
      ),
    );
  }
}
