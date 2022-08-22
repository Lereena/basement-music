import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tracks_bloc/tracks_bloc.dart';
import '../bloc/tracks_bloc/tracks_state.dart';
import '../widgets/track_card.dart';

class AllTracksPage extends StatelessWidget {
  const AllTracksPage() : super();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<TracksBloc, TracksState>(
        builder: (context, state) {
          if (state is TracksLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TracksEmptyState) {
            return const Center(
              child: Text('No tracks'),
            );
          }

          if (state is TracksLoadedState) {
            return ListView.separated(
              separatorBuilder: (context, _) => const Divider(height: 1),
              itemCount: state.tracks.length,
              itemBuilder: (context, index) => TrackCard(
                track: state.tracks[index],
              ),
            );
          }

          if (state is TracksErrorState) {
            return const Center(
              child: Text('Error loading tracks'),
            );
          }

          return Container();
        },
      ),
    );
  }
}
