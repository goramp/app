import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/router/routes/index.dart';
import 'package:provider/provider.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:goramp/generated/l10n.dart';

const _kGoogle = 'assets/images/google/google.png';
const _kTwitter = 'assets/images/twitter/twitter.png';
const _kFacebook = 'assets/images/facebook/facebook.png';
const _kApple = 'assets/images/apple/apple.svg';
const _kAppleWhite = 'assets/images/apple/apple_white.svg';
const _kDarkIcon = 'assets/images/logo_full/dark/small/logo.png';
const _kLightIcon = 'assets/images/logo_full/light/small/logo.png';
const _kKuroLogo = 'assets/images/klogo/kurobi.svg';

class TwitterButton extends StatelessWidget {
  final String? text;
  final bool? loading;
  final VoidCallback? onPressed;

  TwitterButton({Key? key, this.text, this.loading, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      elevation: 0,
      textStyle: theme.textTheme.button!.copyWith(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: kInfoRadius),
      primary: onPressed == null
          ? theme.colorScheme.surface
          : theme.colorScheme.primary,
      onPrimary: onPressed == null
          ? theme.colorScheme.onSurface.withOpacity(0.38)
          : theme.colorScheme.onPrimary,
    );
    final desktopMaxWidth = 300.0 + 50.0 * (cappedTextScale(context) - 1);
    return Container(
      alignment: Alignment.center,
      width: desktopMaxWidth,
      child: SizedBox(
        height: 48.0,
        width: double.infinity,
        child: ElevatedButton.icon(
            style: raisedButtonStyle,
            icon: Image.asset(
              _kTwitter,
              color: isDark ? Colors.black : Colors.white,
              width: 32,
              height: 32,
            ),
            label: Text(
              text!,
            ),
            onPressed: onPressed),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback? onTap;
  final bool showSpinner;
  final bool loading;

  _LoginButton(this.icon, this.text, this.onTap,
      {this.loading = false, this.showSpinner = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final desktopMaxWidth = 300.0 + 50.0 * (cappedTextScale(context) - 1);
    return Container(
      alignment: Alignment.center,
      width: desktopMaxWidth,
      child: SizedBox(
        height: 48.0,
        width: double.infinity,
        child: OutlineButton.icon(
          shape: RoundedRectangleBorder(borderRadius: kInfoRadius),
          highlightedBorderColor: theme.colorScheme.primary,
          icon: icon,
          label: Text(text),
          onPressed: onTap,
        ),
      ),
    );
  }
}

typedef OnAccountExist = void Function(
    AuthException exception, String preferredProvider);

class LoginButtons extends StatefulWidget {
  final VoidCallback? onEmailLink;
  final VoidCallback? onEmailLinkSuccess;
  final ValueChanged<UserWithProfile>? onLogin;
  final VoidCallback? onCancelPending;
  final OnAccountExist? onAccountExist;
  final auth.AuthCredential? pendingCredential;
  final String? preferredProvider;
  final AppRoutePath? returnTo;
  final ValueNotifier<bool> loading;

  bool get hasPendingCredential => pendingCredential != null;

  LoginButtons({
    Key? key,
    this.onEmailLink,
    this.onEmailLinkSuccess,
    this.pendingCredential,
    this.onLogin,
    this.preferredProvider,
    this.onAccountExist,
    this.onCancelPending,
    this.returnTo,
    required this.loading,
  }) : super(key: key);

  @override
  _LoginButtonsState createState() => _LoginButtonsState();
}

class _LoginButtonsState extends State<LoginButtons> {
  late AppConfig config;

  @override
  void initState() {
    config = context.read();
    super.initState();
  }

  Future<void> _onLogin(User user) async {
    try {
      final profile = await LoginHelper.onLogin(context, user);
      await LoginService.updateLogin(config);
      widget.onLogin?.call(UserWithProfile(user: user, profile: profile));
      final token = await auth.FirebaseAuth.instance.currentUser?.getIdToken();
      print(token);
    } catch (error, stack) {
      print('error: $error');
      print('stack: $stack');
    }
  }

  Future<void> _handleAuthError(AuthException e) async {
    if (e.code == AuthExceptionCode.AccountExistWithDifferentCredentials) {
      final preferredProvider = await LoginService.preferredProvider(e.email!);
      widget.onAccountExist!(e, preferredProvider);
    } else if (e.code == AuthExceptionCode.ClosedByUser) {
      return;
    } else if (e.code == AuthExceptionCode.NetworkError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).connection_error),
        action: SnackBarAction(
          label: S.of(context).try_again,
          onPressed: () {
            _handleTwitterLogin(context);
          },
        ),
      ));
    } else {
      SnackbarHelper.show(
          LoginHelper.authExceptionMessage(context, e), context);
    }
  }

