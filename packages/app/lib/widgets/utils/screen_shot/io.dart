import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui;
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

void shareScreenShotImage(ui.Image image,
    {String? subject, String? text, Rect? sharePosition}) async {
  ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
      as FutureOr<ByteData>);
  var pngBytes = byteData.buffer.asUint8List();
  final directory = (await getTemporaryDirectory()).path;
  final path = '$directory/screenshot.png';
  File imgFile = File(path);
  imgFile.writeAsBytes(pngBytes);
  Share.shareFiles([path],
      mimeTypes: ['image/png'],
      subject: subject,
      text: text,
      sharePositionOrigin: sharePosition);
}
