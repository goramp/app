import 'package:flutter/material.dart';
import 'package:goramp/widgets/index.dart';

extension Width on BuildContext {
  double get panelMaxWidth {
    final isSmallDesktop = isDisplaySmallDesktop(this);
    final scale = cappedTextScale(this);
    return (isSmallDesktop ? 400.0 : 450.0) + 100.0 * (scale - 1);
  }
}
