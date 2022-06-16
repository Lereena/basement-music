import 'package:flutter/material.dart';

import '../../widgets/file_upload_dropzone.dart';

class UploadFromDevice extends StatefulWidget {
  final Function onCancelPressed;

  UploadFromDevice({required this.onCancelPressed}) : super();

  @override
  State<UploadFromDevice> createState() => _UploadFromDeviceState();
}

class _UploadFromDeviceState extends State<UploadFromDevice> {
  @override
  Widget build(BuildContext context) {
    final inputFieldWidth = MediaQuery.of(context).size.width / 2;
    final inputFieldHeight = MediaQuery.of(context).size.height / 4;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          FileUploadDropzone(
            width: inputFieldWidth,
            height: inputFieldHeight,
          ),
          SizedBox(height: 40),
          Container(
            width: 100,
            height: 40,
            child: ElevatedButton(
              child: Text(
                'Upload',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {},
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
