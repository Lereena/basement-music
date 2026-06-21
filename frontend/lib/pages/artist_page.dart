import 'package:basement_music/bloc/artist_cubit/artist_cubit.dart';
import 'package:basement_music/bloc/auth_cubit/auth_cubit.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/routing/routes.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/widgets/app_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (user) => user.isAdmin,
      orElse: () => false,
    );

    return BlocBuilder<ArtistCubit, ArtistState>(
      builder: (context, state) => state.when(
        initial: () => const SizedBox.shrink(),
        loadInProgress: () => const Center(child: CircularProgressIndicator()),
        loadedEmpty: (name) => Scaffold(
          appBar: BasementAppBar(
            title: name,
            actions: isAdmin
                ? [IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => context.go(RouteName.artistEdit(artistId)))]
                : null,
          ),
          body: Center(child: Text('No tracks', style: Theme.of(context).textTheme.bodyLarge)),
        ),
        loaded: (artist) => Scaffold(
          appBar: BasementAppBar(
            title: artist.name,
            actions: isAdmin
                ? [IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => context.go(RouteName.artistEdit(artistId)))]
                : null,
          ),
          body: HorizontalSpaceReducer(
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, _) => const Divider(height: 1),
                    itemCount: artist.tracks?.length ?? 0,
                    itemBuilder: (context, index) => TrackCard(
                      track: artist.tracks?[index] ?? Track.empty(),
                      containingPlaylist: Playlist.anonymous(artist.tracks ?? []),
                      openedPlaylist: Playlist.anonymous(artist.tracks ?? []),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        error: () => Scaffold(
          appBar: BasementAppBar(title: ''),
          body: const Center(child: Text('Error loading artist')),
        ),
      ),
    );
  }
}
