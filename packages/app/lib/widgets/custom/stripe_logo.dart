import 'package:flutter/material.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/index.dart';

class StripeLogo extends StatelessWidget {
  final double width;
  const StripeLogo({Key? key, this.width = 64}) : super(key: key);

  build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PlatformSvg.asset(
      isDark
          ? Constants.STRIPE_LOGO_WHITE_SVG
          : Constants.STRIPE_LOGO_BLURPLE_SVG,
      width: width,
    );
  }
}
