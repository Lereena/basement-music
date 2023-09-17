import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../bloc/edit_track_bloc/edit_track_bloc.dart';
import '../models/track.dart';
import 'buttons/styled_button.dart';

class EditTrack extends StatefulWidget {
  final Track track;

  const EditTrack({
    super.key,
    required this.track,
  });

  @override
  State<EditTrack> createState() => _EditTrackState();
}

class _EditTrackState extends State<EditTrack> {
  late final EditTrackBloc editTrackBloc;

  final titleController = TextEditingController();
  final artistController = TextEditingController();
  final titleFocusNode = FocusNode();
  final artistFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    editTrackBloc = BlocProvider.of<EditTrackBloc>(context);
    editTrackBloc.add(GetInputEvent());

    titleController.text = widget.track.title;
    artistController.text = widget.track.artist;
    artistFocusNode.requestFocus();

    titleController.addListener(_removeError);
    artistController.addListener(_removeError);
  }

  void _removeError() {
    if (editTrackBloc.state is InputErrorState) {
      editTrackBloc.add(GetInputEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<EditTrackBloc, EditTrackState>(
        builder: (context, state) {
          if (state is WaitingEditingState) {
            return const CircularProgressIndicator();
          }

          if (state is EditedState) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Track was successfully edited'),
            );
          }

          if (state is EditingErrorState) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Track was not edited, please try again later'),
            );
          }

          return SizedBox(
            width: min(60.w, 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit track info',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(label: Text('Artist')),
                  focusNode: artistFocusNode,
                  controller: artistController,
                  onSubmitted: (_) => titleFocusNode.requestFocus(),
                ),
                TextField(
                  decoration: const InputDecoration(label: Text('Title')),
                  focusNode: titleFocusNode,
                  controller: titleController,
                  onSubmitted: (_) => editTrackBloc.add(
                    LoadingEvent(
                      widget.track.id,
                      titleController.text,
                      artistController.text,
                      widget.track.cover,
                    ),
                  ),
                ),
                if (state is InputErrorState)
                  Text(
                    state.errorText,
                    style: const TextStyle(color: Colors.red),
                  )
                else
                  const SizedBox(height: 20),
                const SizedBox(height: 20),
                StyledButton(
                  title: 'Submit',
                  onPressed: () => editTrackBloc.add(
                    LoadingEvent(
                      widget.track.id,
                      titleController.text,
                      artistController.text,
                      widget.track.cover,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
