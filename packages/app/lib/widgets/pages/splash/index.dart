import 'package:flutter/material.dart';
import 'package:goramp/widgets/index.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  Widget _buildContent(BuildContext context) {
    ThemeData theme = Theme.of(context);
    //bool isDark = theme.brightness == Brightness.dark;
    return Container(
      color: theme.colorScheme.background,
      child: Center(child: const FeedLoader()),
    );
  }

  Widget build(BuildContext context) {
    return _buildContent(context);
  }
}
