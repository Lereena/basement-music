import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

/// Full-screen dialog that lets the user crop [imageBytes] to a square before
/// upload. Returns the cropped PNG bytes, or null if the user cancels.
class ImageCropDialog extends StatefulWidget {
  final Uint8List imageBytes;

  const ImageCropDialog({super.key, required this.imageBytes});

  static Future<Uint8List?> show(BuildContext context, Uint8List imageBytes) {
    return showDialog<Uint8List>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ImageCropDialog(imageBytes: imageBytes),
    );
  }

  @override
  State<ImageCropDialog> createState() => _ImageCropDialogState();
}

class _ImageCropDialogState extends State<ImageCropDialog> {
  final _controller = CropController();
  bool _cropping = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crop image'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _cropping ? null : () => Navigator.of(context).pop(),
          ),
          actions: [
            TextButton(
              onPressed: _cropping
                  ? null
                  : () {
                      setState(() => _cropping = true);
                      _controller.crop();
                    },
              child: const Text('Done'),
            ),
          ],
        ),
        body: Stack(
          children: [
            Crop(
              controller: _controller,
              image: widget.imageBytes,
              aspectRatio: 1,
              interactive: true,
              baseColor: theme.colorScheme.surface,
              maskColor: Colors.black.withValues(alpha: 0.6),
              cornerDotBuilder: (size, _) => const DotControl(),
              onCropped: (result) {
                if (!mounted) return;
                switch (result) {
                  case CropSuccess(:final croppedImage):
                    Navigator.of(context).pop(croppedImage);
                  case CropFailure():
                    setState(() => _cropping = false);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Could not crop image')));
                }
              },
            ),
            if (_cropping) const ColoredBox(color: Colors.black45, child: Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}
