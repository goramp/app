import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/index.dart';

class DialogHelper {
  static Future<String?> showAlertDialog(
      BuildContext context, List<String> actions,
      {String title = '',
      String content = '',
      int? cancelIndex,
      bool barrierDismissible = false}) async {
    List<Widget> actionWidgets = [];
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subtitle1!
        .copyWith(color: theme.textTheme.caption!.color);
    final TextStyle? dialogTitleTextStyle = theme.textTheme.headline6;
    for (int i = 0; i < actions.length; i++) {
      // if (UniversalPlatform.isAndroid) {
      //   actionWidgets.add(FlatButton(
      //       shape: RoundedRectangleBorder(borderRadius: kMediumBorderRadius),
      //       child: Text(actions[i]),
      //       onPressed: () {
      //         Navigator.pop(context, actions[i]);
      //       }));
      // } else if (UniversalPlatform.isIOS) {
      //   actionWidgets.add(CupertinoDialogAction(
      //     child: Text(actions[i]),
      //     isDestructiveAction: i == cancelIndex,
      //     onPressed: () {
      //       Navigator.pop(context, actions[i]);
      //     },
      //   ));
      // }
      actionWidgets.add(FlatButton(
          shape: RoundedRectangleBorder(borderRadius: kMediumBorderRadius),
          child: Text(actions[i]),
          onPressed: () {
            Navigator.pop(context, actions[i]);
          }));
    }
    // if (UniversalPlatform.isAndroid) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          title,
          style: dialogTitleTextStyle,
        ),
        content: Text(
          content,
          style: dialogTextStyle,
        ),
        actions: actionWidgets,
      ),
    );
    // } else {
    //   return showDialog(
    //     context: context,
    //     barrierDismissible: barrierDismissible,
    //     builder: (BuildContext context) => CupertinoAlertDialog(
    //           title: Text(
    //             title,
    //             style: dialogTitleTextStyle,
    //           ),
    //           content: Text(
    //             content,
    //             style: dialogTextStyle,
    //           ),
    //           actions: actionWidgets,
    //         ),
    //   );
    // }
  }
}
