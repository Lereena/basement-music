import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TrackInfoPage extends StatelessWidget {
  final String artist;
  final String title;
  final void Function(String, String) onUpload;
  final void Function() onCancel;

  TrackInfoPage({
    super.key,
    required this.artist,
    required this.title,
    required this.onUpload,
    required this.onCancel,
  });

  late final _titleController = TextEditingController(text: title);
  late final _artistController = TextEditingController(text: artist);

  final _artistFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  final _uploadFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final inputFieldWidth = min(70.w, 400).toDouble();
    _artistFocusNode.requestFocus();

    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please check track info and change if incorrect',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: inputFieldWidth,
              child: TextFormField(
                decoration: const InputDecoration(label: Text('Artist')),
                controller: _artistController,
                focusNode: _artistFocusNode,
                validator: (value) =>
                    value?.isNotEmpty != true ? 'Field is required' : null,
                onFieldSubmitted: (_) => _titleFocusNode.requestFocus(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: inputFieldWidth,
              child: TextFormField(
                decoration: const InputDecoration(label: Text('Title')),
                controller: _titleController,
                focusNode: _titleFocusNode,
                validator: (value) =>
                    value?.isNotEmpty != true ? 'Field is required' : null,
                onFieldSubmitted: (_) => _uploadFocusNode.requestFocus(),
              ),
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: _onUpload,
              focusNode: _uploadFocusNode,
              child: const Text('Upload'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onCancel,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void _onUpload() {
    final isValid = _formKey.currentState?.validate() == true;

    if (isValid) {
      onUpload(_artistController.text, _titleController.text);
    }
  }
}
