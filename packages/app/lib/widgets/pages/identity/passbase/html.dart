@JS()
library stripe;

import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:js/js.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';
import 'interface.dart';

void verifyIdentity(BuildContext _, String url,
    {VoidCallback? onSuccess, VoidCallback? onCancel}) async {
  html.window.open(url, '_blank', 'resizable,width=450,height=780');
}

@JS()
@anonymous
class PassbaseOptions {
  external OnPassbaseSubmitted get onSubmitted;
  external OnPassbaseFinished get onFinish;
  external OnPassbaseError get onError;
  external OnPassbaseStart get onStart;
  external factory PassbaseOptions({
    OnPassbaseFinished? onSubmitted,
    OnPassbaseFinished? onFinish,
    OnPassbaseError? onError,
    OnPassbaseStart? onStart,
  });
}

@JS('Passbase.renderButton')
external void renderButton(
    html.Element element, String apiKey, PassbaseOptions options);

class PassBaseButton extends StatefulWidget {
  final OnPassbaseSubmitted? onSubmitted;
  final OnPassbaseFinished? onFinish;
  final OnPassbaseError? onError;
  final OnPassbaseStart? onStart;

  PassBaseButton({this.onSubmitted, this.onFinish, this.onError, this.onStart});

  @override
  State<StatefulWidget> createState() {
    return _PasssBaseButtonState();
  }
}

class _PasssBaseButtonState extends State<PassBaseButton> {
  _PasssBaseButtonState() : _textureId = _textureCounter++;

  static int _textureCounter = 1;
  final int _textureId;

  final html.DivElement container = html.DivElement()
    ..id = 'passbase-button'
    ..style.border = 'none'
    ..style.height = '100%'
    ..style.width = '100%';

  String get viewId => 'passbase-button-$_textureId';
  @override
  void initState() {
    ui.platformViewRegistry
        .registerViewFactory(viewId, (int viewId) => container);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _initialize();
    });
    super.initState();
  }

  _initialize() {
    AppConfig config = context.read();
    renderButton(
      container,
      config.passbaseApiKey!,
      PassbaseOptions(
        onSubmitted: allowInterop((String identityAccessKey) {
          widget.onSubmitted?.call(identityAccessKey);
        }),
        onError: allowInterop((String error) {
          widget.onError?.call(error);
        }),
        onFinish: allowInterop((String identityAccessKey) {
          widget.onFinish?.call(identityAccessKey);
        }),
        onStart: allowInterop(() {
          widget.onStart?.call();
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //constraints: BoxConstraints(maxHeight: 56.0, maxWidth: 200),
      decoration: BoxDecoration(
          borderRadius: kInputBorderRadius, color: Colors.transparent),
      alignment: Alignment.center,
      child: HtmlElementView(viewType: viewId),
    );
  }
}
