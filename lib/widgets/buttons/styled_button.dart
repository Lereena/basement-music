import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool autofocus;
  final FocusNode? focusNode;

  const StyledButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.autofocus = false,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(title, style: TextStyle(fontSize: 18)),
        ),
        focusNode: focusNode,
        autofocus: autofocus,
        onPressed: onPressed,
      ),
    );
  }
}
