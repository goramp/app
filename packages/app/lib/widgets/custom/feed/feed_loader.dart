import 'package:flutter/material.dart';
import '../../../widgets/index.dart';

class FeedLoader extends StatelessWidget {
  final double size;
  final double strokeWidth;
  const FeedLoader({Key? key, this.size = 36, this.strokeWidth = 3.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: PlatformCircularProgressIndicator(
          Theme.of(context).colorScheme.primary,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
