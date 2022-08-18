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

  @override
  void initState() {
    super.initState();

    fieldFocusNode.requestFocus();

    createPlaylistBloc = BlocProvider.of<PlaylistCreationBloc>(context);
    createPlaylistBloc.add(GetInputEvent());

    titleController.addListener(() {
      if (createPlaylistBloc.state is InputErrorState) {
        createPlaylistBloc.add(GetInputEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<PlaylistCreationBloc, PlaylistCreationState>(
        builder: (context, state) {
          if (state is WaitingCreationState) {
            return CircularProgressIndicator();
          }

          if (state is CreatedState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Playlist was successfully created'),
            );
          }

          if (state is CreationErrorState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Playlist was not created, please try again later'),
            );
          }

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
              if (state is InputErrorState)
                Text(
                  state.errorText,
                  style: TextStyle(color: Colors.red),
                )
              else
                const SizedBox(height: 20),
              const SizedBox(height: 20),
              Container(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    'Create',
                    style: _textStyle,
                  ),
                  onPressed: state is InputErrorState
                      ? () {}
                      : () async => createPlaylistBloc.add(
                            LoadingEvent(titleController.text),
                          ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
