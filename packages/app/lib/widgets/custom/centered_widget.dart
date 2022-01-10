import 'package:flutter/material.dart';
import 'package:goramp/widgets/index.dart';
import 'package:sized_context/sized_context.dart';

class CenteredWidget extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final AlignmentGeometry alignment;
  const CenteredWidget(this.child,
      {this.maxWidth = 768, this.alignment = Alignment.center});
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      Widget body = child;
      if (isDisplayDesktop(context) || orientation == Orientation.landscape) {
        double width = maxWidth;
        if (context.widthInches > 8) {
          //Panel size gets a little bigger as the screen size grows
          width += (context.widthInches - 8) * 12;
        }
        body = Align(
          alignment: Alignment.center,
          child: Container(
            constraints: BoxConstraints(maxWidth: width),
            child: body,
          ),
        );
      }
      return body;
    });
  }
}
