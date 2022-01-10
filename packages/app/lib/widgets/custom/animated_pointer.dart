import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

class AnimatedPointer extends StatefulWidget {
  final Color? color;
  final double size;

  AnimatedPointer({
    Key? key,
    this.color,
    this.size = 56.0,
  }): assert(size != null),
        super(key: key);

  @override
  _AnimatedPointerState createState() => _AnimatedPointerState();
}

class _AnimatedPointerState extends State<AnimatedPointer>
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
      child: Container(
        width: widget.size,
        height: widget.size,
        child: Icon(
          MdiIcons.chevronDoubleDown,
          size: 24,
          color: widget.color,
        ),
      ),
    );
  }

}