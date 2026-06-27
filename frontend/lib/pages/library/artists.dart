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
      builder: (context, state) => RefreshIndicator(
        onRefresh: () => context.read<ArtistsCubit>().loadArtists(),
        child: state.when(
          initial: () => const ScrollablePlaceholder(child: SizedBox.shrink()),
          loading: () => const ScrollablePlaceholder(child: CircularProgressIndicator()),
          empty: () => ScrollablePlaceholder(child: Text('No artists', style: Theme.of(context).textTheme.bodyLarge)),
          loaded: (artists) => LayoutBuilder(
            builder: (context, constraints) => GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount(constraints.maxWidth),
                crossAxisSpacing: 8,
                mainAxisSpacing: 4,
                childAspectRatio: 4.5,
              ),
              itemCount: artists.length,
              itemBuilder: (context, index) => ArtistCard(
                artist: artists[index],
                onTap: () => context.go(RouteName.artist(artists[index].id)),
              ),
            ),
          ),
          error: (message) => ScrollablePlaceholder(child: Text(message)),
        ),
      ),
    );
  }
}
