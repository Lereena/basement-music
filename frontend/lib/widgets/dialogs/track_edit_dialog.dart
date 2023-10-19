import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'dialog.dart';

class TrackEditDialog extends StatefulWidget {
  final String? artist;
  final String? title;
  final void Function(({String artist, String title})) onSubmit;

  const TrackEditDialog({
    super.key,
    required this.artist,
    required this.title,
    required this.onSubmit,
  });

  static Future<void> show({
    required BuildContext context,
    required String? artist,
    required String? title,
    required void Function(({String artist, String title})) onSubmit,
  }) =>
      showDialog(
        context: context,
        builder: (_) => CustomDialog(
          height: min(30.w, 400),
          child: TrackEditDialog(
            artist: artist,
            title: title,
            onSubmit: onSubmit,
          ),
        ),
      );

  @override
  State<TrackEditDialog> createState() => _TrackEditDialogState();
}

class _TrackEditDialogState extends State<TrackEditDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _artistController = TextEditingController(text: widget.artist);
  late final _titleController = TextEditingController(text: widget.title);

  @override
  Widget build(BuildContext context) {
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
              validator: (value) =>
                  value?.isNotEmpty != true ? 'Field is required' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(label: Text('Title')),
              controller: _titleController,
              validator: (value) =>
                  value?.isNotEmpty != true ? 'Field is required' : null,
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
  }

  void _onSave() {
    final isValid = _formKey.currentState?.validate();

    if (isValid == true) {
      widget.onSubmit(
        (artist: _artistController.text, title: _titleController.text),
      );

      Navigator.pop(context);
    }
  }
}
