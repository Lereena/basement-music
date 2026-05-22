part of 'library_page.dart';

class _Artists extends StatelessWidget {
  const _Artists();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistsCubit, ArtistsState>(
      builder: (context, state) => state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        empty: () => Center(
          child: Text(
            'No artists',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        loaded: (artists) => ListView.builder(
          itemBuilder: (context, index) => ArtistCard(
            artist: artists[index],
            onTap: () => context.go(
              RouteName.artist(artists[index].id),
            ),
          ),
          itemCount: artists.length,
        ),
        error: (message) => Center(child: Text(message)),
      ),
    );
  }
}
