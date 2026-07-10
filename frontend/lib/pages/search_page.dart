import 'package:basement_music/bloc/connectivity_status_cubit/connectivity_status_cubit.dart';
import 'package:basement_music/bloc/search_cubit/search_cubit.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:basement_music/routing/routes.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:basement_music/widgets/artist_card.dart';
import 'package:basement_music/widgets/playlist_card.dart';
import 'package:basement_music/widgets/search_field.dart';
import 'package:basement_music/widgets/track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(
        tracksRepository: context.read<TracksRepository>(),
        playlistsRepository: context.read<PlaylistsRepository>(),
        artistsRepository: context.read<ArtistsRepository>(),
        connectivityStatusRepository: context.read<ConnectivityStatusRepository>(),
      ),
      child: const _SearchPage(),
    );
  }
}

class _SearchPage extends StatelessWidget {
  const _SearchPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasementAppBar(title: 'Search', scrolledUnderElevation: 0),
      body: HorizontalSpaceReducer(
        child: Column(
          children: [
            SearchField(autofocus: true, onSearch: (query) => context.read<SearchCubit>().onSearch(query)),
            const SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (_, state) => state.when(
                  initial: () => const SizedBox.shrink(),
                  loadInProgress: (_) => const Center(child: CircularProgressIndicator()),
                  successEmpty: (_) => const Center(child: Text('Nothing found')),
                  success: (_, artists, playlists, tracks) =>
                      _Results(artists: artists, playlists: playlists, tracks: tracks),
                  error: () => const Center(child: Text('Error searching')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  final List<Artist> artists;
  final List<Playlist> playlists;
  final List<Track> tracks;

  const _Results({required this.artists, required this.playlists, required this.tracks});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityStatusCubit, ConnectivityStatusState>(
      builder: (context, connectivityState) {
        final active = connectivityState.maybeWhen(hasConnection: () => true, orElse: () => false);
        final openedPlaylist = context.read<SearchCubit>().openedPlaylist;

        return ListView(
          children: [
            if (artists.isNotEmpty) ...[
              const _SectionHeader(title: 'Artists'),
              SizedBox(
                height: 170,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemCount: artists.length,
                  itemBuilder: (_, index) => SizedBox(
                    width: 150,
                    child: ArtistCard(
                      artist: artists[index],
                      onTap: () => context.go(RouteName.artist(artists[index].id)),
                    ),
                  ),
                ),
              ),
            ],
            if (playlists.isNotEmpty) ...[
              const _SectionHeader(title: 'Playlists'),
              ...playlists.map(
                (playlist) => PlaylistCard(
                  playlist: playlist,
                  onTap: () => context.go(RouteName.playlist(playlist.id)),
                ),
              ),
            ],
            if (tracks.isNotEmpty) ...[
              const _SectionHeader(title: 'Tracks'),
              ...tracks.map(
                (track) => TrackCard(track: track, openedPlaylist: openedPlaylist, active: active),
              ),
            ],
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
