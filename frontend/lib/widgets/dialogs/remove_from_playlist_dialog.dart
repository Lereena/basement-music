import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/remove_from_playlist_bloc/remove_from_playlist_cubit.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../icons/error_icon.dart';
import '../icons/success_icon.dart';
import 'dialog.dart';

class RemoveFromPlaylistDialog extends StatefulWidget {
  final Track track;
  final Playlist? playlist;

  const RemoveFromPlaylistDialog({
    super.key,
    required this.track,
    required this.playlist,
  });

  @override
  State<RemoveFromPlaylistDialog> createState() => _RemoveFromPlaylistDialogState();
}

class _RemoveFromPlaylistDialogState extends State<RemoveFromPlaylistDialog> {
  late final RemoveFromPlaylistBloc _removeFromPlaylistBloc;

  @override
  void initState() {
    super.initState();
    _removeFromPlaylistBloc = BlocProvider.of<RemoveFromPlaylistBloc>(context);
    _removeFromPlaylistBloc.add(TrackChoosen(widget.track.id, widget.playlist?.id));
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      width: SizerUtil.deviceType == DeviceType.mobile ? 80.w : 40.w,
      height: SizerUtil.deviceType == DeviceType.mobile ? 50.h : 30.h,
      child: BlocBuilder<RemoveFromPlaylistBloc, RemoveFromPlaylistState>(
        builder: (context, state) {
          if (state is RemoveFromPlaylistWaitingConfirmation) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Do you want to remove ',
                    children: [
                      TextSpan(
                        text: widget.track.title,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const TextSpan(text: ' from '),
                      if (widget.playlist != null)
                        TextSpan(
                          text: '${widget.playlist?.title} ',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      const TextSpan(text: 'playlist?'),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () =>
                      _removeFromPlaylistBloc.add(ConfirmationReceived(widget.track.id, widget.playlist?.id)),
                  child: const Text('Remove'),
                ),
                const SizedBox(height: 15),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ],
            );
          }

          if (state is RemoveFromPlaylistLoading) {
            return const CircularProgressIndicator();
          }

          if (state is RemoveFromPlaylistRemoved) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SuccessIcon(),
                const SizedBox(height: 20),
                const Text('Track is successfully removed from playlist'),
              ],
            );
          }

          if (state is RemoveFromPlaylistError) {
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
