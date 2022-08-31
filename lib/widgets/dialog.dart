import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const CustomDialog({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 40),
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [child],
        ),
      ),
    );
  }
}
