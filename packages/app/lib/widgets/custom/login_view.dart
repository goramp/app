import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:go_router/go_router.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/widgets/custom/fb_email_link_login_form.dart';
import 'package:goramp/widgets/custom/fb_email_link_signup_view2.dart';
import 'package:goramp/widgets/custom/login_change_password.dart';
import 'package:goramp/widgets/custom/login_form_forgot.dart';
import 'package:url_launcher/link.dart' as launcher;
import 'package:goramp/widgets/custom/fb_email_link_signup_view.dart';
import 'package:goramp/widgets/custom/login_buttons.dart';
import 'package:goramp/widgets/custom/login_form.dart';
import 'package:goramp/widgets/index.dart';
import 'package:provider/provider.dart';

class LoginSwitcher extends StatelessWidget {
  const LoginSwitcher({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LoginViewState state = Provider.of(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(state.loginMode
            ? 'Don’t have an account?'
            : 'Already have an account?'),
        HSpace(Insets.m),
        OutlinedButton(
          child: Text(state.loginMode ? 'Sign up' : 'Log in'),
          onPressed: state.switchLoginMode,
        ),
      ],
    );
  }
}

class TermsWidget extends StatelessWidget {
  const TermsWidget();
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final baseTextStyle =
        theme.textTheme.caption!.copyWith(fontWeight: FontWeight.bold);
    final buttonStyle =
        baseTextStyle.copyWith(color: theme.colorScheme.primary);

    AppConfig config = Provider.of(context, listen: false);
    return Text.rich(
      TextSpan(
          style: baseTextStyle,
          text: '${S.of(context).signin_agreement} \n',
          children: [
            WidgetSpan(
              child: launcher.Link(
                uri: Uri.parse(config.termsUrl!),
                target: launcher.LinkTarget.blank,
                builder: (contex, follow) => Text(
                  S.of(context).terms_of_service,
                  style: buttonStyle,
                ).clickable(follow),
              ),
            ),
            TextSpan(
              text: " ${S.of(context).and} ",
              style: baseTextStyle,
            ),
            WidgetSpan(
              child: launcher.Link(
                uri: Uri.parse(config.privacyUrl!),
                target: launcher.LinkTarget.blank,
                builder: (contex, follow) => Text(
                  S.of(context).privacy_policy,
                  style: buttonStyle,
                ).clickable(follow),
              ),
            ),
          ]),
      textAlign: TextAlign.center,
    );
  }
}

