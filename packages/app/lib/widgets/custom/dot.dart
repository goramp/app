import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final double spacing;
  final Size size;
  final Color color;
  Dot(
      {this.color = Colors.white,
      this.spacing = 8.0,
      this.size = const Size(4.0, 4.0)});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      margin: EdgeInsets.symmetric(horizontal: spacing),
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
