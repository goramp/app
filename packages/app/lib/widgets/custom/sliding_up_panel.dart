// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'sliding_up_panel_controller.dart';

const Duration _kBottomSheetDuration = Duration(milliseconds: 200);

/// A material design bottom sheet.
///
/// There are two kinds of bottom sheets in material design:
///
///  * _Persistent_. A persistent bottom sheet shows information that
///    supplements the primary content of the app. A persistent bottom sheet
///    remains visible even when the user interacts with other parts of the app.
///    Persistent bottom sheets can be created and displayed with the
///    [ScaffoldState.showBottomSheet] function or by specifying the
///    [Scaffold.bottomSheet] constructor parameter.
///
///  * _Modal_. A modal bottom sheet is an alternative to a menu or a dialog and
///    prevents the user from interacting with the rest of the app. Modal bottom
///    sheets can be created and displayed with the [showModalBottomSheet]
///    function.
///
/// The [BottomSheet] widget itself is rarely used directly. Instead, prefer to
/// create a persistent bottom sheet with [ScaffoldState.showBottomSheet] or
/// [Scaffold.bottomSheet], and a modal bottom sheet with [showModalBottomSheet].
///
/// See also:
///
///  * [ScaffoldState.showBottomSheet]
///  * [showModalBottomSheet]
///  * <https://material.google.com/components/bottom-sheets.html>
class _SlideUpPanel extends StatefulWidget {
  /// Creates a bottom sheet.
  ///
  /// Typically, bottom sheets are created implicitly by
  /// [ScaffoldState.showBottomSheet], for persistent bottom sheets, or by
  /// [showModalBottomSheet], for modal bottom sheets.
  const _SlideUpPanel(
      {Key? key,
      required this.scrollController,
      required this.onClosing,
      required this.onOpening,
      required this.builder})
      : assert(onClosing != null),
        assert(scrollController != null),
        assert(builder != null),
        super(key: key);

  /// The [BottomSheetScrollController] that will act as the [PrimaryScrollController]
  /// for this [BottomSheet], controlling its height and its child's scroll offset.
  final SlideUpPanelScrollController scrollController;

  /// Called when the bottom sheet begins to close.
  ///
  /// A bottom sheet might be prevented from closing (e.g., by user
  /// interaction) even after this callback is called. For this reason, this
  /// callback might be call multiple times for a given bottom sheet.
  final VoidCallback onClosing;

  final VoidCallback? onOpening;

  /// A builder for the contents of the sheet.
  ///
  /// The bottom sheet will wrap the widget produced by this builder in a
  /// [Material] widget.
  final WidgetBuilder builder;

  @override
  _SlideUpPanelState createState() => _SlideUpPanelState();
}

class _SlideUpPanelState extends State<_SlideUpPanel> {
  bool _isClosed = false;
  @override
  void initState() {
    super.initState();
    widget.scrollController.addTopListener(_maybeCloseSlideUpPanel);
    _isClosed = widget.scrollController.top >= widget.scrollController.maxTop;
  }

  void _maybeCloseSlideUpPanel() {
    // print("scroll top: ${widget.scrollController.top}");
    // print("max top: ${widget.scrollController.maxTop}");
    if (widget.scrollController.top >= widget.scrollController.maxTop) {
      //print("should close: $_isClosed");
      // onClosing is asserted not null
      // if (_isClosed) {
      //   return;
      // }
      // _isClosed = true;
      widget.onClosing();
    } else {
      // if (widget.scrollController.top <= widget.scrollController.minTop)
      //print("should open");
      // if (!_isClosed) {
      //   return;
      // }
      // _isClosed = false;
      widget.onOpening!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: widget.scrollController,
      child: SizedBox.expand(
        child: widget.builder(context),
      ),
    );
  }

  @override
  void dispose() {
    widget.scrollController.removeTopListener(_maybeCloseSlideUpPanel);
    super.dispose();
  }
}

// PERSISTENT BOTTOM SHEETS

// See scaffold.dart

// MODAL BOTTOM SHEETS

class _SlideUpPanelLayout extends SingleChildLayoutDelegate {
  _SlideUpPanelLayout(this.top);

  final double top;

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(constraints.maxWidth, top);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, top);
  }

  @override
  bool shouldRelayout(_SlideUpPanelLayout oldDelegate) {
    return top != oldDelegate.top;
  }
}

class SlideUpPanel<T> extends StatefulWidget {
  const SlideUpPanel({
    Key? key,
    this.onClosing,
    this.onOpening,
    required this.builder,
    required this.scrollController,
  })  : assert(scrollController != null),
        super(key: key);
  final VoidCallback? onClosing;
  final VoidCallback? onOpening;
  final SlideUpPanelScrollController scrollController;
  final WidgetBuilder builder;

  /// Creates a [SlideUpPanelScrollController] suitable for animating the
  /// [SlideUpPanel].
  static SlideUpPanelScrollController createScrollController({
    double maxTop = 0.0,
    double initialTop = 0.0,
    double? midTop,
    double minTop = 0.0,
    required TickerProvider vsync,
  }) {
    assert(minTop != null);
    assert(maxTop != null);
    return SlideUpPanelScrollController(
        debugLabel: 'SlideUpPanelScrollController',
        initialTop: initialTop,
        maxTop: maxTop,
        minTop: minTop,
        midTop: midTop,
        vsync: vsync);
  }

  @override
  SlideUpPanelState<T> createState() => SlideUpPanelState<T>();
}

class SlideUpPanelState<T> extends State<SlideUpPanel<T>> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addTopListener(_rebuild);
  }

  /// Rebuild the sheet when the [BottomSheetScrollController.top] value has changed.
  void _rebuild() {
    setState(() {
      /* state is contained in BottomSheetScrollController.top */
      // print('top ${widget.scrollController.top}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    String routeLabel;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      routeLabel = '';
    } else {
      routeLabel = localizations.dialogLabel;
    }
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: routeLabel,
      explicitChildNodes: true,
      child: CustomSingleChildLayout(
        delegate: _SlideUpPanelLayout(widget.scrollController.top),
        child: _SlideUpPanel(
          onOpening: widget.onOpening,
          onClosing: widget.onClosing!,
          builder: widget.builder,
          scrollController: widget.scrollController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.scrollController.removeTopListener(_rebuild);
    super.dispose();
  }
}
