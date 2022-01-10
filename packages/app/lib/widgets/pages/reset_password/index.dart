import 'package:flutter/material.dart';
import '../../../models/index.dart';
import '../../custom/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/index.dart';

class ResetPassword extends StatelessWidget {
  final ValueChanged<User>? onLogin;
  const ResetPassword({this.onLogin});

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      onLogin: onLogin,
      initialStep: 4,
      returnTo: '/',
      showAppBar: false,
    
    );
  }
}
