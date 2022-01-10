import 'package:flutter/material.dart';
import 'package:goramp/widgets/router/routes/app_route_path.dart';

class SignUp extends StatelessWidget {
  final String? title;
  final AppRoutePath? continueRoutePath;
  const SignUp({this.title, this.continueRoutePath});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return Scaffold(
      body: const SizedBox.shrink(),
    );
  }
}
