import 'dart:typed_data';

import 'package:basement_music/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A square, tappable image slot showing (in priority order) freshly-picked
/// bytes, an existing network image, or a placeholder icon. Extracted from the
/// duplicated pickers in artist/playlist edit pages.
class ImagePickerBox extends StatelessWidget {
  final String? currentImageUrl;
  final Uint8List? pickedBytes;
  final VoidCallback onTap;
  final IconData placeholderIcon;

  const ImagePickerBox({
    super.key,
    required this.currentImageUrl,
    required this.pickedBytes,
    required this.onTap,
    this.placeholderIcon = Icons.image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: AppRadius.smAll,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (pickedBytes != null)
                Image.memory(pickedBytes!, fit: BoxFit.cover)
              else if (currentImageUrl != null)
                CachedNetworkImage(
                  imageUrl: currentImageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => ColoredBox(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  ),
                  errorWidget: (_, _, _) => _placeholder(theme),
                )
              else
                _placeholder(theme),
              Positioned(
                right: AppSpacing.sm,
                bottom: AppSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: AppRadius.smAll),
                  child: const Icon(Icons.image_outlined, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) =>
      Container(color: theme.colorScheme.surfaceContainerHighest, child: Icon(placeholderIcon, size: 64));
}
