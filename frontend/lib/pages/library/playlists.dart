part of 'library_page.dart';

class _Playlists extends StatelessWidget {
  const _Playlists();

  int _crossAxisCount(double width) {
    if (width >= kLargeBreakpoint) return 3;
    if (width >= kSmallBreakpoint) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistsCubit, PlaylistsState>(
      builder: (context, state) => RefreshIndicator(
        onRefresh: () => Future.wait([
          context.read<PlaylistsCubit>().loadPlaylists(),
          context.read<FavouritesCubit>().loadFavourites(),
        ]),
        child: state.when(
          loading: () => const ScrollablePlaceholder(child: CircularProgressIndicator()),
          empty: () => ScrollablePlaceholder(child: Text('No playlists', style: Theme.of(context).textTheme.bodyLarge)),
          loaded: (playlists) => LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = _crossAxisCount(constraints.maxWidth);
              return BlocBuilder<FavouritesCubit, FavouritesState>(
                builder: (context, favouritesState) {
                  final favouritePlaylists = favouritesState.maybeWhen(
                    loaded: (_, playlists, _, _) => playlists,
                    orElse: () => const <Playlist>[],
                  );
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      if (favouritePlaylists.isNotEmpty) ...[
                        const _SectionHeader(title: 'Favourites'),
                        _favouritesRow(favouritePlaylists),
                        const _SectionHeader(title: 'All playlists'),
                      ],
                      _grid(playlists, crossAxisCount),
                    ],
                  );
                },
              );
            },
          ),
          error: () => const ScrollablePlaceholder(child: Text('Error loading playlists')),
        ),
      ),
    );
  }

  Widget _favouritesRow(List<Playlist> playlists) => SliverToBoxAdapter(
    child: SizedBox(
      height: 76,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: playlists.length,
        itemBuilder: (context, index) => SizedBox(
          width: 300,
          child: PlaylistCard(
            playlist: playlists[index],
            onTap: () => context.go(RouteName.playlist(playlists[index].id)),
          ),
        ),
      ),
    ),
  );

  Widget _grid(List<Playlist> playlists, int crossAxisCount) => SliverGrid.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 8,
      mainAxisSpacing: 4,
      childAspectRatio: 4.5,
    ),
    itemCount: playlists.length,
    itemBuilder: (context, index) => PlaylistCard(
      playlist: playlists[index],
      onTap: () => context.go(RouteName.playlist(playlists[index].id)),
    ),
  );
}