class LoginTint extends StatelessWidget {
  final Widget child;
  final ValueNotifier<bool> loading;
  LoginTint(this.child, this.loading);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        ValueListenableBuilder(
            valueListenable: loading,
            builder: (context, bool loading, __) {
              return Container(
                child: IgnorePointer(
                  ignoring: !loading,
                  child: AnimatedOpacity(
                    duration: kThemeAnimationDuration,
                    opacity: loading ? 1.0 : 0.0,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black.withOpacity(0.45)
                              : Colors.white.withOpacity(0.45)),
                      child: Center(
                        child: Card(
                          elevation: 4.0,
                          child: SizedBox(
                            height: 100.0,
                            width: 100.0,
                            child: Center(
                              child: SizedBox(
                                height: 32.0,
                                width: 32.0,
                                child: PlatformCircularProgressIndicator(
                                    theme.colorScheme.primary),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
      ],
    );
  }
}

class LoginView extends StatefulWidget {
  final String? returnTo;
  final VoidCallback? onSignUp;
  final ValueChanged<User>? onLogin;
  final String? signInTitle;
  final int? initialStep;
  final String? email;
  final fb.AuthCredential? pendingCredential;
  final String? preferredProvider;
  final ValueNotifier<bool> loading;
  final String? code;
  final bool? loginMode;
  final bool isDialog;
  final User? user;
  final UserProfile? profile;

  const LoginView({
    this.onSignUp,
    this.onLogin,
    this.signInTitle,
    this.initialStep = 1,
    this.returnTo,
    this.email,
    this.pendingCredential,
    this.preferredProvider,
    this.code,
    this.loginMode = false,
    this.isDialog = false,
    this.user,
    this.profile,
    required this.loading,
  });

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  bool _loginMode = true;
  int _step = 1;
  LoginViewState();

  bool get loginMode => _loginMode;
  User? _user;
  UserProfile? _profile;

  initState() {
    _step = widget.initialStep ?? 1;
    _loginMode = widget.loginMode ?? true;
    _user = widget.user;
    _profile = widget.profile;
    super.initState();
  }

  didUpdateWidget(LoginView old) {
    if (old.initialStep != widget.initialStep) {
      _step = widget.initialStep ?? 1;
    }
    if (old.loginMode != widget.loginMode) {
      _loginMode = widget.loginMode ?? false;
    }
    if (old.user != widget.user) {
      _user = widget.user;
    }
    if (old.profile != widget.profile) {
      _profile = widget.profile;
    }
    super.didUpdateWidget(old);
  }

  switchLoginMode() {
    if (widget.isDialog) {
      setState(() {
        _loginMode = !_loginMode;
      });
    } else {
      if (_loginMode) {
        context.go('/signup');
      } else {
        context.go('/login');
      }
    }
  }

  _onEmailLink() {
    setState(() {
      _step = 2;
    });
  }

  _onForgot() {
    // if (widget.isDialog) {
    //   setState(() {
    //     _step = 3;
    //   });
    // } else {
    //   context.go('/reset');
    // }
    setState(() {
      _step = 3;
    });
  }

  void _initial() {
    if (widget.isDialog) {
      setState(() {
        _step = 1;
      });
    } else {
      context.go('/login');
    }
  }

  _onLoginSuccess(UserWithProfile userProfile) {
    MyAppModel model = context.read();
    model.pendingAuthCredential = null;
    _user = userProfile.user;
    _profile = userProfile.profile;
    if (!userProfile.profileComplete) {
      setState(() {
        _step = 6;
      });
      return;
    }
    if (widget.returnTo != null) {
      context.go(widget.returnTo!);
      return;
    }
    if (widget.onLogin != null) {
      widget.onLogin!(_user!);
    } else {
      context.go('/');
    }
  }

  Widget build(BuildContext context) {
    Widget body;
    final pendingAuthCred = context.select<MyAppModel, LinkAuthCredential?>(
        (model) => model.pendingAuthCredential);
    if (pendingAuthCred != null) {
      body = LoginButtons(
          key: ValueKey<int>(_step),
          preferredProvider: pendingAuthCred.provider,
          pendingCredential: pendingAuthCred.credential,
          onEmailLink: _onEmailLink,
          onEmailLinkSuccess: _initial,
          onLogin: _onLoginSuccess,
          loading: widget.loading,
          onCancelPending: () {
            MyAppModel model = context.read();
            model.pendingAuthCredential = null;
          });
    } else {
      if (_step == 1) {
        body = LoginButtons(
          key: ValueKey<int>(_step),
          loading: widget.loading,
          onEmailLink: _onEmailLink,
          onEmailLinkSuccess: _initial,
          onLogin: _onLoginSuccess,
          onAccountExist: (e, provider) {
            MyAppModel model = context.read();
            model.pendingAuthCredential = LinkAuthCredential(
                provider: provider, credential: e.credential, email: e.email);
          },
        );
      } else if (_step == 2) {
        body = _loginMode
            ? LoginForm(
                onLogin: _onLoginSuccess,
                onSignup: () => switchLoginMode(),
                onForgot: _onForgot,
                onAccountExist: (e, provider) {
                  MyAppModel model = context.read();
                  model.pendingAuthCredential = LinkAuthCredential(
                      provider: provider,
                      credential: e.credential,
                      email: e.email);
                },
                onCancel: _initial,
              )
            : SignUpForm1(
                //title: widget.signInTitle,
                key: ValueKey<int>(_step),
                onSuccess: _onLoginSuccess,
                onLogin: () => switchLoginMode(),
                onCancel: _initial,
              );
      } else if (_step == 3) {
        body = ForgotPassword(
          onCancel: () {
            setState(() {
              _step = 1;
            });
          },
          onLogin: () {
            setState(() {
              _step = 2;
            });
          },
          onSuccess: _initial,
        );
      } else if (_step == 4) {
        body = ChangePassword(
          code: widget.code,
          onCancel: _initial,
          onSuccess: () {
            setState(() {
              _step = 2;
              _loginMode = true;
            });
          },
        );
      } else if (_step == 5) {
        body = FBEmailLoginForm(
          title: widget.signInTitle,
          key: ValueKey<int>(_step),
          onSuccess: _initial,
          isLogin: _loginMode,
          email: widget.email,
          continuePath: widget.returnTo,
          onCancel: () => {
            setState(() {
              _step = 1;
            })
          },
        );
      } else if (_step == 6) {
        body = SignUpForm2(
          key: ValueKey<int>(_step),
          onSuccess: _onLoginSuccess,
          user: _user!,
          profile: _profile,
          onCancel: () => {
            setState(() {
              _step = 1;
            })
          },
        );
      } else {
        body = const SizedBox.shrink();
      }
    }

    return Provider.value(
      value: this,
      child: SafeArea(
        top: true,
        child: body,
      ),
    );
  }
}
