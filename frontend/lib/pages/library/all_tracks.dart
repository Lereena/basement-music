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
            builder: (context, state) => RefreshIndicator(
              onRefresh: () => context.read<TracksCubit>().loadTracks(),
              child: state.when(
                loadInProgress: () => const ScrollablePlaceholder(child: CircularProgressIndicator()),
                empty: () => const ScrollablePlaceholder(child: Text('No tracks')),
                loaded: (tracks) => ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemCount: tracks.length,
                  itemBuilder: (_, i) => TrackCard(track: tracks[i], active: active),
                ),
                error: () => const ScrollablePlaceholder(child: Text('Error loading tracks')),
              ),
            ),
          );
        },
      ),
    );
  }
}
