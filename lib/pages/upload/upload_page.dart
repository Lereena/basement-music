import 'package:basement_music/pages/upload/upload_from_device.dart';
import 'package:flutter/material.dart';

import 'extract_from_youtube.dart';

class UploadPage extends StatefulWidget {
  UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

enum UploadSource { local, youtube, unknown }

class _UploadPageState extends State<UploadPage> {
  var uploadSource = UploadSource.unknown;

  @override
  Widget build(BuildContext context) {
    switch (uploadSource) {
      case UploadSource.local:
        return UploadFromDevice(
          onCancelPressed: () => setState(
            () => uploadSource = UploadSource.unknown,
          ),
        );
      case UploadSource.youtube:
        return ExtractFromYoutube(
          onCancelPressed: () => setState(
            () => uploadSource = UploadSource.unknown,
          ),
        );
      case UploadSource.unknown:
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() {
                    uploadSource = UploadSource.local;
                  }),
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Icon(Icons.upload_file_rounded),
                  ),
                  label: Text(
                    'Upload from device',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Container(
                height: 40,
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() {
                    uploadSource = UploadSource.youtube;
                  }),
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Icon(Icons.cloud_upload),
                  ),
                  label: Text(
                    'Extract from YouTube video',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}
