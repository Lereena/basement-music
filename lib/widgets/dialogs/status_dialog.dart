import 'package:flutter/material.dart';

import '../dialog.dart';

class StatusDialog extends StatelessWidget {
  final bool success;
  final String text;

  const StatusDialog({required this.success, required this.text}) : super();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            success
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 30,
                  )
                : const Icon(
                    Icons.warning,
                    color: Colors.red,
                    size: 30,
                  ),
            SizedBox(height: 20),
            Text(text, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
