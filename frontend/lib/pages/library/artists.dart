part of 'library_page.dart';

class _Artists extends StatelessWidget {
  const _Artists();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistsCubit, ArtistsState>(
      builder: (context, state) => RefreshIndicator(
        onRefresh: () => Future.wait([
          context.read<ArtistsCubit>().loadArtists(),
          context.read<FavouritesCubit>().loadFavourites(),
        ]),
        child: state.when(
          initial: () => const ScrollablePlaceholder(child: SizedBox.shrink()),
          loading: () => const ScrollablePlaceholder(child: CircularProgressIndicator()),
          empty: () => ScrollablePlaceholder(child: Text('No artists', style: Theme.of(context).textTheme.bodyLarge)),
          loaded: (artists) => BlocBuilder<FavouritesCubit, FavouritesState>(
            builder: (context, favouritesState) {
              final favouriteArtists = favouritesState.maybeWhen(
                loaded: (_, _, artists, _) => artists,
                orElse: () => const <Artist>[],
              );
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  if (favouriteArtists.isNotEmpty) ...[
                    const _SectionHeader(title: 'Favourites'),
                    _favouritesRow(favouriteArtists),
                    const _SectionHeader(title: 'All artists'),
                  ],
                  _grid(artists),
                ],
              );
            },
          ),
          error: (message) => ScrollablePlaceholder(child: Text(message)),
        ),
      ),
    );
  }

  Widget _favouritesRow(List<Artist> artists) => SliverToBoxAdapter(
    child: SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: artists.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: 160,
            child: ArtistCard(
              artist: artists[index],
              onTap: () => context.go(RouteName.artist(artists[index].id)),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _grid(List<Artist> artists) => SliverPadding(
    padding: const EdgeInsets.all(12),
    sliver: SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: artists.length,
      itemBuilder: (context, index) => ArtistCard(
        artist: artists[index],
        onTap: () => context.go(RouteName.artist(artists[index].id)),
      ),
    ),
  );
}
