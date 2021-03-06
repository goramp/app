import 'package:flutter/material.dart';

/// An animated sliding container, optimized to hide it's children when closed.
class AnimatedPanel extends StatefulWidget {
  final bool? isClosed;
  final double? closedX;
  final double? closedY;
  final double? duration;
  final Curve? curve;
  final Widget? child;

  const AnimatedPanel(
      {Key? key,
      this.isClosed,
      this.closedX,
      this.closedY,
      this.duration,
      this.curve,
      this.child})
      : super(key: key);

  @override
  _AnimatedPanelState createState() => _AnimatedPanelState();
}

class _AnimatedPanelState extends State<AnimatedPanel> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    Offset closePos = Offset(widget.closedX ?? 0, widget.closedY ?? 0);
    double duration = _isHidden && widget.isClosed! ? 0 : widget.duration!;
    return TweenAnimationBuilder(
      curve: widget.curve ?? Curves.easeOut,
      tween: Tween<Offset>(
        begin: !widget.isClosed! ? Offset.zero : closePos,
        end: !widget.isClosed! ? Offset.zero : closePos,
      ),
      duration: Duration(milliseconds: (duration * 1000).round()),
      builder: (_, Offset value, Widget? c) {
        _isHidden =
            widget.isClosed! && value == Offset(widget.closedX!, widget.closedY!);
        return _isHidden
            ? Container()
            : Transform.translate(offset: value, child: c);
      },
      child: widget.child,
    );
  }
}

extension AnimatedPanelExtensions on Widget {
  Widget animatedPanelX(
          {required double closeX, bool? isClosed, double duration = .35, Curve? curve}) =>
      animatedPanel(
          closePos: Offset(closeX, 0),
          isClosed: isClosed,
          curve: curve,
          duration: duration);

  Widget animatedPanelY(
          {required double closeY, bool? isClosed, double duration = .35, Curve? curve}) =>
      animatedPanel(
          closePos: Offset(0, closeY),
          isClosed: isClosed,
          curve: curve,
          duration: duration);

  Widget animatedPanel(
      {required Offset closePos, bool? isClosed, double duration = .35, Curve? curve}) {
    return AnimatedPanel(
        closedX: closePos.dx,
        closedY: closePos.dy,
        child: this,
        isClosed: isClosed,
        duration: duration,
        curve: curve);
  }
}
