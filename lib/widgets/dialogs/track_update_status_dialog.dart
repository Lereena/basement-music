import 'package:flutter/material.dart';

import '../dialog.dart';

class TrackUpdateStatusDialog extends StatelessWidget {
  final bool success;

  const TrackUpdateStatusDialog({required this.success}) : super();

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
            Text(
              success ? 'Track info successfully updated' : 'Track info was not updated, please try again later',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
