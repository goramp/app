import 'package:flutter/material.dart';
import 'package:browser_adapter/browser_adapter.dart';
import 'package:goramp/widgets/index.dart';

class FadeAnimationPage extends Page {
  final Widget? child;

  const FadeAnimationPage(
      {Key? key,
      this.child,
      String? name,
      Object? arguments,
      String? restorationId})
      : super(
            key: key as LocalKey?,
            name: name,
            arguments: arguments,
            restorationId: restorationId);

  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        var curveTween = CurveTween(curve: Curves.easeIn);
        return FadeTransition(
          opacity: animation.drive(curveTween),
          child: child,
        );
      },
    );
  }
}

class RevealAnimationPage extends Page {
  final Widget? child;

  const RevealAnimationPage(
      {Key? key,
      this.child,
      String? name,
      Object? arguments,
      String? restorationId})
      : super(
            key: key as LocalKey?,
            name: name,
            arguments: arguments,
            restorationId: restorationId);
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        settings: this,
        barrierColor: Colors.black26,
        barrierDismissible: true,
        maintainState: true,
        pageBuilder: (context, animation, animation2) {
          return child!;
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          if (isClipSupported()) {
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
                      curve: Curves.easeIn,
                    ),
                  ),
                ),
                child: child);
          }
          var curveTween = CurveTween(curve: Curves.easeIn);
          return FadeTransition(
            opacity: animation.drive(curveTween),
            child: child,
          );
        });
  }
}
