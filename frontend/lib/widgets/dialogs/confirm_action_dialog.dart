import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmActionDialog extends StatelessWidget {
  final String title;

  const ConfirmActionDialog({super.key, required this.title});

  static Future<bool> show({
    required BuildContext context,
    required String title,
  }) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => ConfirmActionDialog(title: title),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => context.pop(true),
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () => context.pop(false),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
