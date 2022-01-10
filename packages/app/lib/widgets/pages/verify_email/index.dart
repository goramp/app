import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/layout/index.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../custom/index.dart';
import '../../../services/index.dart';
import '../../index.dart';
import 'package:goramp/generated/l10n.dart';

class VerifyEmail extends StatefulWidget {
  final String code;
  final String? lang;
  final String? continueUrl;
  VerifyEmail(this.code, {this.lang, this.continueUrl});
  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _buildError(BuildContext context) {
    final desktopMaxWidth = 400.0 + 100.0 * (cappedTextScale(context) - 1);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      alignment: Alignment.center,
      width: desktopMaxWidth,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            MdiIcons.alert,
            size: 64.0,
            color: isDark ? Colors.white38 : Colors.grey[300],
          ),
          VSpace(Insets.ls),
          Center(
            child: Text(
              S.of(context).invalid_expired_code,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          VSpace(Insets.ls),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              child: Text(S.of(context).try_again),
              onPressed: _goToLogin,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    final desktopMaxWidth = 400.0 + 100.0 * (cappedTextScale(context) - 1);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      alignment: Alignment.center,
      width: desktopMaxWidth,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            MdiIcons.emailCheck,
            size: 64.0,
            color: isDark ? Colors.white38 : Colors.grey[300],
          ),
          VSpace(Insets.ls),
          Center(
            child: Text(
              S.of(context).email_verified,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          VSpace(Insets.ls),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              child: Text(S.of(context).continue_string),
              onPressed: _continue,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _continue() async {
    // NavigationService navigation =
    //     Provider.of<NavigationService>(context, listen: false);
    // return navigation.goToHome();
  }

  Future<void> _goToLogin() async {
    // NavigationService navigation =
    //     Provider.of<NavigationService>(context, listen: false);
    // return navigation.goToHome();
  }

  Widget _buildMaterial(BuildContext context) {
    var currentUser =
        context.select<MyAppModel, User?>((value) => value.currentUser);
    return Scaffold(
      key: _scaffoldKey,
      appBar: SignInAppBar(
        actions: [
          if (currentUser == null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                child: Text(S.of(context).log_in),
                onPressed: () {
                  // NavigationService navigation =
                  //     Provider.of<NavigationService>(context, listen: false);
                  // return navigation.goToWelcome();
                },
              ),
            )
        ],
      ),
      body: SizedBox.expand(
        child: FutureBuilder(
          future: LoginService.applyActionCode(widget.code),
          builder: (context, snapshot) {
            Widget body;
            if (snapshot.error != null) {
              body = _buildError(context);
            } else if (snapshot.hasData) {
              body = _buildSuccess(context);
            } else {
              body = FeedLoader(
                size: 40,
              );
            }
            return AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: body,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMaterial(context);
  }
}
