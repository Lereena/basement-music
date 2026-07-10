import 'dart:typed_data';

import 'package:basement_music/logger.dart';
import 'package:basement_music/widgets/dialogs/image_crop_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

typedef PickedImage = ({Uint8List bytes, String name});

enum _ImageAction { pickNew, cropCurrent }

/// Prompts the user to pick an image file, then crop it to a square. When an
/// image is already set ([currentBytes] or [currentImageUrl]), first offers a
/// choice between picking a new file and re-cropping the current one. Returns
/// the cropped PNG bytes with a `.png` filename, or null if the user cancels.
/// Shared by every image-upload slot (artist, album, playlist).
Future<PickedImage?> pickAndCropImage(
  BuildContext context, {
  String? currentImageUrl,
  Uint8List? currentBytes,
}) async {
  final hasCurrent = currentBytes != null || currentImageUrl != null;

  if (hasCurrent) {
    final action = await _chooseAction(context);
    if (action == null || !context.mounted) return null;

    if (action == _ImageAction.cropCurrent) {
      final bytes = currentBytes ?? await _fetchBytes(currentImageUrl!);
      if (bytes == null || !context.mounted) return null;
      return _crop(context, bytes, 'cropped.png');
    }
  }

  final result = await FilePicker.pickFiles(type: FileType.image, withData: true);
  if (result == null || result.files.isEmpty || result.files.first.bytes == null) return null;

  final file = result.files.first;
  if (!context.mounted) return null;

  final baseName = file.name.contains('.') ? file.name.substring(0, file.name.lastIndexOf('.')) : file.name;
  return _crop(context, file.bytes!, '$baseName.png');
}

Future<PickedImage?> _crop(BuildContext context, Uint8List bytes, String name) async {
  final cropped = await ImageCropDialog.show(context, bytes);
  if (cropped == null) return null;
  return (bytes: cropped, name: name);
}

Future<_ImageAction?> _chooseAction(BuildContext context) {
  return showModalBottomSheet<_ImageAction>(
    context: context,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.crop),
            title: const Text('Crop current image'),
            onTap: () => Navigator.of(context).pop(_ImageAction.cropCurrent),
          ),
          ListTile(
            leading: const Icon(Icons.image_outlined),
            title: const Text('Pick new image'),
            onTap: () => Navigator.of(context).pop(_ImageAction.pickNew),
          ),
        ],
      ),
    ),
  );
}

Future<Uint8List?> _fetchBytes(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) return response.bodyBytes;
    logger.w('Fetch image for crop failed: HTTP ${response.statusCode}');
  } catch (e) {
    logger.e('Fetch image for crop failed: $e');
  }
  return null;
}
