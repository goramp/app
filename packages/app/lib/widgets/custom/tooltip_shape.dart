// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui show lerpDouble;
import 'package:flutter/material.dart';

enum TooltipArrowLocation {
  top,
  bottom,
}

enum TooltipArrowAlignment {
  start,
  center,
  end,
}

class ToolTipPainter extends CustomPainter {
  ToolTipPainter(
      {this.borderRadius = BorderRadius.zero,
      this.color,
      this.arrowHeight = 0.0,
      this.arrowWidth = 0.0,
      this.arrowLocation = TooltipArrowLocation.bottom,
      this.horizontalOffset = 0.0,
      this.arrowAlignment = TooltipArrowAlignment.center,
      this.textDirection = TextDirection.ltr});

  final TooltipArrowLocation arrowLocation;
  final double arrowHeight;
  final double arrowWidth;
  final double horizontalOffset;
  final TooltipArrowAlignment arrowAlignment;
  final Color? color;
  final BorderRadiusGeometry borderRadius;
  final TextDirection textDirection;
  @override
  bool hitTest(Offset point) => true; // Hitting the rectangle is fine enough.

  @override
  bool shouldRepaint(ToolTipPainter oldPainter) {
    return oldPainter.color != color ||
        oldPainter.arrowHeight != arrowHeight ||
        oldPainter.arrowWidth != arrowWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color!;
    Rect r = Rect.fromLTRB(0, 0, size.width, size.height);
    Rect rect = rectFrom(r)!;
    double midpoint = calculateArrowMidPoint(size);
    canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect), paint);
    drawTriangle(midpoint, canvas, rect, paint);
  }

  double calculateArrowMidPoint(Size size) {
    double middle = 0.0;
    switch (arrowAlignment) {
      case TooltipArrowAlignment.start:
        middle = horizontalOffset == 0 ? size.width / 4 : horizontalOffset;
        break;
      case TooltipArrowAlignment.center:
        middle = size.width / 2;
        break;
      case TooltipArrowAlignment.end:
        middle = size.width;
        middle -= (horizontalOffset == 0 ? size.width / 4 : horizontalOffset);
        break;
    }
    return middle;
  }

  Rect? rectFrom(Rect rect) {
    Rect? r;
    switch (arrowLocation) {
      case TooltipArrowLocation.bottom:
        r = Rect.fromLTRB(
            rect.left, rect.top, rect.right, rect.bottom - arrowHeight);
        break;
      case TooltipArrowLocation.top:
        r = Rect.fromLTRB(
            rect.left, rect.top + arrowHeight, rect.right, rect.bottom);
        break;
    }
    return r;
  }

  void drawTriangle(double midpoint, Canvas canvas, Rect rect, Paint paint) {
    final double halfBase = arrowWidth / 2.0;
    late List<Offset> points;
    switch (arrowLocation) {
      case TooltipArrowLocation.bottom:
        points = <Offset>[
          Offset(midpoint, rect.bottom + arrowHeight),
          Offset(midpoint - halfBase, rect.bottom),
          Offset(midpoint + halfBase, rect.bottom),
        ];
        break;
      case TooltipArrowLocation.top:
        points = <Offset>[
          Offset(midpoint, 0.0),
          Offset(midpoint - halfBase, arrowHeight),
          Offset(midpoint + halfBase, arrowHeight),
        ];
        break;
    }
    canvas.drawPath(Path()..addPolygon(points, true), paint);
  }
}

class ToolTipClipper extends CustomClipper<Path> {
  ToolTipClipper(
      {this.borderRadius = BorderRadius.zero,
      this.arrowHeight = 0.0,
      this.arrowWidth = 0.0,
      this.arrowLocation = TooltipArrowLocation.bottom,
      this.horizontalOffset = 0.0,
      this.arrowAlignment = TooltipArrowAlignment.center,
      this.textDirection = TextDirection.ltr});

  final TooltipArrowLocation arrowLocation;
  final double arrowHeight;
  final double arrowWidth;
  final double horizontalOffset;
  final TooltipArrowAlignment arrowAlignment;
  final BorderRadiusGeometry borderRadius;
  final TextDirection textDirection;

  @override
  bool shouldReclip(ToolTipClipper clipper) {
    return clipper.arrowHeight != arrowHeight ||
        clipper.arrowWidth != arrowWidth;
  }

  @override
  Path getClip(Size size) {
    Rect r = Rect.fromLTRB(0, 0, size.width, size.height);
    Rect rect = rectFrom(r)!;
    double midpoint = calculateArrowMidPoint(size);
    return Path()
      ..addRRect(borderRadius.resolve(textDirection).toRRect(rect))
      ..addPolygon(drawTriangle(midpoint, rect)!, true);
  }

  double calculateArrowMidPoint(Size size) {
    double middle = 0.0;
    switch (arrowAlignment) {
      case TooltipArrowAlignment.start:
        middle = horizontalOffset == 0 ? size.width / 4 : horizontalOffset;
        break;
      case TooltipArrowAlignment.center:
        middle = size.width / 2;
        break;
      case TooltipArrowAlignment.end:
        middle = size.width;
        middle -= (horizontalOffset == 0 ? size.width / 4 : horizontalOffset);
        break;
    }
    return middle;
  }

  Rect? rectFrom(Rect rect) {
    Rect? r;
    switch (arrowLocation) {
      case TooltipArrowLocation.bottom:
        r = Rect.fromLTRB(
            rect.left, rect.top, rect.right, rect.bottom - arrowHeight);
        break;
      case TooltipArrowLocation.top:
        r = Rect.fromLTRB(
            rect.left, rect.top + arrowHeight, rect.right, rect.bottom);
        break;
    }
    return r;
  }

