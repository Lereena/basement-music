import 'package:flutter/material.dart';

import '../../widgets/icons/error_icon.dart';
import '../../widgets/icons/success_icon.dart';

enum Result { success, fail }

class ResultPage extends StatelessWidget {
  final Result result;
  final String successMessage;
  final String failMessage;
  final String buttonText;
  final void Function() onLeavePage;

  const ResultPage({
    super.key,
    required this.result,
    required this.successMessage,
    required this.failMessage,
    required this.buttonText,
    required this.onLeavePage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (result == Result.success) SuccessIcon() else ErrorIcon(),
          const SizedBox(height: 20),
          if (result == Result.success)
            Text(
              successMessage,
              style: theme.textTheme.titleLarge,
            )
          else
            Text(
              failMessage,
              style: theme.textTheme.titleLarge,
            ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: onLeavePage,
            autofocus: true,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
