part of 'library_page.dart';

class _Artists extends StatelessWidget {
  const _Artists();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistsCubit, ArtistsState>(
      builder: (context, state) => RefreshIndicator(
        onRefresh: () => context.read<ArtistsCubit>().loadArtists(),
        child: state.when(
          initial: () => const ScrollablePlaceholder(child: SizedBox.shrink()),
          loading: () => const ScrollablePlaceholder(child: CircularProgressIndicator()),
          empty: () => ScrollablePlaceholder(child: Text('No artists', style: Theme.of(context).textTheme.bodyLarge)),
          loaded: (artists) => GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
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
          error: (message) => ScrollablePlaceholder(child: Text(message)),
        ),
      ),
    );
  }
}
