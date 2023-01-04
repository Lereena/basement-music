import 'package:flutter/material.dart';

class Cover extends StatelessWidget {
  final String cover;
  final Widget? overlay;
  final double size;

  const Cover({
    super.key,
    required this.cover,
    this.overlay,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(cover, width: size, height: size);

    return Stack(
      alignment: Alignment.center,
      children: [
        image,
        if (overlay != null)
          Container(
            color: Theme.of(context).shadowColor.withOpacity(0.2),
            width: size,
            height: size,
          ),
        overlay ?? const SizedBox.shrink(),
      ],
    );
  }
}