  Future<void> _handleGooLogin(BuildContext context) async {
    try {
      if (widget.loading.value) return;
      widget.loading.value = true;
      User? user;
      user = await LoginService.signInWithGoogle(
          useRedirect: !isDisplayDesktop(context));
      if (user == null) {
        return;
      }
      if (widget.hasPendingCredential) {
        user =
            await LoginService.linkWithCredentials(widget.pendingCredential!);
      }
      await _onLogin(user);
    } on AuthException catch (e) {
      await _handleAuthError(e);
    } finally {
      widget.loading.value = false;
    }
  }

  Future<void> _handleFacebookLogin(BuildContext context) async {
    try {
      if (widget.loading.value) return;
      widget.loading.value = true;
      AppConfig config = context.read();
      User? user;
      user = await LoginService.signInWithFacebook(config,
          useRedirect: !isDisplayDesktop(context));
      if (user == null) {
        return;
      }
      if (widget.hasPendingCredential) {
        user =
            await LoginService.linkWithCredentials(widget.pendingCredential!);
      }
      await _onLogin(user);
    } on AuthException catch (e) {
      await _handleAuthError(e);
    } finally {
      widget.loading.value = false;
    }
  }

  Future<void> _handleTwitterLogin(BuildContext context) async {
    try {
      if (widget.loading.value) return;
      widget.loading.value = true;
      AppConfig config = context.read();
      User? user;
      user = await LoginService.signInWithTwitter(config,
          useRedirect: !isDisplayDesktop(context));
      if (user == null) {
        return;
      }
      if (widget.hasPendingCredential) {
        user =
            await LoginService.linkWithCredentials(widget.pendingCredential!);
      }
      await _onLogin(user);
    } on AuthException catch (e) {
      await _handleAuthError(e);
    } catch (e) {
      print('LOGIN ERROR: $e');
    } finally {
      widget.loading.value = false;
    }
  }

  Future<void> _handleAppleLogin(BuildContext context) async {
    try {
      if (widget.loading.value) return;
      widget.loading.value = true;
      AppConfig config = context.read();
      User? user;
      user = await LoginService.signInWithApple(config,
          useRedirect: !isDisplayDesktop(context));
      if (user == null) {
        return;
      }
      if (widget.hasPendingCredential) {
        final credentials = widget.pendingCredential!;
        user = await LoginService.linkWithCredentials(credentials);
      }
      await _onLogin(user);
    } on AuthException catch (e) {
      await _handleAuthError(e);
    } finally {
      widget.loading.value = false;
    }
  }

  Widget _buildSignInTitle(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    AppConfig config = Provider.of(context, listen: false);
    LoginViewState loginViewState = Provider.of(context, listen: false);
    return Column(
      children: [
        VSpace(Insets.xl),
        Text(
          loginViewState.loginMode
              ? S.of(context).login_to_kurobi
              : S.of(context).signup_for_kurobi,
          style: theme.textTheme.headline5,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        VSpace(Insets.xl * 2),
        (config.isKuro
                ? PlatformSvg.asset(
                    //isDark ? _kDarkIcon : _kLightIcon,
                    _kKuroLogo,
                    height: 60.0)
                : Image.asset(
                    isDark ? _kDarkIcon : _kLightIcon,
                  ))
            .clickable(() {
          launch(config.landingUrl!,
              forceSafariVC: true, forceWebView: true, enableJavaScript: true);
        }),
        VSpace(Insets.ls),
        config.isKuro
            ? Text(
                "${S.of(context).intro_audience} \n ${S.of(context).intro_paid_for_time}",
                maxLines: 2,
                textAlign: TextAlign.center,
              )
            : Text(
                "${S.of(context).intro_followers} \n ${S.of(context).intro_paid_for_time}",
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
      ],
    );
  }

  Widget _buildSignInButtons(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    const dividerS = const VSpace(16.0);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        dividerS,
        _LoginButton(
          Icon(
            Icons.email_outlined,
            color: isDark ? Colors.white : null,
          ),
          S.of(context).continue_email,
          widget.onEmailLink,
        ),
        dividerS,
        _LoginButton(
          Image.asset(
            _kGoogle,
            color: isDark ? Colors.white : null,
          ),
          S.of(context).continue_google,
          () => _handleGooLogin(context),
        ),
        dividerS,
        _LoginButton(
          Image.asset(
            _kTwitter,
            color: isDark ? Colors.white : null,
            // width: 32,
            // height: 32,
          ),
          S.of(context).continue_twitter,
          () => _handleTwitterLogin(context),
        ),
        dividerS,
        // if (UniversalPlatform.isIOS ||
        //     UniversalPlatform.isMacOS)_kApple
        _LoginButton(
          PlatformSvg.asset(
            isDark ? _kAppleWhite : _kApple,
          ),
          S.of(context).continue_apple,
          () => _handleAppleLogin(context),
        ),
        dividerS,
        _LoginButton(
          Image.asset(
            _kFacebook,
            color: isDark ? Colors.white : null,
            // width: 32,
            // height: 32,
          ),
          S.of(context).continue_facebook,
          () => _handleFacebookLogin(context),
        ),
        dividerS,
      ],
    );
  }

