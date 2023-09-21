import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../utils/track_data.dart';
import '../../widgets/buttons/styled_button.dart';

class FilesInputPage extends StatelessWidget {
  final List<({String name, PlatformFile file})>? selectedFiles;
  final void Function()? onMoveNext;
  final Future<void> Function() onSelectFiles;
  final void Function(PlatformFile)? onRemoveFile;
  final void Function(({String name, PlatformFile file}))? onEditFileInfo;

  const FilesInputPage({
    super.key,
    this.selectedFiles,
    this.onMoveNext,
    required this.onSelectFiles,
    this.onRemoveFile,
    this.onEditFileInfo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (selectedFiles?.isNotEmpty == true) ...[
          Text(
            'Selected files:',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ...selectedFiles!.map((element) {
            final (artist, title) = getArtistAndTitle(element.name);

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${artist == null ? '' : '$artist - '}$title'),
                const SizedBox(width: 4),
                if (onEditFileInfo != null)
                  IconButton(
                    onPressed: () => onEditFileInfo!(element),
                    splashRadius: 16,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                if (onRemoveFile != null)
                  IconButton(
                    onPressed: () => onRemoveFile!(element.file),
                    splashRadius: 16,
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.errorContainer,
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(height: 16),
        ],
        StyledButton(title: 'Add files', onPressed: onSelectFiles),
        if (onMoveNext != null && selectedFiles?.isNotEmpty == true) ...[
          const SizedBox(height: 16),
          StyledButton(title: 'Next', onPressed: onMoveNext!),
        ],
      ],
    );
  }
}