import 'package:flutter/material.dart';

import '../../interactors/track_interactor.dart';

class ExtractFromYoutube extends StatefulWidget {
  final Function onCancelPressed;
  ExtractFromYoutube({required this.onCancelPressed}) : super();

  @override
  State<ExtractFromYoutube> createState() => _ExtractFromYoutubeState();
}

class _ExtractFromYoutubeState extends State<ExtractFromYoutube> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final inputFieldWidth = MediaQuery.of(context).size.width / 2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Insert YouTube link to extract audio',
            style: TextStyle(fontSize: 24),
          ),
        ),
        SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: inputFieldWidth,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(height: 40),
        Container(
          alignment: Alignment.center,
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                'Extract',
                style: TextStyle(fontSize: 18),
              ),
            ),
            onPressed: () async {
              await uploadTrack(controller.text);
              setState(() => controller.text = "");
            },
          ),
        ),
        SizedBox(height: 20),
        TextButton(
          child: Text('Cancel'),
          onPressed: () => widget.onCancelPressed(),
        ),
      ],
    );
  }
}
