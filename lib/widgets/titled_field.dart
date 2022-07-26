import 'package:flutter/material.dart';

class TitledField extends StatelessWidget {
  final String title;
  final double fieldWidth;
  final TextEditingController controller;

  const TitledField({
    Key? key,
    required this.title,
    required this.fieldWidth,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
        ),
        SizedBox(width: 10),
        Container(
          width: fieldWidth,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
