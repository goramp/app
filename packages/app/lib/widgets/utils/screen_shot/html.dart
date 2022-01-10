import 'dart:async';
import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

void shareScreenShotImage(ui.Image image,
    {String? subject, String? text, Rect? sharePosition}) async {
  ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
      as FutureOr<ByteData>);
  var pngBytes = byteData.buffer.asUint8List();
  var bs64 = base64Encode(pngBytes);
  final uri = 'data:image/png;base64,$bs64';
  html.AnchorElement(
    href: uri,
  )
    ..setAttribute("download", "$subject-qr.png")
    ..click();
  //Share.share(uri, subject: subject, sharePositionOrigin: sharePosition);
}
