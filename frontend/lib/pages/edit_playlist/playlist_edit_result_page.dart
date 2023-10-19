import 'package:flutter/material.dart';

import '../../../widgets/icons/error_icon.dart';
import '../../../widgets/icons/success_icon.dart';

enum EditingResult { success, fail }

class PlaylistEditResultPage extends StatelessWidget {
  final EditingResult result;
  final Function() onClose;

  const PlaylistEditResultPage({
    super.key,
    required this.result,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (result == EditingResult.success) SuccessIcon() else ErrorIcon(),
        const SizedBox(height: 20),
        if (result == EditingResult.success)
          Text(
            'Playlist was successfully edited',
            style: theme.textTheme.titleLarge,
          )
        else
          Text(
            'Playlist editing is failed, please try again later',
            style: theme.textTheme.titleLarge,
          ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: onClose,
          autofocus: true,
          child: const Text('Return to playlist'),
        ),
      ],
    );
  }
}
