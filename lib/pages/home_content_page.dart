import 'package:basement_music/widgets/buttons/underlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_content_cubit/home_content_cubit.dart';
import '../bloc/tracks_bloc/tracks_bloc.dart';
import '../bloc/tracks_bloc/tracks_state.dart';
import '../widgets/track_card.dart';

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeContentCubit = BlocProvider.of<HomeContentCubit>(context);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: BlocBuilder<HomeContentCubit, HomeContentState>(
          builder: (context, state) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UnderlinedButton(
                      text: 'Recently played',
                      onPressed: () => homeContentCubit.selectSection(HomeContentSection.recentlyPlayed),
                      underlined: state.section == HomeContentSection.recentlyPlayed,
                    ),
                    const SizedBox(width: 20),
                    UnderlinedButton(
                      text: 'New uploads',
                      onPressed: () => homeContentCubit.selectSection(HomeContentSection.newUploads),
                      underlined: state.section == HomeContentSection.newUploads,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
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
                        child: ListView.separated(
                          separatorBuilder: (context, _) => const Divider(height: 1),
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          itemCount: state.tracks.length + 3,
                          itemBuilder: (context, index) {
                            if (index == 0 || index == state.tracks.length + 1) {
                              return const SizedBox.shrink();
                            }
                            if (index == state.tracks.length + 2) {
                              return const SizedBox(height: 40);
                            }
                            return TrackCard(track: state.tracks[index - 1]);
                          },
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
      ),
    );
  }
}
