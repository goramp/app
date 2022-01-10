import 'package:flutter/material.dart';
import 'package:browser_adapter/browser_adapter.dart';
import 'package:universal_platform/universal_platform.dart';

extension DividerWidth on BuildContext {
  double get dividerHairLineWidth {
    if (UniversalPlatform.isWeb && !isCanvasKitRenderer()) {
      return 1.0;
    }
    return 0.5;
  }
}
