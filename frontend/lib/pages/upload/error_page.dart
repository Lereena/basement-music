import 'package:flutter/material.dart';

import '../../widgets/icons/error_icon.dart';

class ErrorPage extends StatelessWidget {
  final String errorText;
  final Function() onTryAgain;

  const ErrorPage({
    super.key,
    required this.errorText,
    required this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ErrorIcon(),
          const SizedBox(height: 40),
          Text(
            errorText,
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: onTryAgain,
            autofocus: true,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
