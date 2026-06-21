part of 'library_page.dart';

class _AllTracks extends StatelessWidget {
  const _AllTracks();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TracksCubit(
        tracksRepository: context.read<TracksRepository>(),
        connectivityStatusRepository: context.read<ConnectivityStatusRepository>(),
      )..loadTracks(),
      child: BlocBuilder<ConnectivityStatusCubit, ConnectivityStatusState>(
        builder: (context, connectivityStatus) {
          final active = connectivityStatus.maybeWhen(hasConnection: () => true, orElse: () => false);
          return BlocBuilder<TracksCubit, TracksState>(
            builder: (context, state) => state.when(
              loadInProgress: () => const Center(child: CircularProgressIndicator()),
              empty: () => const Center(child: Text('No tracks')),
              loaded: (tracks) => ListView.separated(
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemCount: tracks.length,
                itemBuilder: (_, i) => TrackCard(track: tracks[i], active: active),
              ),
              error: () => const Center(child: Text('Error loading tracks')),
            ),
          );
        },
      ),
    );
  }
}
