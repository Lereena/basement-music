part of 'library_page.dart';

class _Artists extends StatelessWidget {
  const _Artists();

  int _crossAxisCount(double width) {
    if (width >= kLargeBreakpoint) return 3;
    if (width >= kSmallBreakpoint) return 2;
    return 1;
  }

  void _pickAndUploadImage(BuildContext context, String artistId) async {
    final result = await FilePicker.pickFiles(type: FileType.image, withData: true);
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;

    if (file.bytes == null) return;

    if (context.mounted) {
      await context.read<ArtistsCubit>().uploadArtistImage(artistId, file.bytes!, file.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (user) => user.isAdmin,
      orElse: () => false,
    );

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
              childAspectRatio: 4.5,
            ),
            itemCount: artists.length,
            itemBuilder: (context, index) => ArtistCard(
              artist: artists[index],
              onTap: () => context.go(RouteName.artist(artists[index].id)),
              onImageEdit: isAdmin ? () => _pickAndUploadImage(context, artists[index].id) : null,
            ),
          ),
        ),
        error: (message) => Center(child: Text(message)),
      ),
    );
  }
}
