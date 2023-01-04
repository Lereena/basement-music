import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_content_cubit/home_content_cubit.dart';
import '../bloc/tracks_bloc/tracks_bloc.dart';
import '../bloc/tracks_bloc/tracks_state.dart';
import '../models/track.dart';
import '../widgets/buttons/underlined_button.dart';
import '../widgets/track_card.dart';

class TracksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeContentCubit = BlocProvider.of<HomeContentCubit>(context);

    return Padding(
      padding: kIsWeb ? const EdgeInsets.only(top: 60) : EdgeInsets.zero,
      child: BlocBuilder<HomeContentCubit, HomeContentState>(
        builder: (context, state) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UnderlinedButton(
                    text: 'All tracks', //'Recently played',
                    onPressed: () => homeContentCubit.selectSection(HomeContentSection.recentlyPlayed),
                    underlined: state.section == HomeContentSection.recentlyPlayed,
                  ),
                  // const SizedBox(width: 20),
                  // UnderlinedButton(
                  //   text: 'New uploads',
                  //   onPressed: () => homeContentCubit.selectSection(HomeContentSection.newUploads),
                  //   underlined: state.section == HomeContentSection.newUploads,
                  // ),
                ],
              ),
              if (kIsWeb) const SizedBox(height: 40) else const SizedBox(height: 10),
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
}
