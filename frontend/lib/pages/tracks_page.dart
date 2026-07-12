import 'package:basement_music/bloc/connectivity_status_cubit/connectivity_status_cubit.dart';
import 'package:basement_music/bloc/tracks_cubit/tracks_cubit.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:basement_music/theme/theme.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/widgets/track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TracksPage extends StatelessWidget {
  const TracksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TracksCubit(
        tracksRepository: context.read<TracksRepository>(),
        connectivityStatusRepository: context.read<ConnectivityStatusRepository>(),
      )..loadTracks(),
      child: _TracksPage(),
    );
  }
}

class _TracksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      child: BlocBuilder<ConnectivityStatusCubit, ConnectivityStatusState>(
        builder: (context, connectivityStatus) {
          return Scaffold(
            body: SafeArea(
              child: HorizontalSpaceReducer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<TracksCubit, TracksState>(
                      builder: (context, state) => state.when(
                        loadInProgress: () => const Center(child: CircularProgressIndicator()),
                        empty: () => const Center(child: Text('No tracks')),
                        loaded: (tracks) => Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xxxl),
                            itemCount: tracks.length,
                            itemBuilder: (context, index) => TrackCard(
                              track: tracks[index],
                              active: connectivityStatus.maybeWhen(hasConnection: () => true, orElse: () => false),
                            ),
                            prototypeItem: TrackCard(track: Track.empty()),
                          ),
                        ),
                        error: () => const Center(child: Text('Error loading tracks')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    final cubit = context.read<TracksCubit>();
    final newState = cubit.stream.first;
    cubit.loadTracks();
    await newState;
  }
}
