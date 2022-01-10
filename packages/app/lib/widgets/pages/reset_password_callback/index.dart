import 'package:flutter/material.dart';
import '../../index.dart';

class ResetPasswordCallback extends StatefulWidget {
  final String? code;
  ResetPasswordCallback({this.code});
  @override
  _EmailSignInCallbackPageState createState() =>
      _EmailSignInCallbackPageState();
}

class _EmailSignInCallbackPageState extends State<ResetPasswordCallback> {
  ValueNotifier<bool> _loginLoading = ValueNotifier<bool>(false);
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoginTint(
        Scaffold(
          body: AnimatedSwitcher(
            child: SizedBox.expand(
        child: LoginView(
          loading: _loginLoading,
          initialStep: 4,
          code: widget.code
        ),
      ),
            duration: kThemeAnimationDuration,
          ),
        ),
        _loginLoading);
  }


}
