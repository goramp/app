
import 'package:flutter/material.dart';

class DividedRow extends StatelessWidget {
  final String? title;
  final double? verticalHeight;
  final bool borderTop;
  final bool borderBottom;
  final Widget? child;
  final Color backgroundColor;
  const DividedRow({
    Key? key,
    this.title,
    this.child,
    this.verticalHeight,
    this.borderBottom = false,
    this.borderTop = false,
    this.backgroundColor = Colors.white,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: verticalHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
            bottom: borderBottom
                ? Divider.createBorderSide(context)
                : BorderSide.none,
            top: borderTop
                ? Divider.createBorderSide(context)
                : BorderSide.none),
      ),
      child: child,
    );
  }
}
