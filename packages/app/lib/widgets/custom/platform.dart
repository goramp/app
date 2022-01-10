import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';


abstract class PlatformWidget<I extends Widget,A extends Widget> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isAndroid) {
      return createAndroidWidget(context);
    } else if (UniversalPlatform.isIOS) {
      return createIosWidget(context);
    }
    return new Container();
  }

  I createIosWidget(BuildContext context);

  A createAndroidWidget(BuildContext context);

}