import 'package:flutter/material.dart';

class EditUploadedPage extends StatefulWidget {
  EditUploadedPage({Key? key}) : super(key: key);

  @override
  State<EditUploadedPage> createState() => _EditUploadedPageState();
}

const _textStyle = const TextStyle(fontSize: 18);

class _EditUploadedPageState extends State<EditUploadedPage> {
  final titleController = TextEditingController();
  final artistController = TextEditingController();

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
            'Please check track info and edit if needed',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          _titledField('Title:', titleController, inputFieldWidth),
          SizedBox(height: 20),
          _titledField('Artist:', artistController, inputFieldWidth),
          SizedBox(height: 40),
          Container(
            width: 100,
            height: 40,
            child: ElevatedButton(
              child: Text(
                'Submit',
                style: _textStyle,
              ),
              onPressed: () async {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _titledField(String title, TextEditingController controller, double fieldWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: _textStyle,
        ),
        SizedBox(width: 5),
        Container(
          width: fieldWidth,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.start,
            style: _textStyle,
          ),
        ),
      ],
    );
  }
}
