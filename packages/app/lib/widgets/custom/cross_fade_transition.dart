import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../widgets/index.dart';

class CrossFadeTransition extends StatefulWidget {
  final SlideUpPanelScrollController? controller;
  final AnimationStatus status = AnimationStatus.completed;
  final Widget? child0;
  final Widget? child1;

  const CrossFadeTransition({this.controller, this.child0, this.child1});

  @override
  State<StatefulWidget> createState() {
    return CrossFadeTransitionState();
  }
}

class CrossFadeTransitionState extends State<CrossFadeTransition> {
  late Animatable<double> _forwardOpacityTween;
  late Animatable<double> _reverseOpacityTween;
  initState() {
    super.initState();
    widget.controller!.addTopListener(this.onTick);
    _forwardOpacityTween = Tween<double>(begin: 0.0, end: 1.0).chain(
      CurveTween(
        curve: const Interval(0.0, 0.1, curve: Curves.easeInOut),
      ),
    );
    _reverseOpacityTween = Tween<double>(begin: 1.0, end: 0.0).chain(
      CurveTween(
        curve: const Interval(0.9, 1.0, curve: Curves.easeInOut),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.headline6!,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: _reverseOpacityTween.transform(widget.controller!.value),
            child: widget.child1 ?? Container(),
          ),
          Opacity(
            opacity: _forwardOpacityTween.transform(widget.controller!.value),
            child: widget.child0 ?? Container(),
          ),
        ],
      ),
    );
  }
}
