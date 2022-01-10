import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/custom/login_buttons.dart';
import 'package:goramp/widgets/index.dart';
import 'package:provider/provider.dart';
import 'package:goramp/generated/l10n.dart';
import 'dart:async';

class LoginForm extends StatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;
  final VoidCallback? onSignup;
  final VoidCallback? onForgot;
  final ValueChanged<UserWithProfile>? onLogin;
  final OnAccountExist? onAccountExist;
  const LoginForm(
      {Key? key,
      this.onSuccess,
      this.onCancel,
      this.onLogin,
      this.onSignup,
      this.onForgot,
      this.onAccountExist})
      : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginForm> {
  bool _loading = false;
  String? _email;
  String? _password;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, StreamSubscription<ValidationState>> validationSubscriptions = {};
  Map<String, ValidationState> validationStates = {};
  Map<String, ValidationBloc> validationBlocs = {};
  Map<String, FocusNode> _focusNodes = {};
  Map<String, TextEditingController> _controllers = {};
  bool _showPassword = false;

  initState() {
    super.initState();
    _controllers[Constants.EMAIL_FIELD] = TextEditingController();
    _focusNodes[Constants.EMAIL_FIELD] = FocusNode();
    _controllers[Constants.EMAIL_FIELD]!.addListener(() {
      validationBlocs[Constants.EMAIL_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.EMAIL_FIELD]!.text);
    });
    _controllers[Constants.PASSWORD_FIELD] = TextEditingController();
    _focusNodes[Constants.PASSWORD_FIELD] = FocusNode();
    _controllers[Constants.PASSWORD_FIELD]!.addListener(() {
      validationBlocs[Constants.PASSWORD_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.PASSWORD_FIELD]!.text);
    });
    _setUsernameValidation();
    _setPasswordValidation();
  }

  _setUsernameValidation() {
    validationBlocs[Constants.EMAIL_FIELD] = ValidationBloc<String>(
        EmailValidator(Constants.EMAIL_FIELD,
            config: context.read(), checkExistence: false, context: context));
    validationSubscriptions[Constants.EMAIL_FIELD] =
        validationBlocs[Constants.EMAIL_FIELD]!
            .state
            .listen((ValidationState state) {
      _handleFieldValidation(Constants.EMAIL_FIELD, state);
    });
  }

  _setPasswordValidation() {
    validationBlocs[Constants.PASSWORD_FIELD] = ValidationBloc<String>(
        PasswordValidator(Constants.PASSWORD_FIELD, context: context));
    validationSubscriptions[Constants.PASSWORD_FIELD] =
        validationBlocs[Constants.PASSWORD_FIELD]!
            .state
            .listen((ValidationState state) {
      _handleFieldValidation(Constants.PASSWORD_FIELD, state);
    });
  }

  bool get isValid {
    return validationStates.values.isEmpty
        ? false
        : validationStates.values.every((ValidationState state) {
            if (state is ValidationResult) {
              return state.isValid;
            }
            return false;
          });
  }

  _handleFieldValidation(String fieldName, ValidationState state) {
    setState(() {
      validationStates[fieldName] = state;
    });
  }

  dispose() {
    super.dispose();
    validationBlocs.forEach((String _, ValidationBloc bloc) => bloc.dispose());
    validationSubscriptions
        .forEach((String _, StreamSubscription sub) => sub.cancel());
    _controllers.forEach(
        (String _, TextEditingController controller) => controller.dispose());
    _focusNodes.forEach((String _, FocusNode node) => node.dispose());
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<void> _onLogin(User user) async {
    AppConfig config = context.read();
    final profile = await LoginHelper.onLogin(context, user);
    LoginService.updateLogin(config);
    widget.onLogin?.call(UserWithProfile(profile: profile, user: user));
  }

  Future<void> _doLogin() async {
    if (_loading) {
      return;
    }
    try {
      setState(() {
        _loading = true;
      });
      final user = await LoginService.login(_email!, _password!);
      await _onLogin(user!);
    } on AuthException catch (e) {
      if (e.code == AuthExceptionCode.AccountExistWithDifferentCredentials) {
        final preferredProvider =
            await LoginService.preferredProvider(e.email!);
        widget.onAccountExist!(e, preferredProvider);
      } else if (e.code == AuthExceptionCode.NetworkError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).connection_error),
            action: SnackBarAction(
              label: S.of(context).try_again,
              onPressed: () {
                _doLogin();
              },
            ),
          ),
        );
      } else {
        SnackbarHelper.show(
            LoginHelper.authExceptionMessage(context, e), context);
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

  Widget _buildLoginView() {
    final space = const SizedBox(height: 16.0);
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
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
                  constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
                  child: Text(
                    S.of(context).login_with_email,
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 64.0),
              space,
              WithTextFieldValidation(
                validationEnabled: false,
                validationBloc: validationBlocs[Constants.EMAIL_FIELD],
                textController: _controllers[Constants.EMAIL_FIELD],
                autoCorrect: false,
                autoFocus: true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                focusNode: _focusNodes[Constants.EMAIL_FIELD],
                onFieldSubmitted: (value) {
                  _fieldFocusChange(
                      context,
                      _focusNodes[Constants.EMAIL_FIELD]!,
                      _focusNodes[Constants.PASSWORD_FIELD]);
                },
                onSaved: (String? val) {
                  _email = val?.trim();
                },
                validator: (value) {
                  final state = validationStates[Constants.EMAIL_FIELD];
                  if (state != null) {
                    if (state is ValidationResult)
                      return state.isValid
                          ? ""
                          : state.fieldError!.errors.first.message;
                    if (state is ValidationNoTerm) {
                      return S.of(context).enter_valid_email;
                    }
                  }
                  return "";
                },
                labelText: S.of(context).email,
                maxWidth: context.panelMaxWidth,
              ),
              space,
              WithTextFieldValidation(
                validationEnabled: false,
                validationBloc: validationBlocs[Constants.PASSWORD_FIELD],
                textController: _controllers[Constants.PASSWORD_FIELD],
                autoCorrect: false,
                // textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                focusNode: _focusNodes[Constants.PASSWORD_FIELD],
                onFieldSubmitted: (value) {
                  _onSubmit();
                },
                onSaved: (String? val) {
                  _password = val?.trim();
                },
                validator: (value) {
                  final state = validationStates[Constants.PASSWORD_FIELD];
                  if (state != null) {
                    if (state is ValidationResult)
                      return state.isValid
                          ? ""
                          : state.fieldError!.errors.first.message;
                    if (state is ValidationNoTerm) {
                      return S.of(context).password_required;
                    }
                  }
                  return "";
                },
                labelText: S.of(context).password,
                maxWidth: context.panelMaxWidth,
                obscureText: !_showPassword,
                sufficIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(_showPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                ),
              ),
              space,
              Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: widget.onForgot,
                            child: Text(
                              S.of(context).forgot_password,
                            ),
                          ),
                        ],
                      ),
                      space,
                      LoginButton(
                        key: ValueKey("LoginButton"),
                        text: S.of(context).sign_in.toUpperCase(),
                        onPressed: isValid ? _onSubmit : null,
                        loading: _loading,
                        padding: EdgeInsets.zero,
                      )
                    ],
                  ),
                ),
              ),
              space,
              Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          icon: Icon(Icons.chevron_left_outlined),
                          label: Text(S.of(context).all_signin_options),
                          onPressed: widget.onCancel,
                        ),
                        flex: 1,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        height: 40,
                        child: VerticalDivider(
                          width: 4.0,
                          thickness: context.dividerHairLineWidth,
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          child: Text(S.of(context).sign_up),
                          onPressed: widget.onSignup,
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: _buildLoginView(),
        onWillPop: () async {
          if (widget.onCancel != null) {
            widget.onCancel!.call();
            return false;
          }
          return true;
        });
  }
}
