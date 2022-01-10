import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

extension SVGWeb on BuildContext {
  bool get isWebSvg =>
      UniversalPlatform.isWeb &&
      !(const bool.fromEnvironment('FLUTTER_WEB_USE_SKIA',
          defaultValue: false));
}
