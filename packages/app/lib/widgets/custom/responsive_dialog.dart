// Copyright (c) 2018, codegrue. All rights reserved. Use of this source code
// is governed by the MIT license that can be found in the LICENSE file.
import 'dart:math' as math;

import 'package:flutter/material.dart';

// copied from flutter calendar picker
const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);
const double _datePickerHeaderLandscapeWidth = 152.0;
const double _datePickerHeaderPortraitHeight = 120.0;
const Size _portraitDialogSize = Size(330.0, 518.0);
const Size _landscapeDialogSize = Size(496.0, 346.0);

/// This is a support widget that returns an Dialog with checkboxes as a Widget.
/// It is designed to be used in the showDialog method of other fields.
class ResponsiveDialog extends StatefulWidget {
  ResponsiveDialog(
      {this.context,
      String? title,
      Widget? child,
      this.forcePortrait = false,
      double? maxLongSide,
      double? maxShortSide,
      this.hideButtons = false,
      this.okPressed,
      this.cancelPressed,
      this.header,
      this.portraitDialogSize = _portraitDialogSize,
      this.landscapeDialogSize = _landscapeDialogSize})
      : title = title ?? "Title Here",
        child = child ?? Text("Content Here");

  // Variables
  final BuildContext? context;
  final Widget? header;
  final Widget child;
  final bool forcePortrait;
  final bool hideButtons;
  final String title;
  final Size portraitDialogSize;
  final Size landscapeDialogSize;

  // Events
  final VoidCallback? cancelPressed;
  final VoidCallback? okPressed;

  @override
  _ResponsiveDialogState createState() => _ResponsiveDialogState();
}

class _ResponsiveDialogState extends State<ResponsiveDialog> {
  Widget header(BuildContext context, Orientation orientation) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // The header should use the primary color in light themes and surface color in dark
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final Color primarySurfaceColor =
        isDark ? colorScheme.surface : colorScheme.primary;
    final Color titleColor = colorScheme.brightness == Brightness.light
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final TextStyle? titleStyle = orientation == Orientation.landscape
        ? textTheme.headline5?.copyWith(color: titleColor)
        : textTheme.headline5?.copyWith(color: titleColor);

    final Text title = Text(
      widget.title,
      style: titleStyle,
      maxLines: orientation == Orientation.portrait ? 1 : 2,
      overflow: TextOverflow.ellipsis,
    );

    return Material(
      color: primarySurfaceColor,
      child: widget.header != null
          ? widget.header
          : Container(
              height: (orientation == Orientation.portrait)
                  ? _datePickerHeaderPortraitHeight
                  : null,
              width: (orientation == Orientation.landscape)
                  ? _datePickerHeaderLandscapeWidth
                  : null,
              child: Center(child: title),
              padding: EdgeInsets.all(20.0),
            ),
    );
  }

  Widget actionBar(BuildContext context) {
    if (widget.hideButtons) return Container();

    var localizations = MaterialLocalizations.of(context);

    return Container(
      alignment: AlignmentDirectional.centerEnd,
      constraints: const BoxConstraints(minHeight: 52.0),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: OverflowBar(
        spacing: 8,
        children: <Widget>[
          TextButton(
            child: Text(localizations.cancelButtonLabel),
            onPressed: () => (widget.cancelPressed == null)
                ? Navigator.of(context).pop()
                : widget.cancelPressed!(),
          ),
          TextButton(
            child: Text(localizations.okButtonLabel),
            onPressed: () => (widget.okPressed == null)
                ? Navigator.of(context).pop()
                : widget.okPressed!(),
          ),
        ],
      ),
    );
  }

  Size? _dialogSize(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    switch (orientation) {
      case Orientation.portrait:
        return _portraitDialogSize;
      case Orientation.landscape:
        return _landscapeDialogSize;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(context != null);

    var theme = Theme.of(context);
    final double textScaleFactor =
        math.min(MediaQuery.of(context).textScaleFactor, 1.3);
    // constrain the dialog from expanding to full screen
    final Size dialogSize = _dialogSize(context)!;

    return Dialog(
      child: AnimatedContainer(
        width: dialogSize.width,
        height: dialogSize.height,
        duration: _dialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: textScaleFactor,
          ),
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              assert(orientation != null);
              assert(context != null);

              if (widget.forcePortrait) orientation = Orientation.portrait;

              switch (orientation) {
                case Orientation.portrait:
                  return Column(
                    children: <Widget>[
                      header(context, orientation),
                      Expanded(
                        child: Container(
                          child: widget.child,
                        ),
                      ),
                      actionBar(context),
                    ],
                  );
                case Orientation.landscape:
                  return Row(
                    children: <Widget>[
                      header(context, orientation),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: widget.child,
                            ),
                            actionBar(context),
                          ],
                        ),
                      ),
                    ],
                  );
              }
            },
          ),
        ),
      ),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      clipBehavior: Clip.antiAlias,
    );
  }
}
