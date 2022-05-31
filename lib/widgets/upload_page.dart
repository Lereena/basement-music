import 'package:basement_music/library.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final controller = TextEditingController();

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
            'Insert YouTube link to extract audio',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Container(
            width: inputFieldWidth,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 40),
          Container(
            width: 80,
            height: 40,
            child: ElevatedButton(
              child: Text(
                'Extract',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () async {
                await uploadTrack(controller.text);
                controller.text = "";
              },
            ),
          ),
        ],
      ),
    );
  }
}
