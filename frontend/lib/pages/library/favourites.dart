part of 'library_page.dart';

class _Favourites extends StatelessWidget {
  const _Favourites();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritesCubit, FavouritesState>(
      builder: (context, state) => state.when(
        initial: () => const SizedBox.shrink(),
        loadInProgress: () => const Center(child: CircularProgressIndicator()),
        loaded: (tracks) => tracks.isEmpty
            ? const Center(child: Text('No favourites yet'))
            : ListView.separated(
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemCount: tracks.length,
                itemBuilder: (_, i) => TrackCard(
                  track: tracks[i],
                  openedPlaylist: Playlist.favourites(tracks),
                ),
              ),
        error: () => const Center(child: Text('Failed to load favourites')),
      ),
    );
  }
}