  Widget _buildAccountExistButtons(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    const dividerS = const VSpace(16.0);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        dividerS,
        if (widget.preferredProvider == auth.GoogleAuthProvider.PROVIDER_ID)
          _LoginButton(
            Image.asset(
              _kGoogle,
              color: isDark ? Colors.white : null,
            ),
            S.of(context).continue_google,
            () => _handleGooLogin(context),
          ),
        if (widget.preferredProvider == "twitter.com")
          _LoginButton(
            Image.asset(
              _kTwitter,
              color: isDark ? Colors.white : null,
              // width: 32,
              // height: 32,
            ),
            S.of(context).continue_twitter,
            () => _handleTwitterLogin(context),
          ),
        if (widget.preferredProvider == "apple.com")
          _LoginButton(
            PlatformSvg.asset(
              isDark ? _kAppleWhite : _kApple,
            ),
            S.of(context).continue_apple,
            () => _handleAppleLogin(context),
          ),
        if (widget.preferredProvider == "emailLink")
          _LoginButton(
            Icon(
              Icons.email_outlined,
              color: isDark ? Colors.white : null,
            ),
            S.of(context).continue_email,
            widget.onEmailLink,
          ),
        if (widget.preferredProvider == "facebook.com")
          _LoginButton(
            Image.asset(
              _kFacebook,
              color: isDark ? Colors.white : null,
              // width: 32,
              // height: 32,
            ),
            S.of(context).continue_facebook,
            () => _handleFacebookLogin(context),
          ),
        dividerS,
      ],
    );
  }

  Widget _buildAccountExistTitle(BuildContext context) {
    const dividerL = const VSpace(24.0);
    return Column(
      children: [
        dividerL,
        Align(
          alignment: Alignment.center,
          child: Container(
            constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
            child: Text(
              S.of(context).account_exists,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: 24.0),
        Align(
          alignment: Alignment.center,
          child: Container(
            constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
            child: Text(
              S.of(context).account_already_exist,
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    final desktopMaxWidth = context.panelMaxWidth;
    const dividerL = const VSpace(24.0);
    LoginViewState loginViewState = Provider.of(context, listen: false);
    Widget body = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                  maxWidth: desktopMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.hasPendingCredential
                      ? _buildAccountExistTitle(context)
                      : _buildSignInTitle(context),
                  dividerL,
                  widget.hasPendingCredential
                      ? _buildAccountExistButtons(context)
                      : _buildSignInButtons(context),
                  dividerL,
                  if (widget.hasPendingCredential)
                    Align(
                      alignment: Alignment.center,
                      child: TextButton.icon(
                        icon: Icon(Icons.chevron_left_outlined),
                        label: Text(S.of(context).all_signin_options),
                        onPressed: widget.onCancelPending,
                      ),
                    ),
                  dividerL,
                  const TermsWidget(),
                  dividerL,
                  LoginSwitcher(
                    key: ValueKey(loginViewState.loginMode),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
    //widget.loading.value
    return body;
  }
}
