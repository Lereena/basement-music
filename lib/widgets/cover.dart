import 'package:flutter/material.dart';

import '../cacher/caching_state.dart';

class Cover extends StatelessWidget {
  final CachingState cachingState;
  final String cover;

  const Cover({
    Key? key,
    required this.cachingState,
    required this.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(cover, width: 40, height: 40);

    switch (cachingState) {
      case CachingState.startCaching:
        return Stack(
          children: [
            image,
            Container(
              color: Theme.of(context).shadowColor.withOpacity(0.5),
              width: 40,
              height: 40,
            ),
            CircularProgressIndicator(),
          ],
        );
      case CachingState.finishCaching:
        return Stack(
          children: [
            image,
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
              width: 40,
              height: 40,
            ),
          ],
        );
      case CachingState.errorCaching:
        return image;
    }
  }
}
