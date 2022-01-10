import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goramp/widgets/custom/login_errors.dart';
import 'package:goramp/widgets/index.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:goramp/generated/l10n.dart';
import '../../../bloc/index.dart';
import '../../../utils/index.dart';
import '../../../services/index.dart';

class ChangePassword extends StatefulWidget {
  final String? code;
  final String? lang;
  final String? continueUrl;
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  ChangePassword({
    this.code,
    this.lang,
    this.continueUrl,
    this.onSuccess,
    this.onCancel,
  });
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePassword> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, StreamSubscription<ValidationState>> validationSubscriptions = {};
  Map<String, ValidationState> validationStates = {};
  Map<String, ValidationBloc> validationBlocs = {};
  Map<String, FocusNode> _focusNodes = {};
  Map<String, TextEditingController> _controllers = {};
  bool _verifyingCode = false;
  AuthException? _verifyError;
  List<String> _errors = [];

  initState() {
    super.initState();
    _controllers[Constants.PASSWORD_FIELD] = TextEditingController();
    _focusNodes[Constants.PASSWORD_FIELD] = FocusNode();
    _controllers[Constants.PASSWORD_FIELD]!.addListener(() {
      validationBlocs[Constants.PASSWORD_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.PASSWORD_FIELD]!.text);
    });

    validationBlocs[Constants.PASSWORD_FIELD] = ValidationBloc<String>(
        PasswordValidator(Constants.PASSWORD_FIELD, context: context));
    validationSubscriptions[Constants.PASSWORD_FIELD] =
        validationBlocs[Constants.PASSWORD_FIELD]!
            .state
            .listen((ValidationState state) {
      _handleFieldValidation(Constants.PASSWORD_FIELD, state);
    });

