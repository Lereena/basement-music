import 'package:flutter/material.dart';

class Cover extends StatelessWidget {
  final String cover;
  final Widget? overlay;

  const Cover({
    Key? key,
    required this.cover,
    this.overlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(cover, width: 40, height: 40);

    return Stack(
      alignment: Alignment.center,
      children: [
        image,
        Container(
          color: Theme.of(context).shadowColor.withOpacity(0.2),
          width: 40,
          height: 40,
        ),
        overlay ?? const CircularProgressIndicator(),
      ],
    );
  }
}
