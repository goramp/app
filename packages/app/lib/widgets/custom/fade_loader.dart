import 'package:flutter/material.dart';

class FadeLoader extends StatelessWidget {
  final bool? visible;

  const FadeLoader({Key? key, this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible!,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: visible! ? 1.0 : 0.0,
        child: Container(
            constraints: BoxConstraints(maxHeight: 2.0),
            child: LinearProgressIndicator()),
      ),
    );
  }
}
