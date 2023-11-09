import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../bloc/track_editor_bloc/track_editor_bloc.dart';
import '../models/track.dart';
import '../repositories/tracks_repository.dart';
import 'dialogs/dialog.dart';

class EditTrack extends StatefulWidget {
  final Track track;

  const EditTrack._({required this.track});

  static Future<void> show({
    required BuildContext context,
    required Track track,
  }) =>
      showDialog(
        context: context,
        builder: (_) => BlocProvider(
          create: (_) => TrackEditorBloc(context.read<TracksRepository>()),
          child: CustomDialog(
            height: min(30.w, 400),
            child: EditTrack._(
              track: track,
            ),
          ),
        ),
      );

  @override
  State<EditTrack> createState() => _EditTrackState();
}

class _EditTrackState extends State<EditTrack> {
  final _formKey = GlobalKey<FormState>();

  late final _titleController = TextEditingController(text: widget.track.title);
  late final _artistController =
      TextEditingController(text: widget.track.artist);

  final _titleFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<TrackEditorBloc, TrackEditorState>(
        builder: (context, state) {
          if (state is TrackEditorLoadInProgress) {
            return const CircularProgressIndicator();
          }

          if (state is TrackEditorSuccess) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Track was successfully edited'),
            );
          }

          if (state is TrackEditorError) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Track was not edited, please try again later'),
            );
          }

          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Edit track info',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(label: Text('Artist')),
                    controller: _artistController,
                    autofocus: true,
                    onEditingComplete: () => _titleFocusNode.requestFocus(),
                    validator: (value) =>
                        value?.isNotEmpty != true ? 'Field is required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(label: Text('Title')),
                    focusNode: _titleFocusNode,
                    controller: _titleController,
                    validator: (value) =>
                        value?.isNotEmpty != true ? 'Field is required' : null,
                    onEditingComplete: () =>
                        context.read<TrackEditorBloc>().add(
                              TrackEditorEdited(
                                widget.track.id,
                                _titleController.text,
                                _artistController.text,
                                widget.track.cover,
                              ),
                            ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _onSave,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onSave() {
    final isValid = _formKey.currentState?.validate();

    if (isValid == true) {
      context.read<TrackEditorBloc>().add(
            TrackEditorEdited(
              widget.track.id,
              _titleController.text,
              _artistController.text,
              widget.track.cover,
            ),
          );
    }
  }
}
