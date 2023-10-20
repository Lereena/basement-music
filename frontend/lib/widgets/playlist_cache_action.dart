import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cacher_bloc/cacher_bloc.dart';
import 'buttons/cache_button.dart';
import 'buttons/uncache_button.dart';
import 'dialogs/yes_or_cancel_dialog.dart';

class PlaylistCacheAction extends StatelessWidget {
  final List<String> trackIds;

  const PlaylistCacheAction({super.key, required this.trackIds});

  @override
  Widget build(BuildContext context) {
    final cacherBloc = context.read<CacherBloc>();

    return BlocBuilder<CacherBloc, CacherState>(
      builder: (context, state) {
        if (state.isCaching(trackIds)) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CacheButton(
                onCache: () async {
                  if (await _showCacheDialog(context)) {
                    cacherBloc.add(CacheTracksEvent(trackIds));
                  }
                },
              ),
              CircularProgressIndicator(
                color: Theme.of(context).shadowColor,
              ),
            ],
          );
        }

        if (state.isCached(trackIds)) {
          return UncacheButton(
            onUncache: () async {
              if (await _showUncacheDialog(context)) {
                cacherBloc.add(UncacheTracksEvent(trackIds));
              }
            },
          );
        }

        return CacheButton(
          onCache: () async {
            if (await _showCacheDialog(context)) {
              cacherBloc.add(CacheTracksEvent(trackIds));
            }
          },
        );
      },
    );
  }

  Future<bool> _showCacheDialog(BuildContext context) async {
    const title = 'Do you want to cache all playlist tracks?';

    return await showDialog(
          context: context,
          builder: (context) => const YesOrCancelDialog(title: title),
        ) as bool? ??
        false;
  }

  Future<bool> _showUncacheDialog(BuildContext context) async {
    const title = 'Do you want to remove all playlist tracks from cache?';

    return await showDialog(
          context: context,
          builder: (context) => const YesOrCancelDialog(title: title),
        ) as bool? ??
        false;
  }
}
