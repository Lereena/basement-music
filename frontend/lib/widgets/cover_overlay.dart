import 'package:flutter/material.dart';

class CoverOverlay extends StatelessWidget {
  final bool isCaching;
  final bool isCached;

  const CoverOverlay({
    super.key,
    required this.isCaching,
    required this.isCached,
  });

  @override
  Widget build(BuildContext context) {
    if (isCached) {
      return Positioned(
        bottom: 0,
        right: 0,
        child: Icon(
          Icons.download_done,
          size: 15,
          color: Theme.of(context).primaryColor,
        ),
      );
    }

    if (isCaching) {
      return Positioned(
        bottom: 2,
        right: 2,
        child: Stack(
          children: [
            Icon(
              Icons.download_outlined,
              size: 15,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(strokeWidth: 1),
            ),
          ],
        ),
      );
    }

    return Container();
  }
}
