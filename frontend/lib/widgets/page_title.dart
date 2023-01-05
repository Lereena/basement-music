import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String text;

  const PageTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 18,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
