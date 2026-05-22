import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:basement_music/bloc/artist_cubit/artist_cubit.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:basement_music/widgets/track_card.dart';

class ArtistPage extends StatelessWidget {
  final String artistId;

  const ArtistPage({super.key, required this.artistId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArtistCubit(
        artistsRepository: context.read<ArtistsRepository>(),
        artistId: artistId,
      )..loadArtist(),
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
        initial: () => const SizedBox.shrink(),
        loadInProgress: () => const Center(child: CircularProgressIndicator()),
        loadedEmpty: (name) => Scaffold(
          appBar: BasementAppBar(
            title: name,
            // actions: _appBarActions(),
          ),
          body: Center(
            child: Text(
              'No tracks',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        loaded: (artist) => Scaffold(
          appBar: BasementAppBar(
            title: artist.name,
            //   actions: _appBarActions(
            //     tracksIds: state.playlist.tracks.map((e) => e.id).toList(),
            //   ),
          ),
          body: Column(
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
        error: () => Scaffold(
          appBar: BasementAppBar(title: ''),
          body: const Center(child: Text('Error loading artist')),
        ),
      ),
    );
  }

  // List<Widget> _appBarActions({List<String>? tracksIds}) => [
  //       if (!kIsWeb && Platform.isAndroid && tracksIds != null) PlaylistCacheAction(trackIds: tracksIds),
  //       Builder(
  //         builder: (context) {
  //           return IconButton(
  //             onPressed: () => context.go(RouteName.playlistEdit(playlistId)),
  //             icon: const Icon(Icons.edit_outlined),
  //           );
  //         },
  //       ),
  //     ];
}
