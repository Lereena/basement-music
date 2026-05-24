import 'package:basement_music/bloc/favourites_cubit/favourites_cubit.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:basement_music/widgets/track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasementAppBar(title: 'Favourites'),
      body: BlocBuilder<FavouritesCubit, FavouritesState>(
        builder: (context, state) => state.when(
          initial: () => const SizedBox.shrink(),
          loadInProgress: () => const Center(child: CircularProgressIndicator()),
          loaded: (tracks) => tracks.isEmpty
              ? const Center(child: Text('No favourites yet'))
              : ListView.builder(
                  itemCount: tracks.length,
                  itemBuilder: (_, i) => TrackCard(track: tracks[i]),
                ),
          error: () => const Center(child: Text('Failed to load favourites')),
        ),
      ),
    );
  }
}
