import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/add_to_playlist_bloc/add_to_playlist_bloc.dart';
import '../widgets/dialog.dart';
import '../widgets/icons/error_icon.dart';
import '../widgets/icons/success_icon.dart';

class AddToPlaylistDialog extends StatefulWidget {
  final String trackId;

  const AddToPlaylistDialog({Key? key, required this.trackId}) : super(key: key);

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
      padding: const EdgeInsets.all(0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.7,
        child: BlocBuilder<AddToPlaylistBloc, AddToPlaylistState>(
          builder: (context, state) {
            if (state is ChoosePlaylist) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text('Choose playlist'),
                  ),
                  const Divider(height: 1.5),
                  Expanded(
                    child: ListView.separated(
                        itemCount: state.playlists.length,
                        separatorBuilder: (context, _) => const Divider(height: 1.5),
                        itemBuilder: (context, index) {
                          return SimpleDialogOption(
                            child: Text(state.playlists[index].title),
                            onPressed: () => _addToPlaylistBloc.add(
                              PlaylistChoosen(
                                widget.trackId,
                                state.playlists[index].id,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }

            if (state is Loading) {
              return CircularProgressIndicator();
            }

            if (state is Added) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SuccessIcon(),
                  SizedBox(height: 20),
                  Text('Track is successfully added to playlist'),
                ],
              );
            }

            if (state is Error) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ErrorIcon(),
                  SizedBox(height: 20),
                  Text('Error adding track to playlist'),
                ],
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
