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
        onRefresh: () => context.read<PlaylistsCubit>().loadPlaylists(),
        child: state.when(
          loading: () => const ScrollablePlaceholder(child: CircularProgressIndicator()),
          empty: () => ScrollablePlaceholder(child: Text('No playlists', style: Theme.of(context).textTheme.bodyLarge)),
          loaded: (playlists) => LayoutBuilder(
            builder: (context, constraints) => GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount(constraints.maxWidth),
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.xs,
                childAspectRatio: 3.6,
              ),
              itemCount: playlists.length,
              itemBuilder: (context, index) => PlaylistCard(
                playlist: playlists[index],
                onTap: () => context.go(RouteName.playlist(playlists[index].id)),
              ),
            ),
          ),
          error: () => const ScrollablePlaceholder(child: Text('Error loading playlists')),
        ),
      ),
    );
  }
}
