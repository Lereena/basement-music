import 'package:basement_music/bloc/artist_cubit/artist_cubit.dart';
import 'package:basement_music/models/album.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/repositories/albums_repository.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/routing/routes.dart';
import 'package:basement_music/theme/theme.dart';
import 'package:basement_music/widgets/dialogs/artist_metadata_dialog.dart';
import 'package:basement_music/widgets/track_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistCubit, ArtistState>(
      builder: (context, state) => state.when(
        initial: () => const Scaffold(body: SizedBox.shrink()),
        loadInProgress: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        loaded: (artist) => Scaffold(body: _ArtistView(artist: artist)),
        loadedEmpty: (name) => Scaffold(
          appBar: AppBar(title: Text(name)),
          body: const Center(child: Text('No tracks')),
        ),
        error: () => Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('Error loading artist')),
        ),
      ),
    );
  }
}

class _ArtistView extends StatelessWidget {
  static const _maxTracks = 10;

  final Artist artist;

  const _ArtistView({required this.artist});

  Future<void> _createAlbum(BuildContext context) async {
    final cubit = context.read<ArtistCubit>();
    final album = await context.read<AlbumsRepository>().createAlbum('Untitled', [artist.id]);
    if (context.mounted) {
      await context.push(RouteName.albumEdit(album.id, isNew: true));
      cubit.loadArtist();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tracks = artist.tracks ?? [];
    final albums = artist.albums ?? [];
    final visibleTracks = tracks.take(_maxTracks).toList();

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            actions: [
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
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                artist.name,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.3),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (artist.image != null)
                    CachedNetworkImage(
                      imageUrl: artist.image!,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => _imagePlaceholder(theme),
                    )
                  else
                    _imagePlaceholder(theme),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        stops: const [0.3, 0.9],
                        colors: [
                          theme.colorScheme.surfaceContainerLowest.withAlpha(0),
                          theme.colorScheme.surfaceContainerLowest,
                        ],
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.topCenter,
                        stops: const [0.5, 0.9],
                        colors: [
                          theme.colorScheme.surfaceContainerLowest.withAlpha(0),
                          theme.colorScheme.surfaceContainerLowest,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (tracks.isNotEmpty) const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
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
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => context.push(RouteName.artistTracks(artist.id)),
                    child: const Text('See more'),
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
              child: Text('Albums', style: theme.textTheme.titleMedium),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                children: [
                  for (final album in albums) _AlbumCard(album: album),
                  _NewAlbumCard(onTap: () => _createAlbum(context)),
                ],
              ),
            ),
          ),
          if (artist.description != null && artist.description!.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                child: Text('Bio', style: theme.textTheme.titleMedium),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: _ExpandableText(text: artist.description!),
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        ],
      ),
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
        TextButton(onPressed: () => setState(() => _expanded = !_expanded), child: Text(_expanded ? 'Less' : 'More')),
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
      onTap: () => context.push(RouteName.album(album.id)),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: AppRadius.smAll,
                child: album.cover != null
                    ? CachedNetworkImage(
                        imageUrl: album.cover!,
                        width: 130,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => _placeholder(theme),
                      )
                    : _placeholder(theme),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(album.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) =>
      Container(width: 130, color: theme.colorScheme.surfaceContainerHighest, child: const Icon(Icons.album, size: 48));
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
        margin: const EdgeInsets.only(right: AppSpacing.md),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.smAll,
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: const Icon(Icons.add, size: 40),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text('New album', maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
