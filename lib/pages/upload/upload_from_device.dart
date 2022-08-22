import 'package:flutter/material.dart';

import '../../interactors/track_interactor.dart';
import '../../widgets/dialogs/status_dialog.dart';
import '../../widgets/file_upload_dropzone.dart';

class UploadFromDevice extends StatefulWidget {
  final Function onCancelPressed;

  const UploadFromDevice({required this.onCancelPressed}) : super();

  @override
  State<UploadFromDevice> createState() => _UploadFromDeviceState();
}

class _UploadFromDeviceState extends State<UploadFromDevice> {
  var _fileName = "";
  var _fileData = <int>[];
  var _uploading = false;

  @override
  Widget build(BuildContext context) {
    if (_uploading) {
      return const CircularProgressIndicator();
    }

    final inputFieldWidth = MediaQuery.of(context).size.width / 2;
    final inputFieldHeight = MediaQuery.of(context).size.height / 4;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_fileName == "")
            FileUploadDropzone(
              width: inputFieldWidth,
              height: inputFieldHeight,
              saveFileName: (name, data) {
                setState(() {
                  _fileName = name;
                  _fileData = data;
                });
              },
            )
          else
            Text(_fileName, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 40),
          if (_fileName != "")
            SizedBox(
              width: 100,
              height: 40,
              child: ElevatedButton(
                child: const Text(
                  'Upload',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  setState(() {
                    _uploading = true;
                  });
                  final result = await uploadLocalTrack(_fileData, _fileName);
                  setState(() {
                    _uploading = false;
                    _fileName = "";
                    _fileData = <int>[];
                  });
                  await showDialog(
                    context: context,
                    builder: (_) => StatusDialog(
                      success: result,
                      text:
                          result ? 'Track was successfully uploaded' : 'Track was not uploaded. Please try again later',
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 20),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => widget.onCancelPressed(),
          ),
        ],
      ),
    );
  }
}
