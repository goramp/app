import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goramp/bloc/index.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goramp/generated/l10n.dart';
import '../../../utils/index.dart';
import '../../../services/index.dart';
import '../../index.dart';

typedef _OnErrorComplete = void Function(AuthException error, String? email);

class _EmailConfirm extends StatefulWidget {
  final String? email;
  final String? url;
  final _OnErrorComplete onError;
  final String? continuePath;
  _EmailConfirm(this.email, this.url,
      {required this.onError, this.continuePath});
  @override
  State<StatefulWidget> createState() {
    return _EmailConfirmState();
  }
}

class _EmailConfirmState extends State<_EmailConfirm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, StreamSubscription<ValidationState>> validationSubscriptions = {};
  Map<String, ValidationState> validationStates = {};
  Map<String, ValidationBloc> validationBlocs = {};
  Map<String, FocusNode> _focusNodes = {};
  Map<String, TextEditingController> _controllers = {};
  String? _errorText;
  String? _email;
  bool _loading = false;

  initState() {
    super.initState();
    _email = widget.email;
    _controllers[Constants.EMAIL_FIELD] = TextEditingController();
    _focusNodes[Constants.EMAIL_FIELD] = FocusNode();
    _controllers[Constants.EMAIL_FIELD]!.addListener(() {
      validationBlocs[Constants.EMAIL_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.EMAIL_FIELD]!.text);
    });
    validationBlocs[Constants.EMAIL_FIELD] = ValidationBloc<String>(
        EmailValidator(Constants.EMAIL_FIELD,
            config: context.read(), checkExistence: false, context: context));
    validationSubscriptions[Constants.EMAIL_FIELD] =
        validationBlocs[Constants.EMAIL_FIELD]!
            .state
            .listen((ValidationState state) {
      _handleFieldValidation(Constants.EMAIL_FIELD, state);
    });
    _controllers[Constants.EMAIL_FIELD]!.text = _email ?? "";
  }

  didUpdateWidget(_EmailConfirm old) {
    if (old.email != widget.email) {
      _controllers[Constants.EMAIL_FIELD]!.text = _email ?? "";
    }
    super.didUpdateWidget(old);
  }

  bool get isValid {
    return validationStates.values.every((ValidationState state) {
      if (state is ValidationResult) {
        return state.isValid;
      }
      return false;
    });
  }

  _handleFieldValidation(String fieldName, ValidationState state) {
    validationStates[fieldName] = state;
  }

  dispose() {
    super.dispose();
    validationBlocs.forEach((String _, ValidationBloc bloc) => bloc.dispose());
    validationSubscriptions
        .forEach((String _, StreamSubscription sub) => sub.cancel());
    _controllers.forEach(
        (String _, TextEditingController controller) => controller.dispose());
  }

  Future<void> _login() async {
    if (!isValid) {
      _formKey.currentState!.validate();
      return;
    }
    _formKey.currentState!.save();
    if (_loading) {
      return;
    }
    setState(() {
      _loading = true;
    });
    try {
      final user = await LoginService.signInWithEmailLink(_email!, widget.url!);
      await LoginHelper.onLogin(
        context,
        user,
      );
      if (!user.isPendingSignup) {
        if (widget.continuePath != null) {
          context.go(widget.continuePath!);
          return;
        }
        context.go('/');
        print('go to login');
      } else {
        if (widget.continuePath != null) {
          context.go('/register?returnTo=${widget.continuePath}');
        } else {
          context.go('/register');
        }
      }
    } on AuthException catch (error) {
      widget.onError(error, _email);
    } catch (error) {
      widget.onError(
          AuthException(AuthExceptionCode.Unknown,
              message: S.of(context).default_error_title),
          _email);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Container(
        alignment: Alignment.center,
        child: ListView(
          padding: EdgeInsets.only(left: 16.0, right: 16),
          shrinkWrap: true,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
                child: Text(
                  "${S.of(context).almost_there}!",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
                child: Text(
                  S.of(context).provide_email_for_confirmation,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 64.0),
            WithTextFieldValidation(
              validationEnabled: false,
              validationBloc: validationBlocs[Constants.EMAIL_FIELD],
              textController: _controllers[Constants.EMAIL_FIELD],
              autoCorrect: false,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              focusNode: _focusNodes[Constants.EMAIL_FIELD],
              errorText: _errorText,
              maxWidth: context.panelMaxWidth,
              onFieldSubmitted: (value) {
                _login();
              },
              onSaved: (String? val) {
                _email = val?.trim();
              },
              validator: (value) {
                final state = validationStates[Constants.EMAIL_FIELD];
                if (state != null) {
                  if (state is ValidationResult)
                    return state.isValid
                        ? _errorText
                        : state.fieldError!.errors.first.message;
                  if (state is ValidationNoTerm) {
                    return S.of(context).enter_valid_email;
                  }
                }
                return _errorText;
              },
              labelText: S.of(context).your_email,
              // errorHandler: _handleError,
            ),
            const SizedBox(height: 64.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  child: LoginButton(
                    key: ValueKey("LoginButton"),
                    text: S.of(context).continue_string.toUpperCase(),
                    onPressed: _login,
                    loading: _loading,
                  ),
                )
              ],
            ),
            const SizedBox(height: 24.0),
            Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                icon: Icon(Icons.chevron_left_outlined),
                label: Text(S.of(context).all_signin_options),
                onPressed: () {
                  //routePageManager.goToLogin();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FBEmailSignInCallback extends StatefulWidget {
  final String? code;
  final String? lang;
  final String? url;
  final String? continuePath;
  FBEmailSignInCallback({this.code, this.lang, this.url, this.continuePath});
  @override
  _FBEmailSignInCallbackPageState createState() =>
      _FBEmailSignInCallbackPageState();
}

class _FBEmailSignInCallbackPageState extends State<FBEmailSignInCallback> {
  String? _email;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> _verifyingCode = ValueNotifier<bool>(false);
  AuthException? _verifyError;
  ValueNotifier<bool> _loginLoading = ValueNotifier<bool>(false);

  initState() {
    super.initState();
    _verifyCode();
  }

  Future<void> _verifyCode() async {
    if (_verifyingCode.value) {
      return;
    }
    _verifyingCode.value = true;
    try {
      if (widget.code == null) {
        throw new AuthException(AuthExceptionCode.InvalidActionCode);
      }
      if (_email == null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        _email = preferences.getString("email");
      }
      if (_email != null && _email!.isNotEmpty) {
        final user =
            await LoginService.signInWithEmailLink(_email!, widget.url!);
        await LoginHelper.onLogin(context, user);
        if (!user.isPendingSignup) {
          if (widget.continuePath != null) {
            context.go(widget.continuePath!);
            return;
          }
          context.go('/');
        } else {
          if (widget.continuePath != null) {
            context.go('/register?returnTo=${widget.continuePath}');
          } else {
            context.go('/register');
          }
        }
      }
    } on AuthException catch (error) {
      _verifyError = error;
    } catch (error) {
      _verifyError = AuthException(AuthExceptionCode.Unknown,
          message: S.of(context).default_error_title);
    } finally {
      _verifyingCode.value = false;
    }
  }

  void _handleError(AuthException ex, String? email) {
    setState(() {
      _verifyError = ex;
      _email = email;
    });
  }

  Widget unknownError() {
    return Container(
      alignment: Alignment.center,
      child: ListView(
        padding: EdgeInsets.only(left: 16.0, right: 16),
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 64.0),
          Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
              child: Text(
                S.of(context).apologies_something_went_wrong,
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
                S.of(context).refreshing_the_page,
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: ValueListenableBuilder(
                  valueListenable: _verifyingCode,
                  builder: (context, dynamic veryfying, _) {
                    return LoginButton(
                      text: S.of(context).ok.toLowerCase(),
                      onPressed: _verifyCode,
                      loading: veryfying,
                    );
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 24.0),
          Align(
            alignment: Alignment.center,
            child: TextButton.icon(
              icon: Icon(Icons.chevron_left_outlined),
              label: Text(S.of(context).all_signin_options),
              onPressed: () {
                //routePageManager.goToLogin();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    //AuthExceptionCode.InvalidActionCode
    String title = S.of(context).default_error_title2;
    switch (_verifyError!.code) {
      case AuthExceptionCode.ExpiredActionCode:
        title = S.of(context).signin_link_expired;
        return LoginView(
          initialStep: 2,
          signInTitle: title,
          email: _email,
          loading: _loginLoading,
        );
      case AuthExceptionCode.InvalidActionCode:
        title = S.of(context).signin_link_not_valid;
        return LoginView(
          initialStep: 2,
          signInTitle: title,
          email: _email,
          loading: _loginLoading,
        );
      case AuthExceptionCode.UserDisabled:
        title = S.of(context).account_disabled;
        return LoginView(
          initialStep: 2,
          signInTitle: title,
          email: _email,
          loading: _loginLoading,
        );
      case AuthExceptionCode.UserNotFound:
        title = S.of(context).user_not_found;
        return LoginView(
          initialStep: 2,
          signInTitle: title,
          email: _email,
          loading: _loginLoading,
        );
      default:
        return unknownError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginTint(
        Scaffold(
          key: _scaffoldKey,
          body: AnimatedSwitcher(
            child: ValueListenableBuilder(
              valueListenable: _verifyingCode,
              child: _verifyError != null
                  ? _buildError(context)
                  : _EmailConfirm(
                      _email,
                      widget.url,
                      onError: _handleError,
                      continuePath: widget.continuePath,
                    ),
              builder: (context, dynamic verifying, child) {
                return verifying
                    ? const FeedLoader(
                        size: 40,
                      )
                    : child!;
              },
            ),
            duration: kThemeAnimationDuration,
          ),
        ),
        _loginLoading);
  }
}
