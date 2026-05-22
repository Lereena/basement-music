import 'package:basement_music/bloc/cacher_cubit/cacher_cubit.dart';
import 'package:basement_music/widgets/buttons/cache_button.dart';
import 'package:basement_music/widgets/buttons/uncache_button.dart';
import 'package:basement_music/widgets/dialogs/confirm_action_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistCacheAction extends StatelessWidget {
  final List<String> trackIds;

  const PlaylistCacheAction({super.key, required this.trackIds});

  @override
  Widget build(BuildContext context) {
    final cacherCubit = context.read<CacherCubit>();

    return BlocBuilder<CacherCubit, CacherState>(
      builder: (context, state) {
        if (state.isCaching(trackIds)) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CacheButton(
                onCache: () async {
                  if (await _showCacheDialog(context)) {
                    cacherCubit.cacheTrackIds(trackIds);
                  }
                },
              ),
              CircularProgressIndicator(color: Theme.of(context).shadowColor),
            ],
          );
        }

        if (state.isCached(trackIds)) {
          return UncacheButton(
            onUncache: () async {
              if (await _showRemoveFromCacheDialog(context)) {
                cacherCubit.removeTrackIds(trackIds);
              }
            },
          );
        }

        return CacheButton(
          onCache: () async {
            if (await _showCacheDialog(context)) {
              cacherCubit.cacheTrackIds(trackIds);
            }
          },
        );
      },
    );
  }

  Future<bool> _showCacheDialog(BuildContext context) =>
      ConfirmActionDialog.show(context: context, title: 'Do you want to cache all playlist tracks?');

  Future<bool> _showRemoveFromCacheDialog(BuildContext context) =>
      ConfirmActionDialog.show(context: context, title: 'Do you want to remove all playlist tracks from cache?');
}
