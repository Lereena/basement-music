import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/track_from_playlist_remover_bloc/track_from_playlist_remover_bloc.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repositories/repositories.dart';
import '../icons/error_icon.dart';
import '../icons/success_icon.dart';
import 'dialog.dart';

class RemoveFromPlaylistDialog extends StatelessWidget {
  final Track track;
  final Playlist playlist;

  const RemoveFromPlaylistDialog._({
    required this.track,
    required this.playlist,
  });

  static Future<void> show({
    required BuildContext context,
    required Track track,
    required Playlist playlist,
  }) =>
      showDialog(
        context: context,
        builder: (_) => BlocProvider(
          create: (_) => TrackFromPlaylistRemoverBloc(
            tracksRepository: context.read<TracksRepository>(),
            playlistsRepository: context.read<PlaylistsRepository>(),
            trackId: track.id,
            playlistId: playlist.id,
          ),
          child: RemoveFromPlaylistDialog._(track: track, playlist: playlist),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      width: SizerUtil.deviceType == DeviceType.mobile ? 80.w : 40.w,
      height: SizerUtil.deviceType == DeviceType.mobile ? 50.h : 30.h,
      child: BlocBuilder<TrackFromPlaylistRemoverBloc,
          TrackFromPlaylistRemoverState>(
        builder: (context, state) {
          if (state is RemoveFromPlaylistInitial) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Do you want to remove ',
                    children: [
                      TextSpan(
                        text: track.title,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const TextSpan(text: ' from '),
                      TextSpan(
                        text: '${playlist.title} ',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const TextSpan(text: 'playlist?'),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () =>
                      context.read<TrackFromPlaylistRemoverBloc>().add(
                            TrackFromPlaylistRemoverConfirmed(
                              track.id,
                              playlist.id,
                            ),
                          ),
                  child: const Text('Remove'),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            );
          }

          if (state is TrackFromPlaylistRemoverLoadingInProgress) {
            return const CircularProgressIndicator();
          }

          if (state is TrackFromPlaylistRemoverSuccess) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SuccessIcon(),
                const SizedBox(height: 20),
                const Text('Track is successfully removed from playlist'),
              ],
            );
          }

          if (state is TrackFromPlaylistRemoverError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ErrorIcon(),
                const SizedBox(height: 20),
                const Text('Error removing track from playlist'),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }
}
