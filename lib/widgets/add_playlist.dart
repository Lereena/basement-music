import 'package:basement_music/bloc/playlist_creation_bloc/playlist_creation_bloc.dart';
import 'package:basement_music/bloc/playlist_creation_bloc/playlist_creation_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/playlist_creation_bloc/playlist_creation_state.dart';
import '../utils/input_field_with.dart';
import 'titled_field.dart';

class AddPlaylist extends StatefulWidget {
  const AddPlaylist({Key? key}) : super(key: key);

  @override
  State<AddPlaylist> createState() => _AddPlaylistState();
}

const _textStyle = const TextStyle(fontSize: 18);

class _AddPlaylistState extends State<AddPlaylist> {
  late final PlaylistCreationBloc createPlaylistBloc;
  final titleController = TextEditingController();
  final fieldFocusNode = FocusNode();
  var loading = false;
  var error = '';

  @override
  void initState() {
    super.initState();

    fieldFocusNode.requestFocus();

    titleController.addListener(() {
      setState(() {
        error = '';
      });
    });

    createPlaylistBloc = BlocProvider.of<PlaylistCreationBloc>(context);
    createPlaylistBloc.add(GetInputEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<PlaylistCreationBloc, PlaylistCreationState>(builder: (context, state) {
        if (state is WaitingCreationState) {
          return CircularProgressIndicator();
        }

        if (state is GettingInputState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create new playlist',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              TitledField(
                title: 'Title: ',
                controller: titleController,
                fieldWidth: inputFieldWidth(context),
                focusNode: fieldFocusNode,
                onSubmitted: (_) async => createPlaylistBloc.add(
                  LoadingEvent(titleController.text),
                ),
              ),
              const SizedBox(height: 20),
              if (error.isEmpty)
                const SizedBox(height: 20)
              else
                Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              Container(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    'Create',
                    style: _textStyle,
                  ),
                  onPressed: () async => createPlaylistBloc.add(
                    LoadingEvent(titleController.text),
                  ),
                ),
              ),
            ],
          );
        }

        if (state is CreatedState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Playlist was successfully created'),
          );
        }

        if (state is ErrorState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Playlist was not created, please try again later'),
          );
        }

        return Container();
      }),
    );
  }

  bool _isValidInput(String title) {
    return title.isNotEmpty;
  }

  // void _onSubmitted() async {
  //   if (!_isValidInput(titleController.text)) {
  //     setState(() {
  //       error = 'Title must not be empty';
  //       fieldFocusNode.requestFocus();
  //     });
  //     return;
  //   }

  //   setState(() => loading = true);

  //   final requestResult = await createPlaylist(titleController.text);
  //   setState(() => loading = false);
  //   Navigator.pop(context);

  //   await showDialog(
  //     context: context,
  //     builder: (_) => StatusDialog(
  //       success: requestResult.result,
  //       text: requestResult.result
  //           ? 'Playlist was successfully created'
  //           : 'Playlist was not created, please try again later',
  //     ),
  //   );
  // }
}
