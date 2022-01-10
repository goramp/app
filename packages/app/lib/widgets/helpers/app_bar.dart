import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppBarHelper {
  static Widget buildAppBar(BuildContext context,
      {Widget? leading, Widget? title, Widget? trailing}) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoNavigationBar(
        leading: leading,
        middle: title,
        trailing: trailing,
      );
    } else {
      return AppBar(
        leading: leading,
        title: title,
        actions: [trailing!],
      );
    }
  }
}
