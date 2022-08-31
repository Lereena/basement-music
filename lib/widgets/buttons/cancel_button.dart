import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final Function() onPressed;

  const CancelButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text('Cancel'),
    );
  }
}
