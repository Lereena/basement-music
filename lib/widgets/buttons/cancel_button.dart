import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final Function() onPressed;

  const CancelButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text('Cancel'),
    );
  }
}
