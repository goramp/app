import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goramp/generated/l10n.dart';

class UnknownScreen extends StatelessWidget {
  final VoidCallback? onClose;
  UnknownScreen({this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).unknown_screen),
        leading: BackButton(
          onPressed: onClose,
        ),
        elevation: 0,
      ),
      body: Center(
        child: Icon(
          CupertinoIcons.question,
          size: 34,
        ),
      ),
    );
  }
}
