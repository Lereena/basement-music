import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cacher_bloc/cacher_bloc.dart';

class CacheAllTracksSettingsLine extends StatelessWidget {
  const CacheAllTracksSettingsLine({super.key});

  @override
  Widget build(BuildContext context) {
    final cacherBloc = context.read<CacherBloc>();

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
                children: [
                  ElevatedButton(
                    onPressed: state.cached.length == state.available
                        ? null
                        : () => cacherBloc
                            .add(CacherCacheAllAvailableTracksStarted()),
                    child:
                        const Text('Cache all available tracks', maxLines: 2),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: state.cached.isEmpty
                        ? null
                        : () => cacherBloc.add(CacherClearingStarted()),
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
}
