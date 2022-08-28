import 'package:flutter/material.dart';

class TrackProgressIndicator extends StatelessWidget {
  final double percentProgress;

  const TrackProgressIndicator({
    Key? key,
    required this.percentProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: percentProgress,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    );
  }
}
