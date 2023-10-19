import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TrackInfoPage extends StatelessWidget {
  final String artist;
  final String title;
  final void Function(String, String) onUploadPress;
  final void Function() onCancel;

  TrackInfoPage({
    super.key,
    required this.artist,
    required this.title,
    required this.onUploadPress,
    required this.onCancel,
  });

  late final titleController = TextEditingController(text: title);
  late final artistController = TextEditingController(text: artist);

  final artistFocusNode = FocusNode();
  final titleFocusNode = FocusNode();
  final uploadFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final inputFieldWidth = min(70.w, 400).toDouble();
    artistFocusNode.requestFocus();

    return Center(
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
            child: TextField(
              decoration: const InputDecoration(label: Text('Artist')),
              controller: artistController,
              focusNode: artistFocusNode,
              onSubmitted: (_) => titleFocusNode.requestFocus(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: inputFieldWidth,
            child: TextField(
              decoration: const InputDecoration(label: Text('Title')),
              controller: titleController,
              focusNode: titleFocusNode,
              onSubmitted: (_) => uploadFocusNode.requestFocus(),
            ),
          ),
          const SizedBox(height: 40),
          FilledButton(
            onPressed: () =>
                onUploadPress(artistController.text, titleController.text),
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
    );
  }
}
