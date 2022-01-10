import 'package:flutter/material.dart';
import 'dart:ui' as ui;

final double devicePixelRatio = ui.window.devicePixelRatio;
final ui.Size ls = ui.window.physicalSize / devicePixelRatio;
const double minimumVeriticalAspect = 9 / 16;
const double maximumVeriticalAspect = 2 / 3;

class MediaQueryHelper {
  static bool isLargeScreen(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size * devicePixelRatio;
    if (orientation == Orientation.portrait) {
      return size.height >= 1280;
    } else {
      return size.width >= 1280;
    }
  }

  static bool isHD(BuildContext context, Size size) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return size.height >= 720;
    } else {
      return size.width >= 720;
    }
  }

  static bool isVertical(BuildContext context, Size size) {
    // bool isVertical = size.aspectRatio >= minimumVeriticalAspect &&
    //     size.aspectRatio <= maximumVeriticalAspect;
    return size.aspectRatio < 1;
  }
}
