// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../custom/index.dart';

class AdaptiveBackground extends StatelessWidget {
  const AdaptiveBackground(
      {this.color, this.intensity = 25, this.child, this.borderRadius});

  final Color? color;
  final double intensity;
  final Widget? child;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: intensity, sigmaY: intensity),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Parallax extends StatefulWidget {
  final SlideUpPanelScrollController? controller;
  final AnimationStatus status = AnimationStatus.completed;
  final Widget? child;
  final double parallaxOffset;

  const _Parallax({this.controller, this.child, this.parallaxOffset = 0.1});

  @override
  State<StatefulWidget> createState() {
    return _ParallaxState();
  }
}

class _ParallaxState extends State<_Parallax> {
  initState() {
    super.initState();
    widget.controller!.addTopListener(this.onTick);
  }

  onTick() {
    if (mounted) {
      setState(() {});
    }
  }

  dispose() {
    widget.controller!.removeListener(this.onTick);
    super.dispose();
  }

  double _getParallax() {
    double value = 1 - (widget.controller?.value ?? 0);
    double top = -value *
        (widget.controller!.maxTop - widget.controller!.minTop) *
        widget.parallaxOffset;
    return top;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _getParallax(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: widget.child,
      ),
    );
  }
}

class PanelHeader extends StatelessWidget {
  final ValueNotifier<bool> hasElevation;
  final Widget? child;
  final BorderRadius headerRadius;
  PanelHeader(this.child, this.hasElevation, this.headerRadius);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: hasElevation,
      builder: (BuildContext context, bool hasElevation, _) {
        return Container(
          //elevation: hasElevation ? 2 : 0,
          child: child,
          //color: Colors.transparent,
          //borderRadius: headerRadius,
        );
      },
    );
  }
}

typedef WillDragCallback = bool Function();
final defaultWillDrag = () => true;
// One BackdropPanel is visible at a time. It's stacked on top of the
// the BackdropDemo.

// One BackdropPanel is visible at a time. It's stacked on top of the
// the BackdropDemo.
class BackdropPanel extends StatefulWidget {
  final VoidCallback? onTap;
  final GestureDragUpdateCallback? onVerticalDragUpdate;
  final GestureDragStartCallback? onVerticalDragStart;
  final GestureDragEndCallback? onVerticalDragEnd;
  final Widget? heading;
  final Widget? child;
  final Widget? instruction;
  final double headerHeight;
  final double headerElevation;
  final BorderRadius headerRadius;
  final SlideUpPanelScrollController? slideUpPanelController;

  const BackdropPanel(
      {Key? key,
      this.onTap,
      this.onVerticalDragUpdate,
      this.onVerticalDragEnd,
      this.onVerticalDragStart,
      this.heading,
      this.child,
      this.instruction,
      this.headerHeight = 56,
      this.headerElevation = 8,
      this.slideUpPanelController,
      this.headerRadius = const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      )})
      : super(key: key);
  @override
  _BackdropPanelState createState() => _BackdropPanelState();
}

class _BackdropPanelState extends State<BackdropPanel> {
  final ValueNotifier<bool> _hasElevation = ValueNotifier<bool>(false);

  late Animatable<BorderRadius> _borderRadiusTween;
  late Animatable<EdgeInsets> _paddingTween;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double topPadding = mediaQuery.padding.top;
    final double begin = topPadding / widget.slideUpPanelController!.maxTop;
    _borderRadiusTween = Tween<BorderRadius>(
        begin: BorderRadius.only(
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(0.0),
        ),
        end: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        )).chain(
      CurveTween(
        curve: Interval(0.0, begin, curve: Curves.linear),
      ),
    );
    _paddingTween = Tween<EdgeInsets>(
            begin: EdgeInsets.only(top: topPadding), end: EdgeInsets.zero)
        .chain(
      CurveTween(
        curve: Interval(0.0, begin, curve: Curves.linear),
      ),
    );
  }

  Widget _buildContent() {
    final radius =
        _borderRadiusTween.transform(widget.slideUpPanelController!.value);
    final _paddingTop =
        _paddingTween.transform(widget.slideUpPanelController!.value);
    return PhysicalShape(
      elevation: widget.headerElevation,
      color: Theme.of(context).bottomAppBarColor,
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(
          borderRadius: radius,
        ),
      ),
      child: Container(
        // borderRadius: radius,
        // color: Theme.of(context).canvasColor.withOpacity(0.89),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: _paddingTop,
                  height: widget.headerHeight + _paddingTop.top,
                ),
                Expanded(child: widget.child!),
              ],
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: widget.onVerticalDragUpdate,
              onVerticalDragEnd: widget.onVerticalDragEnd,
              onVerticalDragStart: widget.onVerticalDragStart,
              onTap: widget.onTap,
              child: Container(
                padding: _paddingTop,
                height: widget.headerHeight + _paddingTop.top,
                child: PanelHeader(
                  widget.heading,
                  _hasElevation,
                  widget.headerRadius,
                ),
                // decoration: BoxDecoration(
                //   border: Border(
                //     bottom: Divider.createBorderSide(context),
                //   ),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.instruction!,
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
    //return _buildContent();
  }
}

