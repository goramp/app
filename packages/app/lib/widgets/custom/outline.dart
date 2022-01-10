import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

// Render the button's outline border using using the OutlineButton's
// border parameters and the button or buttonTheme's shape.
class OutlineBorder extends ShapeBorder
    implements MaterialStateProperty
    <ShapeBorder> {
  const OutlineBorder({
    required this.shape,
    required this.side,
  })  : assert(shape != null),
        assert(side != null);

  final ShapeBorder shape;
  final BorderSide side;

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(side.width);
  }

  @override
  ShapeBorder scale(double t) {
    return OutlineBorder(
      shape: shape.scale(t),
      side: side.scale(t),
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    assert(t != null);
    if (a is OutlineBorder) {
      return OutlineBorder(
        side: BorderSide.lerp(a.side, side, t),
        shape: ShapeBorder.lerp(a.shape, shape, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    assert(t != null);
    if (b is OutlineBorder) {
      return OutlineBorder(
        side: BorderSide.lerp(side, b.side, t),
        shape: ShapeBorder.lerp(shape, b.shape, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return shape.getInnerPath(rect.deflate(side.width),
        textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return shape.getOuterPath(rect, textDirection: textDirection);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        canvas.drawPath(shape.getOuterPath(rect, textDirection: textDirection),
            side.toPaint());
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is OutlineBorder && other.side == side && other.shape == shape;
  }

  @override
  int get hashCode => hashValues(side, shape);

  @override
  ShapeBorder resolve(Set<MaterialState> states) {
    return OutlineBorder(
        shape: shape,
        side: side.copyWith(
          color: MaterialStateProperty.resolveAs<Color>(side.color, states),
        ));
  }
}
