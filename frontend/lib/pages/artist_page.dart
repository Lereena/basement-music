import 'package:basement_music/bloc/artist_cubit/artist_cubit.dart';
import 'package:basement_music/bloc/auth_cubit/auth_cubit.dart';
import 'package:basement_music/models/album.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/repositories/albums_repository.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/routing/routes.dart';
import 'package:basement_music/widgets/dialogs/artist_metadata_dialog.dart';
import 'package:basement_music/widgets/track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ArtistPage extends StatelessWidget {
  final String artistId;

  const ArtistPage({super.key, required this.artistId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ArtistCubit(artistsRepository: context.read<ArtistsRepository>(), artistId: artistId)..loadArtist(),
      child: _ArtistPage(artistId: artistId),
    );
  }
}

class _ArtistPage extends StatelessWidget {
  final String artistId;

  const _ArtistPage({required this.artistId});

  bool _isAdmin(BuildContext context) => context.read<AuthCubit>().state.maybeWhen(
    authenticated: (user) => user.isAdmin,
    orElse: () => false,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistCubit, ArtistState>(
      builder: (context, state) => state.when(
        initial: () => const Scaffold(body: SizedBox.shrink()),
        loadInProgress: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        loaded: (artist) => Scaffold(body: _ArtistView(artist: artist, isAdmin: _isAdmin(context))),
        loadedEmpty: (name) => Scaffold(
          appBar: AppBar(title: Text(name)),
          body: const Center(child: Text('No tracks')),
        ),
        error: () => Scaffold(appBar: AppBar(), body: const Center(child: Text('Error loading artist'))),
      ),
    );
  }
}

class _ArtistView extends StatelessWidget {
  static const _maxTracks = 10;

  final Artist artist;
  final bool isAdmin;

  const _ArtistView({required this.artist, required this.isAdmin});

  Future<void> _createAlbum(BuildContext context) async {
    final cubit = context.read<ArtistCubit>();
    final album = await context.read<AlbumsRepository>().createAlbum('New album', [artist.id]);
    if (context.mounted) {
      await context.push(RouteName.albumEdit(album.id));
      cubit.loadArtist();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tracks = artist.tracks ?? [];
    final albums = artist.albums ?? [];
    final visibleTracks = tracks.take(_maxTracks).toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 240,
          pinned: true,
          actions: isAdmin
              ? [
                  IconButton(
                    icon: const Icon(Icons.travel_explore),
                    tooltip: 'Fetch info',
                    onPressed: () => ArtistMetadataDialog.show(
                      context: context,
                      artistId: artist.id,
                      artistName: artist.name,
                      onApplied: () => context.read<ArtistCubit>().loadArtist(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () async {
                      final cubit = context.read<ArtistCubit>();
                      await context.push(RouteName.artistEdit(artist.id));
                      cubit.loadArtist();
                    },
                  ),
                ]
              : null,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(artist.name),
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (artist.image != null)
                  Image.network(artist.image!, fit: BoxFit.cover, errorBuilder: (_, _, _) => _imagePlaceholder(theme))
                else
                  _imagePlaceholder(theme),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, theme.colorScheme.surface.withValues(alpha: 0.9)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (tracks.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text('Tracks', style: theme.textTheme.titleMedium),
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => TrackCard(
              track: visibleTracks[index],
              containingPlaylist: Playlist.anonymous(visibleTracks),
              openedPlaylist: Playlist.anonymous(visibleTracks),
            ),
            childCount: visibleTracks.length,
          ),
        ),
        if (tracks.length > _maxTracks)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => context.push(RouteName.artistTracks(artist.id)),
                  child: const Text('See more'),
                ),
              ),
            ),
          ),
        if (albums.isNotEmpty || isAdmin)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text('Albums', style: theme.textTheme.titleMedium),
            ),
          ),
        if (albums.isNotEmpty || isAdmin)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                children: [
                  for (final album in albums) _AlbumCard(album: album),
                  if (isAdmin) _NewAlbumCard(onTap: () => _createAlbum(context)),
                ],
              ),
            ),
          ),
        if (artist.description != null && artist.description!.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _ExpandableText(text: artist.description!),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _imagePlaceholder(ThemeData theme) =>
      Container(color: theme.colorScheme.primaryContainer, child: const Icon(Icons.person, size: 96));
}

class _ExpandableText extends StatefulWidget {
  final String text;

  const _ExpandableText({required this.text});

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: _expanded ? null : 4,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () => setState(() => _expanded = !_expanded),
          child: Text(_expanded ? 'Less' : 'More'),
        ),
      ],
    );
  }
}

class _AlbumCard extends StatelessWidget {
  final Album album;

  const _AlbumCard({required this.album});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.go(RouteName.album(album.id)),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: album.cover != null
                    ? Image.network(album.cover!, width: 130, fit: BoxFit.cover, errorBuilder: (_, _, _) => _placeholder(theme))
                    : _placeholder(theme),
              ),
            ),
            const SizedBox(height: 6),
            Text(album.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) => Container(
    width: 130,
    color: theme.colorScheme.surfaceContainerHighest,
    child: const Icon(Icons.album, size: 48),
  );
}

class _NewAlbumCard extends StatelessWidget {
  final VoidCallback onTap;

  const _NewAlbumCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: const Icon(Icons.add, size: 40),
              ),
            ),
            const SizedBox(height: 6),
            Text('New album', maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
