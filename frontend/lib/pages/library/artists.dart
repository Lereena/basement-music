part of 'library_page.dart';

class _Artists extends StatelessWidget {
  const _Artists();

  int _crossAxisCount(double width) {
    if (width >= kLargeBreakpoint) return 3;
    if (width >= kSmallBreakpoint) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistsCubit, ArtistsState>(
      builder: (context, state) => state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        empty: () => Center(child: Text('No artists', style: Theme.of(context).textTheme.bodyLarge)),
        loaded: (artists) => LayoutBuilder(
          builder: (context, constraints) => GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _crossAxisCount(constraints.maxWidth),
              crossAxisSpacing: 8,
              mainAxisSpacing: 4,
              childAspectRatio: 5,
            ),
            itemCount: artists.length,
            itemBuilder: (context, index) =>
                ArtistCard(artist: artists[index], onTap: () => context.go(RouteName.artist(artists[index].id))),
          ),
        ),
        error: (message) => Center(child: Text(message)),
      ),
    );
  }
}
