import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/connectivity_status_bloc/connectivity_status_cubit.dart';
import '../bloc/trackst_search_cubit/tracks_search_cubit.dart';
import '../repositories/connectivity_status_repository.dart';
import '../repositories/playlists_repository.dart';
import '../repositories/tracks_repository.dart';
import '../widgets/app_bar.dart';
import '../widgets/search_field.dart';
import '../widgets/track_card.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TracksSearchCubit(
        tracksRepository: context.read<TracksRepository>(),
        playlistsRepository: context.read<PlaylistsRepository>(),
        connectivityStatusRepository:
            context.read<ConnectivityStatusRepository>(),
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
      appBar: BasementAppBar(title: 'Search tracks'),
      body: Column(
        children: [
          SearchField(
            autofocus: true,
            onSearch: (query) =>
                context.read<TracksSearchCubit>().onSearch(query),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: BlocBuilder<TracksSearchCubit, TracksSearchState>(
              builder: (_, state) {
                if (state is TracksSearchLoadInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TracksSearchSuccessEmpty) {
                  return const Center(child: Text('No tracks found'));
                }

                if (state is TracksSearchSuccess) {
                  return BlocBuilder<ConnectivityStatusCubit,
                      ConnectivityStatusState>(
                    builder: (_, connectivityState) {
                      return ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemCount: state.tracks.length,
                        itemBuilder: (_, index) => TrackCard(
                          track: state.tracks[index],
                          openedPlaylist:
                              context.read<TracksSearchCubit>().openedPlaylist,
                          active: connectivityState
                              is ConnectivityStatusHasConnection,
                        ),
                      );
                    },
                  );
                }

                if (state is TracksSearchError) {
                  return const Center(child: Text('Error searching tracks'));
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
