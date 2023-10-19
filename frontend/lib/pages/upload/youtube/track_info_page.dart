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

  late final titleController = TextEditingController(text: title);
  late final artistController = TextEditingController(text: artist);

  final artistFocusNode = FocusNode();
  final titleFocusNode = FocusNode();
  final uploadFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final inputFieldWidth = min(70.w, 400).toDouble();
    artistFocusNode.requestFocus();

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
                controller: artistController,
                focusNode: artistFocusNode,
                validator: (value) =>
                    value?.isNotEmpty != true ? 'Field is required' : null,
                onFieldSubmitted: (_) => titleFocusNode.requestFocus(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: inputFieldWidth,
              child: TextFormField(
                decoration: const InputDecoration(label: Text('Title')),
                controller: titleController,
                focusNode: titleFocusNode,
                validator: (value) =>
                    value?.isNotEmpty != true ? 'Field is required' : null,
                onFieldSubmitted: (_) => uploadFocusNode.requestFocus(),
              ),
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: _onUpload,
              focusNode: uploadFocusNode,
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
      onUpload(artistController.text, titleController.text);
    }
  }
}
