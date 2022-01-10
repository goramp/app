import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:goramp/bloc/index.dart';
import 'package:passbase_flutter/passbase_flutter.dart';
import 'interface.dart';

void verifyIdentity(BuildContext _, String url,
    {VoidCallback? onSuccess, VoidCallback? onCancel}) async {
  throw UnimplementedError();
}

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
  _PasssBaseButtonState();
  late String params;

  @override
  void initState() {
    MyAppModel model = context.read();
    var bytes = utf8.encode(json.encode({
      'prefill_attributes': {'email': model.currentUser?.email}
    }));
    params = base64Encode(bytes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AppConfig config = Provider.of<AppConfig>(context, listen: false);
    return PassbaseButton(
      width: 200,
      height: 48,
      onFinish: (identityAccessKey) {
        // do stuff in case of success
        widget.onSubmitted?.call(identityAccessKey);
      },
      onSubmitted: (identityAccessKey) {
        // do stuff in case of success
        widget.onFinish?.call(identityAccessKey);
      },
      onError: (errorCode) {
        // do stuff in case of cancel
        widget.onError?.call(errorCode);
      },
      onStart: () {
        widget.onStart?.call();
      },
    );
  }
}
