import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/index.dart';

class FadingLoader extends StatefulWidget {
  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;

  FadingLoader({
    Key? key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        assert(size != null),
        super(key: key);

  @override
  _FadingLoaderState createState() => _FadingLoaderState();
}

class _FadingLoaderState extends State<FadingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  final _duration = const Duration(milliseconds: 1400);

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: _duration,
    )..repeat();
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 2, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _item(0, .0),
            _item(1, .2),
            _item(2, .4),
            _item(3, .6),
          ],
        ),
      ),
    );
  }

  Widget _item(int index, double delay) {
    final _size = widget.size * 0.5;
    return FadeTransition(
      opacity:
          DelayTween(begin: 0.4, end: 1.0, delay: delay).animate(_scaleCtrl),
      child: SizedBox.fromSize(
        size: Size.square(_size),
        child: _itemBuilder(index),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return widget.itemBuilder != null
        ? widget.itemBuilder!(context, index)
        : DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          );
  }
}
