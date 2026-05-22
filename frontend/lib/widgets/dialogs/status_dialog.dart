import 'package:flutter/material.dart';

import 'package:basement_music/widgets/dialogs/base_dialog.dart';

class StatusDialog extends StatelessWidget {
  final bool success;
  final String text;

  const StatusDialog({super.key, required this.success, required this.text});

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (success)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 30,
              )
            else
              const Icon(
                Icons.warning,
                color: Colors.red,
                size: 30,
              ),
            const SizedBox(height: 20),
            Text(text, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
