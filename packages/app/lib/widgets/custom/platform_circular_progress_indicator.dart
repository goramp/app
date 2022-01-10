import 'package:universal_platform/universal_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformCircularProgressIndicator extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  const PlatformCircularProgressIndicator(this.color, {this.strokeWidth = 2.0})
      : super();

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isIOS
        ? const CupertinoActivityIndicator()
        : CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          );
  }
}
