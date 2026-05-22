import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const BaseDialog({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
