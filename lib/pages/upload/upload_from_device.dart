import 'package:flutter/material.dart';

import '../../interactors/track_interactor.dart';
import '../../widgets/dialogs/status_dialog.dart';
import '../../widgets/file_upload_dropzone.dart';

class UploadFromDevice extends StatefulWidget {
  final Function onCancelPressed;

  UploadFromDevice({required this.onCancelPressed}) : super();

  @override
  State<UploadFromDevice> createState() => _UploadFromDeviceState();
}

class _UploadFromDeviceState extends State<UploadFromDevice> {
  var fileName = "";
  var fileData = <int>[];
  var uploading = false;

  @override
  Widget build(BuildContext context) {
    if (uploading) {
      return Expanded(child: CircularProgressIndicator());
    }

    final inputFieldWidth = MediaQuery.of(context).size.width / 2;
    final inputFieldHeight = MediaQuery.of(context).size.height / 4;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (fileName == "")
            FileUploadDropzone(
              width: inputFieldWidth,
              height: inputFieldHeight,
              saveFileName: (name, data) {
                setState(() {
                  fileName = name;
                  fileData = data;
                });
              },
            )
          else
            Text(fileName, style: TextStyle(fontSize: 18)),
          SizedBox(height: 40),
          if (fileName != "")
            Container(
              width: 100,
              height: 40,
              child: ElevatedButton(
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  setState(() {
                    uploading = true;
                  });
                  final result = await uploadLocalTrack(fileData, fileName);
                  setState(() {
                    uploading = false;
                    fileName = "";
                    fileData = <int>[];
                  });
                  await showDialog(
                      context: context,
                      builder: (_) => StatusDialog(
                            success: result,
                            text: result
                                ? 'Track was successfully uploaded'
                                : 'Track was not uploaded. Please try again later',
                          ));
                },
              ),
            ),
          SizedBox(height: 20),
          TextButton(
            child: Text('Cancel'),
            onPressed: () => widget.onCancelPressed(),
          ),
        ],
      ),
    );
  }
}
