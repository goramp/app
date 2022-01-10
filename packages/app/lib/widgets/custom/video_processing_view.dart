import 'dart:ui';

import 'package:flutter/material.dart';
import '../helpers/index.dart';
import 'platform_circular_progress_indicator.dart';
import 'package:goramp/generated/l10n.dart';

class VideoProcessingView extends StatelessWidget {
  final bool processing;

  VideoProcessingView({this.processing = false});

  @override
  Widget build(BuildContext context) {
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
                  new BoxDecoration(color: Colors.black.withOpacity(0.2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PlatformCircularProgressIndicator(Colors.white),
                  SizedBox(
                    height: 24.0,
                  ),
                  Text("${S.of(context).processing_video}...",
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: Colors.white, shadows: TEXT_SHADOW))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
