import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:goramp/widgets/index.dart';
import '../helpers/index.dart';
import 'platform_circular_progress_indicator.dart';

class HUD extends StatelessWidget {
  final bool processing;
  final String? text;

  HUD({this.processing = false, this.text});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      child: IgnorePointer(
        ignoring: !processing,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: processing ? 1.0 : 0.0,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(color: theme.canvasColor.withOpacity(0.2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FeedLoader(),
                  if (text != null)
                    SizedBox(
                      height: 24.0,
                    ),
                  if (text != null)
                    Text(text!, style: Theme.of(context).textTheme.caption)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
