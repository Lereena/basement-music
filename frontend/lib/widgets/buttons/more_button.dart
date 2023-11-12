import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cacher_bloc/cacher_bloc.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../dialogs/add_to_playlist_dialog.dart';
import '../dialogs/remove_from_playlist_dialog.dart';
import '../edit_track.dart';

class MoreButton extends StatelessWidget {
  final Track track;
  final Playlist? playlist;

  const MoreButton({super.key, required this.track, this.playlist});

  @override
  Widget build(BuildContext context) {
    final cacherBloc = context.read<CacherBloc>();

    return InkWell(
      child: const Icon(Icons.more_vert),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            children: [
              SimpleDialogOption(
                child: const Text('Edit track info'),
                onPressed: () {
                  Navigator.pop(context);
                  EditTrack.show(context: context, track: track);
                },
              ),
              const Divider(),
              SimpleDialogOption(
                child: const Text('Add to playlist'),
                onPressed: () {
                  Navigator.pop(context);
                  AddToPlaylistDialog.show(context: context, trackId: track.id);
                },
              ),
              if (playlist != null) ...[
                const Divider(),
                SimpleDialogOption(
                  child: const Text('Remove from playlist'),
                  onPressed: () {
                    Navigator.pop(context);
                    RemoveFromPlaylistDialog.show(
                      context: context,
                      track: track,
                      playlist: playlist!,
                    );
                  },
                ),
              ],
              if (!kIsWeb && !cacherBloc.state.cached.contains(track.id)) ...[
                const Divider(),
                SimpleDialogOption(
                  child: const Text('Cache track'),
                  onPressed: () {
                    cacherBloc.add(CacherTracksCachingStarted([track.id]));
                    Navigator.pop(context);
                  },
                ),
              ],
              if (!kIsWeb && cacherBloc.state.cached.contains(track.id)) ...[
                const Divider(),
                SimpleDialogOption(
                  child: const Text('Remove from cache'),
                  onPressed: () {
                    cacherBloc
                        .add(CacherRemoveTracksFromCacheStarted([track.id]));
                    Navigator.pop(context);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
