import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final Widget child;

  CustomDialog({Key? key, required this.child}) : super(key: key);

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.child,
          ],
        ),
      ),
    );
  }
}
