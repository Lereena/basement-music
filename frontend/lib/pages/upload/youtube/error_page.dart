import 'package:flutter/material.dart';

import '../../../widgets/icons/error_icon.dart';

class ErrorPage extends StatelessWidget {
  final Function() onTryAgainPress;

  const ErrorPage({super.key, required this.onTryAgainPress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ErrorIcon(),
          const SizedBox(height: 40),
          Text(
            "Couldn't fetch YouTube video. Please check the link and try again.",
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: onTryAgainPress,
            autofocus: true,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
