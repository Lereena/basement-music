import 'package:flutter/material.dart';

import '../../../widgets/buttons/styled_button.dart';
import '../../../widgets/icons/error_icon.dart';

class ErrorPage extends StatelessWidget {
  final Function() onTryAgainPress;

  const ErrorPage({super.key, required this.onTryAgainPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ErrorIcon(),
        const SizedBox(height: 40),
        const Text("Couldn't fetch YouTube video. Please check the link and try again."),
        const SizedBox(height: 40),
        StyledButton(
          title: 'Try again',
          onPressed: onTryAgainPress,
          autofocus: true,
        ),
      ],
    );
  }
}
