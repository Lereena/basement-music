import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/add_to_playlist_bloc/add_to_playlist_bloc.dart';
import '../icons/error_icon.dart';
import '../icons/success_icon.dart';
import 'dialog.dart';

class AddToPlaylistDialog extends StatefulWidget {
  final String trackId;

  const AddToPlaylistDialog({super.key, required this.trackId});

  @override
  State<AddToPlaylistDialog> createState() => _AddToPlaylistDialogState();
}

class _AddToPlaylistDialogState extends State<AddToPlaylistDialog> {
  late final AddToPlaylistBloc _addToPlaylistBloc;

  @override
  void initState() {
    super.initState();
    _addToPlaylistBloc = BlocProvider.of<AddToPlaylistBloc>(context);
    _addToPlaylistBloc.add(TrackChoosen(widget.trackId));
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      width: SizerUtil.deviceType == DeviceType.mobile ? 80.w : 40.w,
      height: 50.h,
      child: BlocBuilder<AddToPlaylistBloc, AddToPlaylistState>(
        builder: (context, state) {
          if (state is ChoosePlaylist) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Choose playlist',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const Divider(
                  height: 1.5,
                  indent: 10,
                  endIndent: 10,
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.playlists.length,
                    separatorBuilder: (context, _) => const Divider(
                      height: 1.5,
                      indent: 10,
                      endIndent: 10,
                    ),
                    itemBuilder: (context, index) => SimpleDialogOption(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: Text(state.playlists[index].title),
                      onPressed: () => _addToPlaylistBloc.add(
                        PlaylistChoosen(
                          widget.trackId,
                          state.playlists[index].id,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }

          if (state is Loading) {
            return const CircularProgressIndicator();
          }

          if (state is Added) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SuccessIcon(),
                const SizedBox(height: 20),
                const Text('Track is successfully added to playlist'),
              ],
            );
          }

          if (state is Error) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ErrorIcon(),
                const SizedBox(height: 20),
                const Text('Error adding track to playlist'),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }
}
