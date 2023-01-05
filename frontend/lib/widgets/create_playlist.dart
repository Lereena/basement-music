import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../bloc/playlist_creation_bloc/playlist_creation_bloc.dart';
import '../bloc/playlist_creation_bloc/playlist_creation_event.dart';
import '../bloc/playlist_creation_bloc/playlist_creation_state.dart';
import 'titled_field.dart';

class CreatePlaylist extends StatefulWidget {
  const CreatePlaylist({super.key});

  @override
  State<CreatePlaylist> createState() => _CreatePlaylistState();
}

const _textStyle = TextStyle(fontSize: 18);

class _CreatePlaylistState extends State<CreatePlaylist> {
  late final PlaylistCreationBloc createPlaylistBloc;
  final titleController = TextEditingController();
  final fieldFocusNode = FocusNode();

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
            return const CircularProgressIndicator();
          }

          if (state is CreatedState) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Playlist was successfully created'),
            );
          }

          if (state is CreationErrorState) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Playlist was not created, please try again later'),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Create new playlist',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              TitledField(
                title: 'Title',
                controller: titleController,
                fieldWidth: min(40.w, 400),
                focusNode: fieldFocusNode,
                onSubmitted: (_) => createPlaylistBloc.add(
                  LoadingEvent(titleController.text),
                ),
              ),
              const SizedBox(height: 20),
              if (state is InputErrorState)
                Text(
                  state.errorText,
                  style: const TextStyle(color: Colors.red),
                )
              else
                const SizedBox(height: 20),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  onPressed: state is InputErrorState
                      ? () {}
                      : () async => createPlaylistBloc.add(
                            LoadingEvent(titleController.text),
                          ),
                  child: const Text(
                    'Create',
                    style: _textStyle,
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
