part of 'library_page.dart';

class _Favourites extends StatelessWidget {
  const _Favourites();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritesCubit, FavouritesState>(
      builder: (context, state) => RefreshIndicator(
        onRefresh: () => context.read<FavouritesCubit>().loadFavourites(),
        child: state.when(
          initial: () => const ScrollablePlaceholder(child: SizedBox.shrink()),
          loadInProgress: () => const ScrollablePlaceholder(child: CircularProgressIndicator()),
          loaded: (tracks) => tracks.isEmpty
              ? const ScrollablePlaceholder(child: Text('No favourites yet'))
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  itemCount: tracks.length,
                  itemBuilder: (_, i) => TrackCard(
                    track: tracks[i],
                    openedPlaylist: Playlist.favourites(tracks),
                  ),
                ),
          error: () => const ScrollablePlaceholder(child: Text('Failed to load favourites')),
        ),
      ),
    );
  }
}
