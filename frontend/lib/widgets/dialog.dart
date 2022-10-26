import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const CustomDialog({
    super.key,
    required this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: width ?? 50.w,
        height: height ?? 50.h,
        child: child,
      ),
    );
  }
}
