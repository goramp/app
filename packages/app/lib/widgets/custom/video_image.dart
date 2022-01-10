import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/index.dart';

class VideoImage extends StatelessWidget {
  final Video video;
  VideoImage(this.video);

  Widget build(BuildContext context) {
    final bgImage = video.thumbnail!;
    num width = video.width ?? 1;
    num height = video.height ?? 1;
    if (height == 0) {
      height = 1;
    }
    final aspectRatio = 1 / (width / height);
    final double size = 300.0;
    // final w = aspectRatio > 1 ? size : size * aspectRatio;
    final h = aspectRatio > 1 ? size / aspectRatio : size;
    return Container(
      constraints: BoxConstraints(maxHeight: h),
      //color: Colors.amber,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(bgImage.url!))),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: bgImage.url!,
                    fit: BoxFit.contain,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: IconS(
                      Icons.play_arrow,
                      size: 24.0,
                      color: Colors.white,
                      shadows: ICON_SHADOW,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
