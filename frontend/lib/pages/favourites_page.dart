import 'package:basement_music/bloc/favourites_cubit/favourites_cubit.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:basement_music/widgets/track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      child: Scaffold(
        appBar: BasementAppBar(title: 'Favourites'),
        body: HorizontalSpaceReducer(
          child: BlocBuilder<FavouritesCubit, FavouritesState>(
            builder: (context, state) => state.when(
              initial: () => const SizedBox.shrink(),
              loadInProgress: () => const Center(child: CircularProgressIndicator()),
              loaded: (tracks, _, _, _) => tracks.isEmpty
                  ? const Center(child: Text('No favourites yet'))
                  : ListView.separated(
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemCount: tracks.length,
                      itemBuilder: (_, i) => TrackCard(
                        track: tracks[i],
                        openedPlaylist: Playlist.favourites(tracks),
                      ),
                    ),
              error: () => const Center(child: Text('Failed to load favourites')),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    final cubit = context.read<FavouritesCubit>();
    final newState = cubit.stream.first;
    cubit.loadFavourites();
    await newState;
  }
}
