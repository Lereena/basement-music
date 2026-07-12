import 'package:basement_music/theme/theme.dart';
import 'package:flutter/material.dart';

/// Labeled loading block for dialogs — a spinner with an optional message and
/// comfortable padding, so a loading state never reads as an empty dialog.
class DialogLoading extends StatelessWidget {
  final String? message;

  const DialogLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

/// Placeholder shown while a fetched artist/album image is downloading.
class DialogImageLoading extends StatelessWidget {
  const DialogImageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colorScheme.surfaceContainerHighest,
      child: const Center(
        child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }
}

/// Fallback shown when a fetched artist/album image fails to load.
class DialogImageError extends StatelessWidget {
  const DialogImageError({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(Icons.broken_image_outlined, color: context.colorScheme.onSurfaceVariant),
    );
  }
}
