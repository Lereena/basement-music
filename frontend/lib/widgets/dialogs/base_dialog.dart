import 'package:basement_music/theme/theme.dart';
import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const BaseDialog({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  @override
  Widget build(BuildContext context) {
    // The surface is a Material (not a colored Container) so that ListTile /
    // CheckboxListTile ink splashes paint on top of it and stay visible.
    return Center(
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Material(
          color: context.colorScheme.surface,
          borderRadius: AppRadius.lgAll,
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
