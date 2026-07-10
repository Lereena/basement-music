import 'package:basement_music/bloc/auth_cubit/auth_cubit.dart';
import 'package:basement_music/bloc/cacher_cubit/cacher_cubit.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/widgets/dialogs/add_to_playlist_dialog.dart';
import 'package:basement_music/widgets/dialogs/remove_from_playlist_dialog.dart';
import 'package:basement_music/widgets/dialogs/set_album_dialog.dart';
import 'package:basement_music/widgets/dialogs/set_track_artists_dialog.dart';
import 'package:basement_music/widgets/edit_track.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreButton extends StatelessWidget {
  final Track track;
  final Playlist? playlist;

  const MoreButton({super.key, required this.track, this.playlist});

  @override
  Widget build(BuildContext context) {
    final cacherCubit = context.read<CacherCubit>();
    final isAdmin = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (user) => user.isAdmin,
      orElse: () => false,
    );

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
              if (isAdmin) ...[
                const Divider(),
                SimpleDialogOption(
                  child: const Text('Change artist'),
                  onPressed: () {
                    Navigator.pop(context);
                    SetTrackArtistsDialog.show(context: context, track: track);
                  },
                ),
                const Divider(),
                SimpleDialogOption(
                  child: const Text('Set album'),
                  onPressed: () {
                    Navigator.pop(context);
                    SetAlbumDialog.show(context: context, trackId: track.id);
                  },
                ),
              ],
              if (playlist != null) ...[
                const Divider(),
                SimpleDialogOption(
                  child: const Text('Remove from playlist'),
                  onPressed: () {
                    Navigator.pop(context);
                    RemoveFromPlaylistDialog.show(context: context, track: track, playlist: playlist!);
                  },
                ),
              ],
              if (!kIsWeb && !cacherCubit.state.cached.contains(track.id)) ...[
                const Divider(),
                SimpleDialogOption(
                  child: const Text('Cache track'),
                  onPressed: () {
                    cacherCubit.cacheTrackIds([track.id]);
                    Navigator.pop(context);
                  },
                ),
              ],
              if (!kIsWeb && cacherCubit.state.cached.contains(track.id)) ...[
                const Divider(),
                SimpleDialogOption(
                  child: const Text('Remove from cache'),
                  onPressed: () {
                    cacherCubit.removeTrackIds([track.id]);
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
