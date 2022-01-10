import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/index.dart';
import '../../custom/index.dart';

class Welcome extends StatelessWidget {
  final ValueChanged<User>? onLogin;
  final String? returnTo;
  final int? initialStep;
  final bool? loginMode;
  final bool? isDialog;
  const Welcome(
      {this.onLogin,
      this.returnTo,
      this.initialStep = 1,
      this.loginMode = true,
      this.isDialog = false});

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      onLogin: onLogin,
      returnTo: returnTo,
      showAppBar: false,
      initialStep: initialStep,
      loginMode: loginMode,
      isDialog: isDialog,
    );
  }
}
