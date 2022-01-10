import 'dart:math';
import 'package:browser_adapter/browser_adapter.dart';
import 'package:flutter/material.dart';

class PageRevealRoute extends PageRouteBuilder {
  final Widget? widget;
  PageRevealRoute({this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget!;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return PageReveal(
              revealPercent: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Interval(
                    0.00,
                    1.0,
                    curve: Curves.linear,
                  ),
                ),
              ),
              child: child);
        });
}

class PageReveal extends StatelessWidget {
  final Animation<double>? revealPercent;
  final Widget? child;

  PageReveal({
    this.revealPercent,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: revealPercent!,
        builder: (_, __) {
          return Opacity(
            opacity: revealPercent!.value,
            child: isClipSupported()
                ? ClipOval(
                    clipBehavior: Clip.hardEdge,
                    clipper: CircleRevealClipper(revealPercent!.value),
                    child: child,
                  )
                : child,
          );
        });
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;

  CircleRevealClipper(
    this.revealPercent,
  );

  @override
  Rect getClip(Size size) {
    final epicenter = new Offset(size.width / 2, size.height * 0.9);

    // Calculate distance from epicenter to the top left corner to make sure we fill the screen.
    double theta = atan(epicenter.dy / epicenter.dx);
    final distanceToCorner = epicenter.dy / sin(theta);

    final radius = distanceToCorner * revealPercent;
    final diameter = 2 * radius;

    return new Rect.fromLTWH(
        epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
