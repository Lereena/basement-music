import 'package:basement_music/bloc/artist_cubit/artist_cubit.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/widgets/track_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArtistTracksPage extends StatelessWidget {
  final String artistId;

  const ArtistTracksPage({super.key, required this.artistId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ArtistCubit(artistsRepository: context.read<ArtistsRepository>(), artistId: artistId)..loadArtist(),
      child: const _ArtistTracksPage(),
    );
  }
}

class _ArtistTracksPage extends StatelessWidget {
  const _ArtistTracksPage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistCubit, ArtistState>(
      builder: (context, state) => state.when(
        initial: () => const Scaffold(body: SizedBox.shrink()),
        loadInProgress: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        loaded: (artist) => Scaffold(body: _TracksView(artist: artist)),
        loadedEmpty: (name) => Scaffold(
          appBar: AppBar(title: Text(name)),
          body: const Center(child: Text('No tracks')),
        ),
        error: () => Scaffold(appBar: AppBar(), body: const Center(child: Text('Error loading artist'))),
      ),
    );
  }
}

class _TracksView extends StatelessWidget {
  final Artist artist;

  const _TracksView({required this.artist});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tracks = artist.tracks ?? [];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primaryContainer,
                backgroundImage: artist.image != null ? CachedNetworkImageProvider(artist.image!) : null,
                child: artist.image == null ? const Icon(Icons.person, size: 20) : null,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(artist.name, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => TrackCard(
              track: tracks[index],
              containingPlaylist: Playlist.anonymous(tracks),
              openedPlaylist: Playlist.anonymous(tracks),
            ),
            childCount: tracks.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
