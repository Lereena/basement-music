import 'package:flutter/material.dart';

import '../../../widgets/buttons/styled_button.dart';
import '../../../widgets/icons/error_icon.dart';
import '../../../widgets/icons/success_icon.dart';

enum EditingResult { success, fail }

class PlaylistEditResultPage extends StatelessWidget {
  final EditingResult result;
  final Function() onTryAgain;

  const PlaylistEditResultPage({
    super.key,
    required this.result,
    required this.onTryAgain,
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
            'Track was successfully uploaded',
            style: theme.textTheme.titleLarge,
          )
        else
          Text(
            'Track uploading is failed, please try again later',
            style: theme.textTheme.titleLarge,
          ),
        const SizedBox(height: 20),
        StyledButton(
          title: 'Try again',
          onPressed: onTryAgain,
          autofocus: true,
        ),
      ],
    );
  }
}
