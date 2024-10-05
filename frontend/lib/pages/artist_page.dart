import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/artist_bloc/artist_cubit.dart';
import '../bloc/playlist_bloc/playlist_bloc.dart';
import '../models/track.dart';
import '../repositories/artists_repository.dart';
import '../widgets/app_bar.dart';
import '../widgets/track_card.dart';

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
      builder: (context, state) {
        if (state is ArtistLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ArtistLoadedEmpty) {
          return Scaffold(
            appBar: BasementAppBar(
              title: state.name,
              // actions: _appBarActions(),
            ),
            body: Center(
              child: Text(
                'No tracks',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        if (state is ArtistLoaded) {
          return Scaffold(
            appBar: BasementAppBar(
              title: state.artist.name,
              //   actions: _appBarActions(
              //     tracksIds: state.playlist.tracks.map((e) => e.id).toList(),
              //   ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, _) => const Divider(height: 1),
                    itemCount: state.artist.tracks?.length ?? 0,
                    itemBuilder: (context, index) => TrackCard(
                      track: state.artist.tracks?[index] ?? Track.empty(),
                      // containingPlaylist: null,
                      // openedPlaylist: null,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is PlaylistError) {
          return Scaffold(
            appBar: BasementAppBar(
              title: '',
            ),
            body: const Center(child: Text('Error loading artist')),
          );
        }

        return const SizedBox.shrink();
      },
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
