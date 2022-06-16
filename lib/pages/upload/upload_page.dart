import 'package:flutter/material.dart';

import 'extract_from_youtube.dart';
import 'upload_from_local.dart';

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
        return UploadFromLocal(onCancelPressed: () => setState(() => uploadSource = UploadSource.unknown));
      case UploadSource.youtube:
        return ExtractFromYoutube(onCancelPressed: () => setState(() => uploadSource = UploadSource.unknown));
      case UploadSource.unknown:
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() {
                    uploadSource = UploadSource.local;
                  }),
                  icon: Icon(Icons.upload_file_rounded),
                  label: Text(
                    'Upload from local filesystem',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() {
                    uploadSource = UploadSource.youtube;
                  }),
                  icon: Icon(Icons.cloud_upload),
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