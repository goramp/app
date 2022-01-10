import 'package:flutter/material.dart';
import 'package:goramp/bloc/index.dart';
import 'package:provider/provider.dart';
import '../../../models/index.dart';
import '../../custom/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/index.dart';

class CompleteProfile extends StatelessWidget {
  final ValueChanged<User>? onLogin;
  final String? returnTo;
  const CompleteProfile({this.onLogin, this.returnTo});

  @override
  Widget build(BuildContext context) {
    MyAppModel model = Provider.of(context, listen: false);
    return LoginPage(
      onLogin: onLogin,
      initialStep: 6,
      returnTo: returnTo,
      showAppBar: false,
      user: model.currentUser,
      profile: model.profile,
    );
  }
}
