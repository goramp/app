// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'tooltip_shape.dart';

const Duration _kFadeDuration = Duration(milliseconds: 200);
const Duration _kShowDuration = Duration(milliseconds: 1500);

/// A material design tooltip.
///
/// ArrowTooltips provide text labels that help explain the function of a button or
/// other user interface action. Wrap the button in a [ArrowTooltip] widget to
/// show a label when the widget long pressed (or when the user takes some
/// other appropriate action).
///
/// Many widgets, such as [IconButton], [FloatingActionButton], and
/// [PopupMenuButton] have a `tooltip` property that, when non-null, causes the
/// widget to include a [ArrowTooltip] in its build.
///
/// ArrowTooltips improve the accessibility of visual widgets by proving a textual
/// representation of the widget, which, for example, can be vocalized by a
/// screen reader.
///
/// See also:
///
///  * <https://material.google.com/components/tooltips.html>
class ArrowTooltip extends StatefulWidget {
  /// Creates a tooltip.
  ///
  /// By default, tooltips prefer to appear below the [child] widget when the
  /// user long presses on the widget.
  ///
  /// The [message] argument must not be null.
  const ArrowTooltip(
      {Key? key,
      required this.message,
      this.height = 32.0,
      this.padding = const EdgeInsets.all(8.0),
      this.verticalOffset = 24.0,
      this.preferBelow = false,
      this.excludeFromSemantics = false,
      this.child})
      : assert(message != null),
        assert(height != null),
        assert(padding != null),
        assert(verticalOffset != null),
        assert(preferBelow != null),
        assert(excludeFromSemantics != null),
        super(key: key);

  /// The text to display in the tooltip.
  final String message;

  /// The amount of vertical space the tooltip should occupy (inside its padding).
  final double height;

  /// The amount of space by which to inset the child.
  ///
  /// Defaults to 16.0 logical pixels in each direction.
  final EdgeInsetsGeometry padding;

  /// The amount of vertical distance between the widget and the displayed tooltip.
  final double verticalOffset;

  /// Whether the tooltip defaults to being displayed below the widget.
  ///
  /// Defaults to true. If there is insufficient space to display the tooltip in
  /// the preferred direction, the tooltip will be displayed in the opposite
  /// direction.
  final bool preferBelow;

  /// Whether the tooltip's [message] should be excluded from the semantics
  /// tree.
  final bool excludeFromSemantics;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget? child;

  @override
  ArrowTooltipState createState() => ArrowTooltipState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('message', message, showName: false));
    properties.add(DoubleProperty('vertical offset', verticalOffset));
    // properties.add(FlagProperty('position',
    //     value: preferBelow, ifTrue: 'below', ifFalse: 'above', showName: true));
  }
}

class ArrowTooltipState extends State<ArrowTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  OverlayEntry? _entry;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kFadeDuration, vsync: this)
      ..addStatusListener(_handleStatusChanged);
  }

  void hide() {
    _controller.reverse();
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) _removeEntry();
  }

  /// Shows the tooltip if it is not already visible.
  ///
  /// Returns `false` when the tooltip was already visible.
  bool ensureArrowTooltipVisible() {
    if (_entry != null) {
      _timer?.cancel();
      _timer = null;
      _controller.forward();
      return false; // Already visible.
    }
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset target = box.localToGlobal(box.size.center(Offset.zero));
    // We create this widget outside of the overlay entry's builder to prevent
    // updated values from happening to leak into the overlay when the overlay
    // rebuilds.
    final Widget overlay = _ArrowTooltipOverlay(
        message: widget.message,
        height: widget.height,
        padding: widget.padding as EdgeInsets?,
        animation:
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
        target: target,
        verticalOffset: widget.verticalOffset,
        preferBelow: widget.preferBelow);
    _entry = OverlayEntry(builder: (BuildContext context) => overlay);
    Overlay.of(context, debugRequiredFor: widget)!.insert(_entry!);
    GestureBinding.instance!.pointerRouter.addGlobalRoute(_handlePointerEvent);
    SemanticsService.tooltip(widget.message);
    _controller.forward();
    return true;
  }

  void _removeEntry() {
    assert(_entry != null);
    _timer?.cancel();
    _timer = null;
    _entry!.remove();
    _entry = null;
    GestureBinding.instance!.pointerRouter
        .removeGlobalRoute(_handlePointerEvent);
  }

  void _handlePointerEvent(PointerEvent event) {
    assert(_entry != null);
    if (event is PointerUpEvent || event is PointerCancelEvent)
      _timer ??= Timer(_kShowDuration, _controller.reverse);
    else if (event is PointerDownEvent) _controller.reverse();
  }

  @override
  void deactivate() {
    if (_entry != null) _controller.reverse();
    super.deactivate();
  }

  @override
  void dispose() {
    if (_entry != null) _removeEntry();
    _controller.dispose();
    super.dispose();
  }

  void show() {
    final bool tooltipCreated = ensureArrowTooltipVisible();
    if (tooltipCreated) Feedback.forLongPress(context);
  }

  @override
  Widget build(BuildContext context) {
    assert(Overlay.of(context, debugRequiredFor: widget) != null);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: show,
      excludeFromSemantics: true,
      child: Semantics(
        label: widget.excludeFromSemantics ? null : widget.message,
        child: widget.child,
      ),
    );
  }
}

/// A delegate for computing the layout of a tooltip to be displayed above or
/// bellow a target specified in the global coordinate system.
class _ArrowTooltipPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates a delegate for computing the layout of a tooltip.
  ///
  /// The arguments must not be null.
  _ArrowTooltipPositionDelegate({
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
  })  : assert(target != null),
        assert(verticalOffset != null),
        assert(preferBelow != null);

  /// The offset of the target the tooltip is positioned near in the global
  /// coordinate system.
  final Offset target;

  /// The amount of vertical distance between the target and the displayed
  /// tooltip.
  final double verticalOffset;

  /// Whether the tooltip defaults to being displayed below the widget.
  ///
  /// If there is insufficient space to display the tooltip in the preferred
  /// direction, the tooltip will be displayed in the opposite direction.
  final bool preferBelow;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionDependentBox(
      size: size,
      childSize: childSize,
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
    );
  }

  @override
  bool shouldRelayout(_ArrowTooltipPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset ||
        preferBelow != oldDelegate.preferBelow;
  }
}

class _ArrowTooltipOverlay extends StatelessWidget {
  const _ArrowTooltipOverlay({
    Key? key,
    this.message,
    this.height,
    this.padding,
    this.animation,
    this.target,
    this.verticalOffset,
    this.preferBelow,
  }) : super(key: key);

  final String? message;
  final double? height;
  final EdgeInsets? padding;
  final Animation<double>? animation;
  final Offset? target;
  final double? verticalOffset;
  final bool? preferBelow;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomSingleChildLayout(
          delegate: _ArrowTooltipPositionDelegate(
            target: target!,
            verticalOffset: verticalOffset!,
            preferBelow: preferBelow!,
          ),
          child: FadeTransition(
            opacity: animation!,
            child: Opacity(
              opacity: 0.9,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height!),
                child: PhysicalShape(
                  clipper: ToolTipClipper(
                    borderRadius: BorderRadius.circular(8.0),
                    arrowHeight: 8.0,
                    arrowWidth: 16.0,
                  ),
                  color: Colors.grey[700]!,
                  elevation: 8.0,
                  child: Padding(
                    padding: padding!.copyWith(bottom: padding!.bottom + 8.0),
                    child: Center(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Text(
                        message!,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: 12.0, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
