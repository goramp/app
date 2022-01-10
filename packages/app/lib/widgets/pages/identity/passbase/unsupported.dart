import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
