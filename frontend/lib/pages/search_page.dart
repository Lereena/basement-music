import 'package:basement_music/bloc/connectivity_status_cubit/connectivity_status_cubit.dart';
import 'package:basement_music/bloc/tracks_search_cubit/tracks_search_cubit.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:basement_music/widgets/search_field.dart';
import 'package:basement_music/widgets/track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TracksSearchCubit(
        tracksRepository: context.read<TracksRepository>(),
        playlistsRepository: context.read<PlaylistsRepository>(),
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
      appBar: BasementAppBar(title: 'Search tracks', scrolledUnderElevation: 0),
      body: HorizontalSpaceReducer(
        child: Column(
          children: [
            SearchField(autofocus: true, onSearch: (query) => context.read<TracksSearchCubit>().onSearch(query)),
            const SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<TracksSearchCubit, TracksSearchState>(
                builder: (_, state) => state.when(
                  initial: () => const SizedBox.shrink(),
                  loadInProgress: (_) => const Center(child: CircularProgressIndicator()),
                  successEmpty: (_) => const Center(child: Text('No tracks found')),
                  success: (_, tracks) => BlocBuilder<ConnectivityStatusCubit, ConnectivityStatusState>(
                    builder: (_, connectivityState) => ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemCount: tracks.length,
                      itemBuilder: (_, index) => TrackCard(
                        track: tracks[index],
                        openedPlaylist: context.read<TracksSearchCubit>().openedPlaylist,
                        active: connectivityState.maybeWhen(hasConnection: () => true, orElse: () => false),
                      ),
                    ),
                  ),
                  error: () => const Center(child: Text('Error searching tracks')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
