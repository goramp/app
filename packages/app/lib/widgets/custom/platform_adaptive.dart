// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get _isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

/// App bar that uses iOS styling on iOS
class PlatformAdaptiveAppBar extends AppBar {
  PlatformAdaptiveAppBar({
    Key? key,
    TargetPlatform? platform,
    List<Widget>? actions,
    Widget? title,
    Widget? body,
  }) : super(
          key: key,
          elevation: platform == TargetPlatform.iOS ? 0.0 : 4.0,
          title: title,
          actions: actions,
        );
}

class AdaptiveSegmentedControl extends StatelessWidget {
  AdaptiveSegmentedControl({
    this.onValueChanged,
    this.children,
    this.groupValue,
  });

  final ValueChanged<int>? onValueChanged;
  final Map<int, Widget>? children;
  final int? groupValue;

  @override
  Widget build(BuildContext context) {
    if (_isIOS) {
      return CupertinoSegmentedControl<int>(
        children: children!,
        groupValue: groupValue,
        onValueChanged: onValueChanged!,
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final key in children!.keys)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: RaisedButton(
                child: children![key],
                color: groupValue == key
                    ? Theme.of(context).buttonTheme.colorScheme!.primary
                    : Color(0xffcccccc),
                onPressed: () {
                  onValueChanged!(key);
                },
              ),
            ),
        ],
      );
    }
  }
}

class AdaptiveBackground extends StatelessWidget {
  const AdaptiveBackground({this.color, this.intensity = 25, this.child});

  final Color? color;
  final double intensity;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: (_isIOS)
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: intensity, sigmaY: intensity),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                ),
                child: child,
              ),
            )
          : DecoratedBox(
              decoration: BoxDecoration(
                color: color,
              ),
              child: child,
            ),
    );
  }
}

// class AdaptivePageScaffold extends StatelessWidget {
//   const AdaptivePageScaffold({
//     @required this.title,
//     @required this.child,
//   })  : assert(title != null),
//         assert(child != null);

//   final String title;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     if (_isIOS) {
//       return AdaptiveTextTheme(
//         child: CupertinoPageScaffold(
//           navigationBar: CupertinoNavigationBar(
//             middle: Text(title),
//           ),
//           resizeToAvoidBottomInset: false,
//           child: child,
//         ),
//       );
//     } else {
//       return AdaptiveTextTheme(
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text(title),
//           ),
//           body: child,
//         ),
//       );
//     }
//   }
// }

/// Button that is Material on Android and Cupertino on iOS
/// On Android an icon button; on iOS, text is used
class PlatformAdaptiveNavButton extends StatelessWidget {
  PlatformAdaptiveNavButton({Key? key, this.child, this.icon, this.onPressed})
      : super(key: key);
  final Widget? child;
  final Widget? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoButton(
        child: child!,
        onPressed: onPressed,
      );
    } else {
      final ButtonStyle textButtonStyle = TextButton.styleFrom(
        elevation: 0,
        textStyle: theme.textTheme.button!.copyWith(fontWeight: FontWeight.bold),
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.zero
        // ),
      );
      return TextButton(
        child: child!,
        onPressed: onPressed,
        style: textButtonStyle,
        //shape: RoundedRectangleBorder(),
      );
    }
  }
}

class PlatformAdaptiveBackButton extends StatelessWidget {
  PlatformAdaptiveBackButton({Key? key, this.child, this.color, this.onPressed})
      : super(key: key);
  final Widget? child;
  final Color? color;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoButton(
        child: child != null
            ? child!
            : Icon(
                Icons.arrow_back_ios,
                color: color,
              ),
        onPressed: onPressed,
      );
    } else {
      return IconButton(
        icon: child != null
            ? child!
            : Icon(
                Icons.arrow_back,
                color: color,
              ),
        onPressed: onPressed,
      );
    }
  }
}

class PlatformAdaptiveContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? margin;

  PlatformAdaptiveContainer({Key? key, this.child, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: child,
      margin: margin,
      decoration: Theme.of(context).platform == TargetPlatform.iOS
          ? new BoxDecoration(
              border: new Border(top: new BorderSide(color: Colors.grey[200]!)))
          : null,
    );
  }
}

class PlatformChooser extends StatelessWidget {
  PlatformChooser({Key? key, this.iosChild, this.defaultChild});
  final Widget? iosChild;
  final Widget? defaultChild;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) return iosChild!;
    return defaultChild!;
  }
}

class PlatformDefaultText extends StatelessWidget {
  PlatformDefaultText({Key? key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS)
      return DefaultTextStyle(
          style: CupertinoTheme.of(context).textTheme.textStyle, child: child!);
    return child!;
  }
}
