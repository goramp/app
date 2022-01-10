import 'package:flutter/material.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/custom/fb_email_update_form.dart';
import 'package:goramp/widgets/index.dart';

// copied from flutter calendar picker
const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);
const Size _dialogSize = Size(500.0, 600.0);

class LoginPage extends StatefulWidget {
  final String? returnTo;
  final ValueChanged<User>? onLogin;
  final bool? showAppBar;
  final int? initialStep;
  final bool? loginMode;
  final bool? isDialog;
  final User? user;
  final UserProfile? profile;

  LoginPage(
      {this.returnTo,
      this.onLogin,
      this.showAppBar = true,
      this.initialStep = 1,
      this.loginMode = true,
      this.isDialog = false,
      this.user, this.profile});
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LoginTint(
        Scaffold(
          appBar: widget.showAppBar!
              ? AppBar(
                  elevation: 0,
                  backgroundColor: theme.scaffoldBackgroundColor,
                )
              : null,
          body: SizedBox.expand(
            child: LoginView(
              loading: _loading,
              user: widget.user,
              profile: widget.profile,
              initialStep: widget.initialStep,
              loginMode: widget.loginMode,
              onLogin: widget.onLogin,
              returnTo: widget.returnTo,
              isDialog: widget.isDialog ?? false,
            ),
          ),
        ),
        _loading);
  }
}

/// This is a support widget that returns an Dialog with checkboxes as a Widget.
/// It is designed to be used in the showDialog method of other fields.
class _LoginResponsiveDialog extends StatefulWidget {
  const _LoginResponsiveDialog({
    this.context,
    this.cancelPressed,
    this.returnTo,
    this.initialStep = 1,
    this.loginMode = false,
  });

  // Variables

  final int? initialStep;
  final bool? loginMode;
  final BuildContext? context;
  final VoidCallback? cancelPressed;
  final String? returnTo;
  @override
  _ResponsiveDialogState createState() => _ResponsiveDialogState();
}

class _ResponsiveDialogState extends State<_LoginResponsiveDialog> {
  ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: AnimatedContainer(
        width: _dialogSize.width,
        height: _dialogSize.height,
        duration: _dialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: LoginTint(
            Padding(
              padding: EdgeInsets.all(Insets.ls),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: context.roundedButtonStyle,
                            child: SizedBox(
                              width: 48.0,
                              height: 48.0,
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  //shadows: ICON_SHADOW,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () => (widget.cancelPressed == null)
                                ? Navigator.of(context).pop()
                                : widget.cancelPressed!(),
                          )
                        ]),
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: LoginView(
                        onLogin: (User user) {
                          Navigator.of(context).pop(user);
                        },
                        returnTo: widget.returnTo,
                        loading: _loading,
                        loginMode: widget.loginMode,
                        initialStep: widget.initialStep,
                        isDialog: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _loading),
      ),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      clipBehavior: Clip.antiAlias,
    );
  }
}

Future<User?> showLoginDialog({
  required BuildContext context,
  VoidCallback? onCancelled,
  int? initialStep = 1,
  bool? loginMode = false,
  String? returnTo,
}) async {
  User? user;
  if (isDisplayDesktop(context)) {
    user = await showDialog<User>(
      context: context,
      builder: (BuildContext context) {
        return _LoginResponsiveDialog(
          returnTo: returnTo,
          initialStep: initialStep,
          loginMode: loginMode,
          cancelPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  } else {
    user = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) {
            return LoginPage(
              initialStep: initialStep,
              loginMode: loginMode,
              returnTo: returnTo,
              isDialog: true,
            );
          },
          fullscreenDialog: true),
    );
  }
  return user;
}

Future<bool?> showEmailUpdateDialog({
  required BuildContext context,
  String? returnTo,
  String? email,
  String? title,
}) async {
  final success = await showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return _LoginDialog(
        returnTo: returnTo,
        tint: false,
        cancelPressed: () {
          Navigator.of(context).pop(false);
        },
        child: FBEmailUpdateForm(
          email: email,
          title: title,
          onSuccess: () {
            Navigator.of(context).pop(true);
          },
          onCancel: () {
            Navigator.of(context).pop(false);
          },
        ),
      );
    },
  );
  return success;
}

class _LoginDialog extends StatefulWidget {
  const _LoginDialog({
    this.cancelPressed,
    this.returnTo,
    required this.child,
    this.tint = true,
  });

  final VoidCallback? cancelPressed;
  final String? returnTo;
  final Widget child;
  final bool tint;

  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<_LoginDialog> {
  ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    final el = Padding(
      padding: EdgeInsets.all(Insets.ls),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                style: context.roundedButtonStyle,
                child: SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: Center(
                    child: Icon(
                      Icons.close,
                      //shadows: ICON_SHADOW,
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () => (widget.cancelPressed == null)
                    ? Navigator.of(context).pop()
                    : widget.cancelPressed!(),
              )
            ]),
          ),
          Expanded(
            child: SizedBox.expand(
              child: widget.child,
            ),
          ),
        ],
      ),
    );
    return ScaffoldMessenger(
      child: Dialog(
        child: AnimatedContainer(
            width: _dialogSize.width,
            height: _dialogSize.height,
            duration: _dialogSizeAnimationDuration,
            curve: Curves.easeIn,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: widget.tint ? LoginTint(el, _loading) : el,
              ),
            )),
        insetPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
