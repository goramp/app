import 'package:browser_adapter/browser_adapter.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlatformSvg {
  static Widget network(String url,
      {double? width,
      double? height,
      BoxFit fit = BoxFit.contain,
      Color? color,
      alignment = Alignment.center,
      String? semanticsLabel}) {
    if (kIsWeb) {
      final useCanvaskit = isCanvasKitRenderer();
      if (!useCanvaskit) {
        return Image.network(url,
            width: width,
            height: height,
            fit: fit,
            color: color,
            alignment: alignment,
            semanticLabel: semanticsLabel);
      }
    }
    return SvgPicture.network(url,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticsLabel: semanticsLabel);
  }

  static Widget asset(String assetName,
      {double? width,
      double? height,
      BoxFit fit = BoxFit.contain,
      Color? color,
      alignment = Alignment.center,
      String? semanticsLabel}) {
    if (kIsWeb) {
      final useCanvaskit = isCanvasKitRenderer();
      if (!useCanvaskit) {
        return Image.network("/assets/$assetName",
            width: width,
            height: height,
            fit: fit,
            color: color,
            alignment: alignment,
            semanticLabel: semanticsLabel);
      }
    }
    return SvgPicture.asset(assetName,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticsLabel: semanticsLabel);
  }
}

class PlatformImage {
  static Widget asset(String assetName,
      {double? width,
      double? height,
      BoxFit fit = BoxFit.contain,
      Color? color,
      alignment = Alignment.center,
      String? semanticsLabel}) {
    final ext = p.extension(assetName);
    if (ext == '.SVG' || ext == '.svg') {
      return PlatformSvg.asset(
        assetName,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
      );
    }
    return Image.asset(assetName,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticLabel: semanticsLabel);
  }
}
