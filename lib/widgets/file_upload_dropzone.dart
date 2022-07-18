import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class FileUploadDropzone extends StatefulWidget {
  final double width;
  final double height;
  final Function(String, List<int>) saveFileName;

  FileUploadDropzone({required this.width, required this.height, required this.saveFileName}) : super();

  @override
  State<FileUploadDropzone> createState() => _FileUploadDropzoneState();
}

class _FileUploadDropzoneState extends State<FileUploadDropzone> {
  late DropzoneViewController dropController;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Theme.of(context).primaryColor,
      strokeWidth: 1,
      dashPattern: [5, 2],
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Theme.of(context).primaryColorLight.withOpacity(0.5),
        child: Stack(
          alignment: Alignment.center,
          children: [
            DropzoneView(
              operation: DragOperation.copy,
              cursor: CursorType.grab,
              onCreated: (controller) => dropController = controller,
              onLoaded: () => debugPrint('Loaded'),
              onError: (ev) => debugPrint('Error: $ev'),
              onHover: () => debugPrint('Zone hovered'),
              onDrop: (file) async {
                if (!(await isAudio(file))) {
                  debugPrint('File is not audio');
                  return;
                }
                final name = await dropController.getFilename(file);
                final data = await dropController.getFileData(file);
                widget.saveFileName(name, data);
              },
              onDropMultiple: (_) {},
              onLeave: () => debugPrint('Zone left'),
            ),
            Text(
              'Select file or drop it here',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> isAudio(dynamic file) async {
    final mime = await dropController.getFileMIME(file);
    return mime.startsWith('audio');
  }
}
