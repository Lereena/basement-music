import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/buttons/styled_button.dart';
import '../../../widgets/titled_field.dart';

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
    final inputFieldWidth = min(60.w, 400).toDouble();
    artistFocusNode.requestFocus();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Please check track info and change if incorrect',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TitledField(
          title: 'Artist',
          controller: artistController,
          fieldWidth: inputFieldWidth,
          focusNode: artistFocusNode,
          onSubmitted: (_) => titleFocusNode.requestFocus(),
        ),
        const SizedBox(height: 20),
        TitledField(
          title: 'Title',
          controller: titleController,
          fieldWidth: inputFieldWidth,
          focusNode: titleFocusNode,
          onSubmitted: (_) => uploadFocusNode.requestFocus(),
        ),
        const SizedBox(height: 40),
        StyledButton(
          title: 'Upload',
          onPressed: () => onUploadPress(artistController.text, titleController.text),
          focusNode: uploadFocusNode,
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
