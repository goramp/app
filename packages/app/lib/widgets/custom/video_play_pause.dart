import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../custom/index.dart';
import '../helpers/index.dart';

class VideoPlayerPauseControl extends StatelessWidget {
  final bool isPlaying;
  final bool shouldShowPlayPause;
  final VoidCallback? onPlayPause;
  VideoPlayerPauseControl(
      {this.isPlaying = false,
      this.shouldShowPlayPause = false,
      this.onPlayPause});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isPlaying
              ? IconButton(
                  icon: IconS(
                    Icons.pause,
                    color: Colors.white54,
                    shadows: ICON_SHADOW2,
                  ),
                  iconSize: 72.0,
                  onPressed: onPlayPause,
                )
              : IconButton(
                  icon: IconS(
                    Icons.play_circle_fill,
                    color: Colors.white54,
                    shadows: ICON_SHADOW2,
                  ),
                  iconSize: 72.0,
                  onPressed: onPlayPause,
                ),
        ),
      ),
    );
  }
}
