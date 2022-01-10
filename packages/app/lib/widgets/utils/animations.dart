import 'package:flutter/widgets.dart';

Widget crossFade(Widget first, Widget second, bool shouldSwitch) {
  return AnimatedCrossFade(
    firstChild: first,
    secondChild: second,
    firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
    secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
    sizeCurve: Curves.fastOutSlowIn,
    crossFadeState:
    shouldSwitch ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    duration: const Duration(milliseconds: 200),
  );
}