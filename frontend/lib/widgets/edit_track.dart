import 'package:basement_music/bloc/track_editor_cubit/track_editor_cubit.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:basement_music/widgets/dialogs/base_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditTrack extends StatefulWidget {
  final Track track;

  const EditTrack._({required this.track});

  static Future<void> show({required BuildContext context, required Track track}) => showDialog(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) => TrackEditorCubit(context.read<TracksRepository>()),
      child: BaseDialog(child: EditTrack._(track: track)),
    ),
  );

  @override
  State<EditTrack> createState() => _EditTrackState();
}

class _EditTrackState extends State<EditTrack> {
  final _formKey = GlobalKey<FormState>();

  late final _titleController = TextEditingController(text: widget.track.title);
  late final _artistController = TextEditingController(text: widget.track.artist);

  final _titleFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackEditorCubit, TrackEditorState>(
      builder: (context, state) => state.when(
        loadInProgress: () => const CircularProgressIndicator(),
        success: () => const Padding(padding: EdgeInsets.all(8.0), child: Text('Track was successfully edited')),
        error: () =>
            const Padding(padding: EdgeInsets.all(8.0), child: Text('Track was not edited, please try again later')),
        initial: () => Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Edit track info', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(label: Text('Artist')),
                controller: _artistController,
                autofocus: true,
                onEditingComplete: () => _titleFocusNode.requestFocus(),
                validator: (value) => value?.isNotEmpty != true ? 'Field is required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(label: Text('Title')),
                focusNode: _titleFocusNode,
                controller: _titleController,
                validator: (value) => value?.isNotEmpty != true ? 'Field is required' : null,
                onEditingComplete: _onSave,
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: _onSave, child: const Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }

  void _onSave() {
    final isValid = _formKey.currentState?.validate();

    if (isValid == true) {
      context.read<TrackEditorCubit>().editTrack(
        trackId: widget.track.id,
        title: _titleController.text,
        artist: _artistController.text,
        cover: widget.track.cover,
      );
    }
  }
}