    _controllers[Constants.PASSWORD_CONFIRM_FIELD] = TextEditingController();
    _focusNodes[Constants.PASSWORD_CONFIRM_FIELD] = FocusNode();
    _controllers[Constants.PASSWORD_CONFIRM_FIELD]!.addListener(() {
      validationBlocs[Constants.PASSWORD_CONFIRM_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.PASSWORD_CONFIRM_FIELD]!.text);
    });
    validationBlocs[Constants.PASSWORD_CONFIRM_FIELD] = ValidationBloc<String>(
        PasswordValidator(Constants.PASSWORD_CONFIRM_FIELD, context: context));
    validationSubscriptions[Constants.PASSWORD_CONFIRM_FIELD] =
        validationBlocs[Constants.PASSWORD_CONFIRM_FIELD]!
            .state
            .listen((ValidationState state) {
      _handleFieldValidation(Constants.PASSWORD_CONFIRM_FIELD, state);
    });
    _verifyCode();
  }

  Future<void> _verifyCode() async {
    try {
      if (widget.code == null) {
        throw new AuthException(AuthExceptionCode.InvalidActionCode);
      }
      if (_verifyingCode) {
        return;
      }
      setState(() {
        _verifyingCode = true;
      });
      await LoginService.verifyPasswordResetCode(widget.code!);
    } on AuthException catch (error) {
      _verifyError = error;
    } catch (error) {
      _verifyError = AuthException(AuthExceptionCode.Unknown,
          message: S.of(context).default_error_title);
    }
    setState(() {
      if (mounted) {
        _verifyingCode = false;
      }
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
            }) &&
            _controllers[Constants.PASSWORD_FIELD]!.text ==
                _controllers[Constants.PASSWORD_CONFIRM_FIELD]!.text;
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

  Future<void> _change() async {
    if (_loading) {
      return;
    }
    try {
      setState(() {
        _loading = true;
      });
      await LoginService.recoverPassword(
          widget.code!, _controllers[Constants.PASSWORD_FIELD]!.text);
      SnackbarHelper.show(S.of(context).password_reset_successful, context);
      widget.onSuccess?.call();
    } on SignUpException catch (error) {
      print('error $error');
    } on ConnectionException catch (error) {
      print('error ${error}');
      SnackbarHelper.show(CONNECTION_ERROR_MESSAGE, context);
    } on SocketException catch (error) {
      print('error ${error}');
      SnackbarHelper.show(CONNECTION_ERROR_MESSAGE, context);
    } on HandshakeException catch (error) {
      print('error ${error}');
      SnackbarHelper.show(CONNECTION_ERROR_MESSAGE, context);
    } catch (error, stacktrace) {
      print('error ${error}');
      ErrorHandler.report(error, stacktrace);
      SnackbarHelper.show(S.of(context).default_error_title2, context);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _onSubmit() async {
    final errors = _getErrors();
    if (errors.isNotEmpty) {
      setState(() {
        _errors = errors;
      });
    } else {
      setState(() {
        _errors = [];
      });
    }
    if (isValid) {
      _formKey.currentState!.save();
      await _change();
    }
  }

  List<String> _getErrors() {
    final errors = Set<String>();
    validationBlocs.forEach((key, value) {
      final error = _getError(key);
      if (error != null) {
        errors.add(error);
      }
    });
    if (_controllers[Constants.PASSWORD_FIELD]!.text !=
        _controllers[Constants.PASSWORD_CONFIRM_FIELD]!.text) {
      errors.add("Password does not match");
    }
    return errors.toList();
  }

  String? _getError(String fieldName) {
    final state = validationBlocs[fieldName]!.state.valueOrNull;
    if (state != null) {
      if (state is ValidationResult) {
        return state.isValid ? null : state.fieldError!.errors.first.message;
      }
      if (state is ValidationNoTerm) {
        return validationBlocs[fieldName]!.validator.emptyResultError();
      }
    }
    return null;
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _buildLoginView() {
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
                  S.of(context).please_enter_new_password,
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 48.0),
            WithTextFieldValidation(
                validationEnabled: true,
                validationBloc: validationBlocs[Constants.PASSWORD_FIELD],
                textController: _controllers[Constants.PASSWORD_FIELD],
                autoCorrect: false,
                onFieldSubmitted: (value) {
                  _fieldFocusChange(
                      context,
                      _focusNodes[Constants.LAST_NAME_FIELD]!,
                      _focusNodes[Constants.EMAIL_FIELD]!);
                },
                autoFocus: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _focusNodes[Constants.PASSWORD_FIELD],
                labelText: S.of(context).new_password,
                obscureText: true,
                maxWidth: context.panelMaxWidth),
            SizedBox(height: 16.0),
            WithTextFieldValidation(
              validationEnabled: true,
              validationBloc: validationBlocs[Constants.PASSWORD_CONFIRM_FIELD],
              textController: _controllers[Constants.PASSWORD_CONFIRM_FIELD],
              autoCorrect: false,
              // textCapitalization: TextCapitalization.words,
              autoFocus: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              focusNode: _focusNodes[Constants.PASSWORD_CONFIRM_FIELD],
              onFieldSubmitted: (value) {
                _onSubmit();
              },
              labelText: S.of(context).confirm_password,

              maxWidth: context.panelMaxWidth,
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            if (_errors.isNotEmpty)
              LoginErrors(
                _errors,
                onClear: () {
                  setState(() {
                    _errors = [];
                  });
                },
              ),
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
                child: LoginButton(
                  text: S.of(context).change.toUpperCase(),
                  onPressed: _onSubmit,
                  loading: _loading,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                child: Text(S.of(context).log_in_different_user),
                onPressed: widget.onCancel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    String error = "";
    switch (_verifyError!.code) {
      case AuthExceptionCode.ExpiredActionCode:
      case AuthExceptionCode.InvalidActionCode:
        error = S.of(context).invalid_expired_action_code;
        break;
      case AuthExceptionCode.UserDisabled:
        error = S.of(context).account_disabled;
        break;
      case AuthExceptionCode.UserNotFound:
        error = S.of(context).user_not_found;
        break;
      default:
        error = S.of(context).default_error_title;
        break;
    }
    VoidCallback? action;
    switch (_verifyError!.code) {
      case AuthExceptionCode.ExpiredActionCode:
      case AuthExceptionCode.InvalidActionCode:
        action = widget.onCancel;
        break;
      case AuthExceptionCode.Unknown:
        action = _verifyCode;
        break;
      default:
        action = null;
        break;
    }
    return SizedBox.expand(
      // alignment: Alignment.center,
      // width: desktopMaxWidth,
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
              error,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          VSpace(Insets.ls),
          Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
              child: action != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextButton(
                            child: Text(S.of(context).log_in),
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
                            child: Text(S.of(context).try_again),
                            onPressed: action,
                          ),
                          flex: 1,
                        ),
                      ],
                    )
                  : TextButton(
                      child: Text(S.of(context).log_in),
                      onPressed: widget.onCancel,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_verifyingCode) {
      body = FeedLoader(
        size: 40,
      );
    } else if (_verifyError != null) {
      body = _buildError(context);
    } else {
      body = _buildLoginView();
    }
    return WillPopScope(
      child: body,
      onWillPop: () async {
        if (widget.onCancel != null) {
          widget.onCancel!.call();
          return false;
        }
        return true;
      },
    );
  }
}
