import 'package:flutter/material.dart';

class YesOrCancelDialog extends StatelessWidget {
  final String title;

  const YesOrCancelDialog({Key? key, required this.title}) : super(key: key);

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