class HomeBackdrop extends StatefulWidget {
  const HomeBackdrop({
    this.frontHeading,
    this.frontOpenHeading,
    this.frontLayer,
    this.parallaxLayer,
    this.backLayer,
    this.dragEnabled = true,
    this.open = false,
    this.onClose,
    this.onOpen,
    this.parallaxEnabled = false,
    this.parallaxOffset = 0.1,
    this.backdropEnabled = true,
    required this.slideUpPanelController,
    this.willDragCallback,
    this.headerHeight: 56,
    this.headerElevation: 8,
    this.frontInstruction,
    this.headerRadius = const BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0),
    ),
  });
  final Widget? frontInstruction;
  final Widget? frontLayer;
  final Widget? frontHeading;
  final Widget? frontOpenHeading;
  final Widget? parallaxLayer;
  final Widget? backLayer;
  final VoidCallback? onClose;
  final VoidCallback? onOpen;
  final bool dragEnabled;
  final double parallaxOffset;
  final bool parallaxEnabled;
  final bool open;
  final bool backdropEnabled;
  final SlideUpPanelScrollController slideUpPanelController;
  final WillDragCallback? willDragCallback;

  final double headerHeight;
  final double headerElevation;
  final BorderRadius headerRadius;
  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<HomeBackdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'HomeBackdrop');
  bool _isOpen = false;

  void initState() {
    super.initState();
    _isOpen = widget.open;
  }

  void didChangeDependencies() {
    //if (widget.)
    //_maybeBuildSlideUpControl();
    super.didChangeDependencies();
  }

  void didUpdateWidget(HomeBackdrop old) {
    if (old.open != widget.open) {
      _isOpen = widget.open;
      if (_isOpen) {
        widget.slideUpPanelController.show();
      } else {
        widget.slideUpPanelController.dismiss();
      }
    }
    super.didUpdateWidget(old);
  }

  bool get _dragEnabled {
    if (widget.dragEnabled && widget.willDragCallback != null) {
      return widget.willDragCallback!();
    }
    return widget.dragEnabled;
  }

  void _maybeBuildSlideUpControl() {
    if (_isOpen) {
      widget.slideUpPanelController.show();
    } else {
      widget.slideUpPanelController.dismiss();
    }
  }

  _handleDragUpdate(DragUpdateDetails details) {
    if (!_dragEnabled) return;
    widget.slideUpPanelController.onExtDragUpdate(details);
  }

  void _handleDragStart(DragStartDetails details) {
    if (!_dragEnabled) return;
    widget.slideUpPanelController.onExtDragStart(details);
  }

  _handleDragEnd(DragEndDetails details) {
    if (!_dragEnabled) return;
    widget.slideUpPanelController.onExtDragEnd(details);
  }

  _handleTap() {
    if (_isOpen) {
      widget.slideUpPanelController.dismiss();
    } else {
      widget.slideUpPanelController.show();
    }
  }

  Widget? _buildHeader(BuildContext context) {
    if (widget.frontHeading != null && widget.frontOpenHeading != null) {
      return CrossFadeTransition(
        controller: widget.slideUpPanelController,
        child0: IgnorePointer(
          child: widget.frontHeading,
          ignoring: _isOpen,
        ),
        child1: IgnorePointer(
          child: widget.frontOpenHeading,
          ignoring: !_isOpen,
        ),
      );
    }
    return widget.frontHeading;
  }

  Widget _buildStack(BuildContext context) {
    final List<Widget> layers = <Widget>[
      // Back layer
      widget.parallaxLayer != null
          ? _Parallax(
              parallaxOffset: widget.parallaxOffset,
              controller: widget.slideUpPanelController,
              child: widget.parallaxLayer)
          : Container(),
      widget.backLayer!,
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        onVerticalDragStart: _handleDragStart,
        child: IgnorePointer(),
        excludeFromSemantics: true,
      ),
      widget.backdropEnabled
          ? TintedView(controller: widget.slideUpPanelController)
          : Container(),
      SlideUpPanel(
          scrollController: widget.slideUpPanelController,
          onClosing: () {
            if (widget.onClose != null) {
              widget.onClose!();
            }
            if (!_isOpen) {
              return;
            }
            _isOpen = false;
          },
          onOpening: () {
            if (_isOpen) {
              return;
            }
            if (widget.onOpen != null) {
              widget.onOpen!();
            }
            _isOpen = true;
          },
          builder: (BuildContext context) {
            return BackdropPanel(
                heading: _buildHeader(context),
                child: widget.frontLayer,
                onVerticalDragUpdate: _handleDragUpdate,
                onVerticalDragEnd: _handleDragEnd,
                onVerticalDragStart: _handleDragStart,
                onTap: _handleTap,
                slideUpPanelController: widget.slideUpPanelController,
                headerHeight: widget.headerHeight,
                headerElevation: widget.headerElevation,
                instruction: widget.frontInstruction,
                headerRadius: widget.headerRadius);
          }),
    ];

    return Stack(
      fit: StackFit.expand,
      key: _backdropKey,
      children: layers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildStack(context);
  }
}
