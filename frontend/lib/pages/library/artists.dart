part of 'library_page.dart';

class _Artists extends StatelessWidget {
  const _Artists();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistsCubit, ArtistsState>(
      builder: (context, state) {
        if (state is ArtistsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ArtistsEmpty) {
          return Center(
            child: Text(
              'No artists',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        if (state is ArtistsLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) => ArtistCard(
              artist: state.artists[index],
              onTap: () => context.go(
                RouteName.artist(state.artists[index].id),
              ),
            ),
            itemCount: state.artists.length,
          );
        }

        if (state is ArtistsError) {
          return Center(
            child: Text(state.message),
          );
        }
        return Container();
      },
    );
  }
}
