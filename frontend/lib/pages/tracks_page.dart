import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_content_cubit/home_content_cubit.dart';
import '../bloc/tracks_bloc/tracks_bloc.dart';
import '../bloc/tracks_bloc/tracks_event.dart';
import '../bloc/tracks_bloc/tracks_state.dart';
import '../models/track.dart';
import '../widgets/track_card.dart';

class TracksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      child: BlocBuilder<HomeContentCubit, HomeContentState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<TracksBloc, TracksState>(
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
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.tracks.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.tracks.length) {
                            return const SizedBox(height: 40);
                          }
                          return Column(
                            children: [
                              TrackCard(track: state.tracks[index]),
                              const Divider(height: 1),
                            ],
                          );
                        },
                        prototypeItem: Column(
                          children: [
                            TrackCard(track: Track.empty()),
                            const Divider(height: 1),
                          ],
                        ),
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
            ],
          );
        },
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    final tracksBloc = context.read<TracksBloc>();

    final newState = tracksBloc.stream.first;
    tracksBloc.add(TracksLoadEvent());
    await newState;
  }
}
