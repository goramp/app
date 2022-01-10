import 'package:flutter/material.dart';

/// An analogue of the [AnimatedSwitcher], but based on explicit [animation] property
class AnimationSwitcher extends StatelessWidget {
  const AnimationSwitcher({
    Key? key,
    required this.child1,
    required this.child2,
    required this.animation,
  })  : assert(child1 != null),
        assert(child2 != null),
        assert(animation != null),
        super(key: key);

  final Widget child1;
  final Widget child2;
  final Animation animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) => Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            ignoring: animation.status == AnimationStatus.forward ||
                animation.status == AnimationStatus.completed,
            child: FadeTransition(
              opacity: Tween(begin: 1.0, end: 0.0).animate(animation as Animation<double>),
              child: child1,
            ),
          ),
          IgnorePointer(
            ignoring: animation.status == AnimationStatus.reverse ||
                animation.status == AnimationStatus.dismissed,
            child: FadeTransition(
              opacity: animation as Animation<double>,
              child: child2,
            ),
          ),
        ],
      ),
    );
  }
}