  List<Offset>? drawTriangle(double midpoint, Rect rect) {
    final double halfBase = arrowWidth / 2.0;
    List<Offset>? points;
    switch (arrowLocation) {
      case TooltipArrowLocation.bottom:
        points = <Offset>[
          Offset(midpoint, rect.bottom + arrowHeight),
          Offset(midpoint - halfBase, rect.bottom),
          Offset(midpoint + halfBase, rect.bottom),
        ];
        break;
      case TooltipArrowLocation.top:
        points = <Offset>[
          Offset(midpoint, 0.0),
          Offset(midpoint - halfBase, arrowHeight),
          Offset(midpoint + halfBase, arrowHeight),
        ];
        break;
    }
    return points;
  }
}

/// A rectangular border with rounded corners.
///
/// Typically used with [ShapeDecoration] to draw a box with a rounded
/// rectangle.
///
/// This shape can interpolate to and from [CircleBorder].
///
/// See also:
///
///  * [BorderSide], which is used to describe each side of the box.
///  * [Border], which, when used with [BoxDecoration], can also
///    describe a rounded rectangle.
///

class TooltipBorder extends ShapeBorder {
  /// Creates a rounded rectangle border.
  ///
  /// The arguments must not be null.
  const TooltipBorder({
    this.side = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
    this.arrowHeight = 0.0,
    this.arrowWidth = 0.0,
    this.arrowLocation = TooltipArrowLocation.bottom,
    this.horizontalOffset = 0.0,
    this.arrowAlignment = TooltipArrowAlignment.center,
  })  : assert(side != null),
        assert(borderRadius != null);
  final TooltipArrowLocation arrowLocation;

  /// The style of this border.
  final BorderSide side;

  /// The radii for each corner.
  final BorderRadiusGeometry borderRadius;
  final double? arrowHeight;
  final double? arrowWidth;
  final double horizontalOffset;
  final TooltipArrowAlignment arrowAlignment;
  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(side.width);
  }

  @override
  ShapeBorder scale(double t) {
    return TooltipBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    assert(t != null);
    if (a is TooltipBorder) {
      return TooltipBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius:
            BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
        arrowWidth: ui.lerpDouble(a.arrowWidth, arrowWidth, t),
        arrowHeight: ui.lerpDouble(a.arrowWidth, arrowHeight, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    assert(t != null);
    if (b is TooltipBorder) {
      return TooltipBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius:
            BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
        arrowWidth: ui.lerpDouble(arrowWidth, b.arrowWidth, t),
        arrowHeight: ui.lerpDouble(arrowWidth, b.arrowHeight, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(borderRadius
          .resolve(textDirection)
          .toRRect(rect)
          .deflate(side.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final double width = side.width;
        double midpoint = calculateArrowMidPoint(rect);
        if (width == 0.0) {
          Rect r = rectFrom(rect)!;
          Paint p = Paint()..color = side.color;
          canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(r), p);
          drawTriangle(midpoint, canvas, r, p);
        } else {
          Rect r = rectFrom(rect)!;
          final RRect outer = borderRadius.resolve(textDirection).toRRect(r);
          final RRect inner = outer.deflate(width);
          final Paint paint = Paint()..color = side.color;
          canvas.drawDRRect(outer, inner, paint);
          drawTriangle(midpoint, canvas, r, paint);
        }
    }
  }

  double calculateArrowMidPoint(Rect rect) {
    double middle = 0.0;
    switch (arrowAlignment) {
      case TooltipArrowAlignment.start:
        middle = horizontalOffset == 0 ? rect.width / 4 : horizontalOffset;
        break;
      case TooltipArrowAlignment.center:
        middle = rect.width / 2;
        break;
      case TooltipArrowAlignment.end:
        middle = rect.width;
        middle -= (horizontalOffset == 0 ? rect.width / 4 : horizontalOffset);
        break;
    }
    return middle;
  }

  Rect? rectFrom(Rect rect) {
    Rect? r;
    switch (arrowLocation) {
      case TooltipArrowLocation.bottom:
        r = Rect.fromLTRB(
            rect.left, rect.top, rect.right, rect.bottom - arrowHeight!);
        break;
      case TooltipArrowLocation.top:
        r = Rect.fromLTRB(
            rect.left, rect.top + arrowHeight!, rect.right, rect.bottom);
        break;
    }
    return r;
  }

  void drawTriangle(double midpoint, Canvas canvas, Rect rect, Paint paint) {
    final double halfBase = arrowWidth! / 2.0;
    late List<Offset> points;
    switch (arrowLocation) {
      case TooltipArrowLocation.bottom:
        points = <Offset>[
          Offset(midpoint, rect.height + arrowHeight!),
          Offset(midpoint - halfBase, rect.bottom),
          Offset(midpoint + halfBase, rect.bottom),
        ];
        break;
      case TooltipArrowLocation.top:
        points = <Offset>[
          Offset(midpoint, 0.0),
          Offset(midpoint - halfBase, arrowHeight!),
          Offset(midpoint + halfBase, arrowHeight!),
        ];
        break;
    }
    canvas.drawPath(Path()..addPolygon(points, true), paint);
  }

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;
    final TooltipBorder typedOther = other;
    return side == typedOther.side && borderRadius == typedOther.borderRadius;
  }

  @override
  int get hashCode => hashValues(side, borderRadius);

  @override
  String toString() {
    return '$runtimeType($side, $borderRadius)';
  }
}
