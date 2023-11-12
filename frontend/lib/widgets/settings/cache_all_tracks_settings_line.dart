import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cacher_bloc/cacher_bloc.dart';
import '../dialogs/confirm_action_dialog.dart';

class CacheAllTracksSettingsLine extends StatelessWidget {
  const CacheAllTracksSettingsLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: BlocBuilder<CacherBloc, CacherState>(
        builder: (_, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tracks cache',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text('Cached: ${state.cached.length}'),
              const SizedBox(height: 8),
              Text('Now caching: ${state.caching.length}'),
              const SizedBox(height: 8),
              Text('Available: ${state.available}'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (state.caching.isNotEmpty)
                    ElevatedButton(
                      onPressed: () => context
                          .read<CacherBloc>()
                          .add(CacherCachingStopped()),
                      child: const Text('Stop caching'),
                    )
                  else
                    ElevatedButton(
                      onPressed: state.cached.length == state.available
                          ? null
                          : () => _onCacheAllAvailableTracks(
                                context: context,
                                tracksCount:
                                    state.available - state.cached.length,
                              ),
                      child:
                          const Text('Cache all available tracks', maxLines: 2),
                    ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: state.cached.isEmpty
                        ? null
                        : () => _onClearCache(context: context),
                    child: const Text('Clear cache'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onCacheAllAvailableTracks({
    required BuildContext context,
    required int tracksCount,
  }) async {
    final isConfirmed = await ConfirmActionDialog.show(
      context: context,
      title: 'Do you want to cache $tracksCount tracks?',
    );

    if (context.mounted && isConfirmed) {
      context.read<CacherBloc>().add(CacherCacheAllAvailableTracksStarted());
    }
  }

  Future<void> _onClearCache({
    required BuildContext context,
  }) async {
    final isConfirmed = await ConfirmActionDialog.show(
      context: context,
      title: 'Do you want to remove all tracks from cache?',
    );

    if (context.mounted && isConfirmed) {
      context.read<CacherBloc>().add(CacherClearingStarted());
    }
  }
}
