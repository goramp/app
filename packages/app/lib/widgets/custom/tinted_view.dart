import 'package:flutter/material.dart';
import 'sliding_up_panel_controller.dart';

class TintedView extends StatefulWidget {
  final SlideUpPanelScrollController? controller;
  final AnimationStatus status = AnimationStatus.completed;

  TintedView({this.controller});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TintedViewState();
  }
}

class _TintedViewState extends State<TintedView> {
  static final Animatable<double> _frontOpacityTween =
      Tween<double>(begin: 0.2, end: 0.0).chain(
    CurveTween(
      curve: const Interval(0.0, 0.9, curve: Curves.fastOutSlowIn),
    ),
  );


  initState() {
    super.initState();
    widget.controller!.addTopListener(this.onTick);
  }

  onTick() {
    if (mounted) {
      setState(() {
      });
    }
  }

  dispose() {
    widget.controller!.removeListener(this.onTick);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opacity = _frontOpacityTween.transform(widget.controller!.value);
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: Container(
          color: Colors.black,
        ),
      ),
    );
  }
}
