import 'package:flutter/material.dart';

class TrackProgressIndicator extends StatelessWidget {
  final double percentProgress;

  const TrackProgressIndicator({
    super.key,
    required this.percentProgress,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: percentProgress,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    );
  }
}
