import 'package:basement_music/bloc/album_cubit/album_cubit.dart';
import 'package:basement_music/models/album.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/repositories/albums_repository.dart';
import 'package:basement_music/routing/routes.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:basement_music/widgets/dialogs/album_cover_dialog.dart';
import 'package:basement_music/widgets/track_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AlbumPage extends StatelessWidget {
  final String albumId;

  const AlbumPage({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlbumCubit(albumsRepository: context.read<AlbumsRepository>(), albumId: albumId)..loadAlbum(),
      child: _AlbumPage(albumId: albumId),
    );
  }
}

class _AlbumPage extends StatelessWidget {
  final String albumId;

  const _AlbumPage({required this.albumId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumCubit, AlbumState>(
      builder: (context, state) => state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => Scaffold(
          appBar: BasementAppBar(title: ''),
          body: const Center(child: CircularProgressIndicator()),
        ),
        loaded: (album) => Scaffold(
          appBar: BasementAppBar(title: album.title, actions: _actions(context, album)),
          body: HorizontalSpaceReducer(child: _AlbumBody(album: album)),
        ),
        error: () => Scaffold(
          appBar: BasementAppBar(title: ''),
          body: const Center(child: Text('Error loading album')),
        ),
      ),
    );
  }

  List<Widget> _actions(BuildContext context, Album album) => [
    IconButton(
      icon: const Icon(Icons.image_outlined),
      tooltip: 'Fetch cover',
      onPressed: () => AlbumCoverDialog.show(
        context: context,
        album: album,
        onApplied: () => context.read<AlbumCubit>().loadAlbum(),
      ),
    ),
    IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => context.go(RouteName.albumEdit(albumId))),
    IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _confirmDelete(context)),
  ];

  Future<void> _confirmDelete(BuildContext context) async {
    final cubit = context.read<AlbumCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete album?'),
        content: const Text('Tracks will be unbound but not deleted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    await cubit.deleteAlbum();
    if (context.mounted) context.pop();
  }
}

class _AlbumBody extends StatelessWidget {
  final Album album;

  const _AlbumBody({required this.album});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final artists = album.artists ?? [];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 240, maxHeight: 240),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: album.cover != null
                            ? CachedNetworkImage(
                                imageUrl: album.cover!,
                                fit: BoxFit.cover,
                                errorWidget: (_, _, _) => _cover(theme),
                              )
                            : _cover(theme),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(album.title, style: theme.textTheme.headlineSmall),
                if (album.year != null)
                  Text(
                    '${album.year}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.64),
                    ),
                  ),
                if (artists.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: artists
                        .map(
                          (a) => ActionChip(label: Text(a.name), onPressed: () => context.go(RouteName.artist(a.id))),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final track = album.tracks[index];

            return TrackCard(
              track: track,
              containingPlaylist: Playlist.anonymous(album.tracks),
              openedPlaylist: Playlist.anonymous(album.tracks),
            );
          }, childCount: album.tracks.length),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _cover(ThemeData theme) =>
      Container(color: theme.colorScheme.surfaceContainerHighest, child: const Icon(Icons.album, size: 96));
}
