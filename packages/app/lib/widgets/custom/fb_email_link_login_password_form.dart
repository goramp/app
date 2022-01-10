import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/router/routes/index.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goramp/generated/l10n.dart';
import 'dart:async';

class FBEmailLoginForm extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onCancel;
  final bool isLogin;
  final String? title;
  final String? email;
  final AppRoutePath? continuePath;
  FBEmailLoginForm({
    Key? key,
    required this.onSuccess,
    required this.isLogin,
    this.title,
    this.email,
    required this.onCancel,
    this.continuePath,
  }) : super(key: key);
  @override
  _EmailLoginPageState createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<FBEmailLoginForm> {
  bool _loading = false;
  String? _email;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, StreamSubscription<ValidationState>> validationSubscriptions = {};
  Map<String, ValidationState> validationStates = {};
  Map<String, ValidationBloc> validationBlocs = {};
  Map<String, FocusNode> _focusNodes = {};
  Map<String, TextEditingController> _controllers = {};
  String? _errorText;
  int _step = 1;
  bool _success = false;

  initState() {
    super.initState();
    _email = widget.email ?? "";
    _step = widget.isLogin ? 1 : 3;
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
    _controllers[Constants.EMAIL_FIELD]!.text = _email!;
  }

  didUpdateWidget(FBEmailLoginForm old) {
    if (old.email != widget.email) {
      _email = widget.email ?? "";
      _controllers[Constants.EMAIL_FIELD]!.text = _email!;
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

  Future<void> _doLogin() async {
    if (_loading) {
      return;
    }
    AppConfig config = context.read();
    try {
      setState(() {
        _loading = true;
        _errorText = null;
      });
      if (_step == 1 || _step == 2) {
        String? continueUrl;
        if (widget.continuePath != null) {
          continueUrl =
              "https://${config.webDomain}${widget.continuePath!.location}";
        }
        await LoginService.sendEmailLink(_email!, config,
            continueUrl: continueUrl);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("email", _email!);
      }
      setState(() {
        _success = true;
      });
    } on AuthException catch (error, _) {
      print('error $error');
      if (error.code == AuthExceptionCode.InvalidEmail) {
        setState(() {
          _errorText = S.of(context).enter_valid_email;
        });
      }
      if (error.code == AuthExceptionCode.UserNotFound) {
        setState(() {
          _step = 2;
        });
      }
    } catch (error, stacktrace) {
      print('error ${error}');
      print('stacktrace ${stacktrace}');
      if (mounted) {
        setState(() {
          _errorText = S.of(context).default_error_title;
          _success = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _onSubmit() async {
    if (!isValid) {
      _formKey.currentState!.validate();
      return;
    }
    _formKey.currentState!.save();
    await _doLogin();
  }

  String get title {
    switch (_step) {
      case 1:
        return widget.title ?? S.of(context).sign_in_email;
      case 2:
        return S.of(context).didnt_recognize_email;
      default:
        return S.of(context).sign_up_email;
    }
  }

  String get subtitle {
    switch (_step) {
      case 1:
        return S.of(context).email_associated_with_account;
      case 2:
        return S.of(context).would_sign_in_different_email;
      default:
        return S.of(context).enter_email_create_account;
    }
  }

  String get successSubtitle {
    switch (_step) {
      case 1:
      case 2:
        return "${S.of(context).click_link_sent} $_email ${S.of(context).to_sigin_in}";
      default:
        return "${S.of(context).click_link_sent} $_email ${S.of(context).to_complete_setup}";
    }
  }

  Widget _buildSuccess() {
    return Container(
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
                S.of(context).check_your_inbox,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 48.0),
          Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
              child: Text(
                successSubtitle,
                style: Theme.of(context).textTheme.subtitle2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 100.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginButton(
                key: ValueKey("LoginButton"),
                text: S.of(context).ok.toUpperCase(),
                onPressed: widget.onSuccess,
                loading: _loading,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLoginView() {
    return PageTransitionSwitcher(
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
        );
      },
      child: KeyedSubtree(
        key: ValueKey<int>(_step),
        child: Form(
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
                    constraints:
                        BoxConstraints(maxWidth: context.panelMaxWidth),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: context.panelMaxWidth),
                    child: Text(
                      subtitle,
                      style: Theme.of(context).textTheme.subtitle2,
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
                    _onSubmit();
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
                        onPressed: _onSubmit,
                        loading: _loading,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16.0),
                if (_step == 1 || _step == 3)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      icon: Icon(Icons.chevron_left_outlined),
                      label: Text(S.of(context).all_signin_options),
                      onPressed: widget.onCancel,
                    ),
                  ),
                if (_step == 2)
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          child: Text(S.of(context).all_signin_options),
                          onPressed: widget.onCancel,
                        ),
                      ),
                      Text(" ${S.of(context).or} "),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                            child: Text(
                                S.of(context).create_new_account.toLowerCase()),
                            onPressed: () {
                              setState(() {
                                _step = 3;
                              });
                            }),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_success) {
      body = _buildSuccess();
    } else {
      body = _buildLoginView();
    }
    return SafeArea(
      child: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
          );
        },
        child: body,
      ),
    );
  }
}
