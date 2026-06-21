part of 'library_page.dart';

class _Playlists extends StatelessWidget {
  const _Playlists();

  int _crossAxisCount(double width) {
    if (width >= kLargeBreakpoint) return 3;
    if (width >= kSmallBreakpoint) return 2;
    return 1;
  }

  void _pickAndUploadImage(BuildContext context, String playlistId) async {
    final result = await FilePicker.pickFiles(type: FileType.image, withData: true);
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null) return;

    if (context.mounted) {
      await context.read<PlaylistsCubit>().uploadPlaylistImage(playlistId, file.bytes!, file.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (user) => user.isAdmin,
      orElse: () => false,
    );

    return BlocBuilder<PlaylistsCubit, PlaylistsState>(
      builder: (context, state) => state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        empty: () => Center(child: Text('No playlists', style: Theme.of(context).textTheme.bodyLarge)),
        loaded: (playlists) => LayoutBuilder(
          builder: (context, constraints) => GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _crossAxisCount(constraints.maxWidth),
              crossAxisSpacing: 8,
              mainAxisSpacing: 4,
              childAspectRatio: 4.5,
            ),
            itemCount: playlists.length,
            itemBuilder: (context, index) => PlaylistCard(
              playlist: playlists[index],
              onTap: () => context.go(RouteName.playlist(playlists[index].id)),
              onImageEdit: isAdmin ? () => _pickAndUploadImage(context, playlists[index].id) : null,
            ),
          ),
        ),
        error: () => const Center(child: Text('Error loading playlists')),
      ),
    );
  }
}
