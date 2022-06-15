import 'package:flutter/material.dart';

class UploadFromLocal extends StatefulWidget {
  final Function onCancelPressed;

  UploadFromLocal({required this.onCancelPressed}) : super();

  @override
  State<UploadFromLocal> createState() => _UploadFromLocalState();
}

class _UploadFromLocalState extends State<UploadFromLocal> {
  @override
  Widget build(BuildContext context) {
    final inputFieldWidth = MediaQuery.of(context).size.width / 2;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Select file to upload',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Container(
            width: inputFieldWidth,
            color: Colors.grey,
            child: Text(
              'Drop file here',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
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
