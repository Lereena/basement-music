import 'dart:math';

import 'package:flutter/material.dart';

import '../../../widgets/buttons/styled_button.dart';
import '../../../widgets/titled_field.dart';

class TrackInfoPage extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController artistController;
  final Function() onUploadPress;

  const TrackInfoPage({
    Key? key,
    required this.titleController,
    required this.artistController,
    required this.onUploadPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputFieldWidth = min(MediaQuery.of(context).size.width / 1.5, 400).toDouble();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('Please check track info and change if incorrect'),
        const SizedBox(height: 20),
        TitledField(title: 'Artist', controller: artistController, fieldWidth: inputFieldWidth),
        const SizedBox(height: 20),
        TitledField(title: 'Title', controller: titleController, fieldWidth: inputFieldWidth),
        const SizedBox(height: 20),
        StyledButton(title: 'Upload', onPressed: onUploadPress),
      ],
    );
  }
}
