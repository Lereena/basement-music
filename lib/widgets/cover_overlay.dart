import 'package:flutter/material.dart';

class CoverOverlay extends StatelessWidget {
  final bool isCaching;
  final bool isCached;

  const CoverOverlay({
    Key? key,
    required this.isCaching,
    required this.isCached,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCached) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        width: 40,
        height: 40,
      );
    }

    if (isCaching) return const CircularProgressIndicator();

    return Container();
  }
}
