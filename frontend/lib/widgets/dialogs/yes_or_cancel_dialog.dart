import 'package:flutter/material.dart';

class YesOrCancelDialog extends StatelessWidget {
  final String title;

  const YesOrCancelDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Yes'),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
