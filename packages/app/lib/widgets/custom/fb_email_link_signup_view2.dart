import 'dart:io';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:provider/provider.dart';
import 'package:goramp/generated/l10n.dart';

class SignUpForm2 extends StatefulWidget {
  final String? title;
  final User user;
  final UserProfile? profile;
  final ValueChanged<UserWithProfile>? onSuccess;
  final VoidCallback? onCancel;
  final bool enableLoginButton;

  const SignUpForm2(
      {Key? key,
      required this.user,
      this.profile,
      this.title,
      this.onSuccess,
      this.onCancel,
      this.enableLoginButton = true})
      : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm2> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, StreamSubscription<ValidationState>> _validationSubscriptions =
      {};
  Map<String, ValidationState> validationStates = {};
  Map<String, ValidationBloc> _validationBlocs = {};
  Map<String, FocusNode> _focusNodes = {};
  Map<String, TextEditingController> _controllers = {};

  ValueNotifier<bool> _valid = ValueNotifier<bool>(false);

  initState() {
    super.initState();
    // name setup
    final names = widget.profile?.name?.split(' ');
    _controllers[Constants.FIRST_NAME_FIELD] = TextEditingController();

    _validationBlocs[Constants.FIRST_NAME_FIELD] = ValidationBloc<String>(
      NameValidator(Constants.FIRST_NAME_FIELD, context: context),
    );
    _controllers[Constants.FIRST_NAME_FIELD]!.addListener(() {
      _validationBlocs[Constants.FIRST_NAME_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.FIRST_NAME_FIELD]!.text);
    });
    _validationSubscriptions[Constants.FIRST_NAME_FIELD] =
        _validationBlocs[Constants.FIRST_NAME_FIELD]!
            .state
            .listen((ValidationState state) {
      _handleFieldValidation(Constants.FIRST_NAME_FIELD, state);
    });
    _focusNodes[Constants.FIRST_NAME_FIELD] = FocusNode();

    _controllers[Constants.LAST_NAME_FIELD] = TextEditingController();

    _validationBlocs[Constants.LAST_NAME_FIELD] = ValidationBloc<String>(
      NameValidator(Constants.LAST_NAME_FIELD, context: context),
    );
    _controllers[Constants.LAST_NAME_FIELD]!.addListener(() {
      _validationBlocs[Constants.LAST_NAME_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.LAST_NAME_FIELD]!.text);
    });
    _validationSubscriptions[Constants.LAST_NAME_FIELD] =
        _validationBlocs[Constants.LAST_NAME_FIELD]!
            .state
            .listen((ValidationState state) {
      _handleFieldValidation(Constants.LAST_NAME_FIELD, state);
    });
    _focusNodes[Constants.LAST_NAME_FIELD] = FocusNode();

    _controllers[Constants.USERNAME_FIELD] = TextEditingController();

    _validationBlocs[Constants.USERNAME_FIELD] = ValidationBloc<String>(
      UsernameValidator(Constants.USERNAME_FIELD, context.read(),
          context: context),
    );
    _controllers[Constants.USERNAME_FIELD]!.addListener(() {
      _validationBlocs[Constants.USERNAME_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.USERNAME_FIELD]!.text);
    });
    _validationSubscriptions[Constants.USERNAME_FIELD] =
        _validationBlocs[Constants.USERNAME_FIELD]!
            .state
            .listen((ValidationState state) {
      _handleFieldValidation(Constants.USERNAME_FIELD, state);
    });
    _focusNodes[Constants.USERNAME_FIELD] = FocusNode();
    if (names != null && names.length > 0) {
      _controllers[Constants.FIRST_NAME_FIELD]!.text = names[0];
    }
    if (names != null && names.length > 1) {
      _controllers[Constants.LAST_NAME_FIELD]!.text = names[1];
    }
    _controllers[Constants.USERNAME_FIELD]!.text =
        widget.profile?.username ?? '';
  }

  void _checkIsSignUpValid() {
    _valid.value = _validationBlocs.values
        .map<ValidationState>((bloc) => bloc.state.value)
        .every((ValidationState? state) {
      if (state is ValidationResult) {
        return state.isValid;
      }
      return false;
    });
  }

  _handleFieldValidation(String fieldName, ValidationState state) {
    _checkIsSignUpValid();
  }

  void _onLogin() {
    LoginService.logout();
    widget.onCancel?.call();
  }

  dispose() {
    super.dispose();
    _focusNodes.forEach((String _, FocusNode node) => node.dispose());
    _validationBlocs.forEach((String _, ValidationBloc bloc) => bloc.dispose());
    _validationSubscriptions
        .forEach((String _, StreamSubscription sub) => sub.cancel());
    _controllers.forEach(
        (String _, TextEditingController controller) => controller.dispose());
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<void> _signUp() async {
    if (_loading) {
      return;
    }
    try {
      setState(() {
        _loading = true;
      });
      AppConfig config = context.read();
      final firstName = _controllers[Constants.FIRST_NAME_FIELD]!.text.trim();
      final lastName = _controllers[Constants.LAST_NAME_FIELD]!.text.trim();
      final username = _controllers[Constants.USERNAME_FIELD]!.text.trim();
      final userProfile =
          await LoginService.register(username, firstName, lastName, config);
      await LoginHelper.onSignup(
          context, userProfile.user, userProfile.profile);
      LoginService.updateLogin(config);
      widget.onSuccess?.call(userProfile);
    } on SignUpException catch (error) {
      SnackbarHelper.show(
          error.message ?? StringResources.DEFAULT_ERROR_TITLE2, context);
    } on ConnectionException catch (error) {
      print('error ${error}');
      SnackbarHelper.show(CONNECTION_ERROR_MESSAGE, context);
    } on SocketException catch (error) {
      print('error ${error}');
      SnackbarHelper.show(CONNECTION_ERROR_MESSAGE, context);
    } on HandshakeException catch (error) {
      print('error ${error}');
      SnackbarHelper.show(CONNECTION_ERROR_MESSAGE, context);
    } catch (error) {
      print('error ${error}');
      SnackbarHelper.show(StringResources.DEFAULT_ERROR_TITLE2, context);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _onSubmit() async {
    _checkIsSignUpValid();
    if (!_valid.value) {
      return;
    }
    _formKey.currentState!.save();
    await _signUp();
  }

  void unfocus() {
    FocusNode? node =
        _focusNodes.values.firstWhereOrNull((FocusNode node) => node.hasFocus);
    if (node != null) {
      node.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacer = const SizedBox(height: 16.0);
    return WillPopScope(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Container(
            alignment: Alignment.center,
            child: ListView(
              padding: EdgeInsets.only(left: 16.0, right: 16),
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 64.0),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: context.panelMaxWidth),
                    child: Text(
                      widget.title ?? S.of(context).almost_there,
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 64.0),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    constraints:
                        BoxConstraints(maxWidth: context.panelMaxWidth),
                    child: Row(
                      children: [
                        Expanded(
                          child: WithTextFieldValidation(
                            validationEnabled: true,
                            validationBloc:
                                _validationBlocs[Constants.FIRST_NAME_FIELD],
                            textController:
                                _controllers[Constants.FIRST_NAME_FIELD],
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            focusNode: _focusNodes[Constants.FIRST_NAME_FIELD],
                            onFieldSubmitted: (value) {
                              _fieldFocusChange(
                                  context,
                                  _focusNodes[Constants.FIRST_NAME_FIELD]!,
                                  _focusNodes[Constants.LAST_NAME_FIELD]!);
                            },
                            validator: (value) {
                              final state =
                                  validationStates[Constants.FIRST_NAME_FIELD];
                              if (state != null) {
                                if (state is ValidationResult) {
                                  return state.isValid
                                      ? null
                                      : state.fieldError!.errors.first.message;
                                }
                                if (state is ValidationNoTerm) {
                                  return S.of(context).first_name_required;
                                }
                              }
                              return null;
                            },
                            labelText: S.of(context).first_name,
                            textCapitalization: TextCapitalization.words,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: WithTextFieldValidation(
                            validationEnabled: true,
                            validationBloc:
                                _validationBlocs[Constants.LAST_NAME_FIELD],
                            textController:
                                _controllers[Constants.LAST_NAME_FIELD],
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            focusNode: _focusNodes[Constants.LAST_NAME_FIELD],
                            onFieldSubmitted: (value) {
                              _fieldFocusChange(
                                  context,
                                  _focusNodes[Constants.LAST_NAME_FIELD]!,
                                  _focusNodes[Constants.USERNAME_FIELD]!);
                            },
                            labelText: S.of(context).last_name,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              final state =
                                  validationStates[Constants.LAST_NAME_FIELD];
                              if (state != null) {
                                if (state is ValidationResult) {
                                  return state.isValid
                                      ? null
                                      : state.fieldError!.errors.first.message;
                                }
                                if (state is ValidationNoTerm) {
                                  return S.of(context).last_name_required;
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                spacer,
                WithTextFieldValidation(
                  validationEnabled: true,
                  validationBloc: _validationBlocs[Constants.USERNAME_FIELD],
                  textController: _controllers[Constants.USERNAME_FIELD],
                  autoCorrect: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  focusNode: _focusNodes[Constants.USERNAME_FIELD],
                  maxWidth: context.panelMaxWidth,
                  maxLength: 30,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  onFieldSubmitted: (value) {
                    _onSubmit();
                  },
                  validator: (value) {
                    final state = validationStates[Constants.USERNAME_FIELD];
                    if (state != null) {
                      if (state is ValidationResult)
                        return state.isValid
                            ? null
                            : state.fieldError?.errors.first.message;
                      if (state is ValidationNoTerm) {
                        return S.of(context).username_required;
                      }
                    }
                    return null;
                  },
                  labelText: S.of(context).username,
                  // errorHandler: _handleError,
                ),
                spacer,
                // const TermsWidget(),
                // spacer,
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    constraints:
                        BoxConstraints(maxWidth: context.panelMaxWidth),
                    child: ValueListenableBuilder(
                      valueListenable: _valid,
                      builder: (_, bool valid, __) {
                        return LoginButton(
                          text: S.of(context).continue_string.toUpperCase(),
                          onPressed: valid ? _onSubmit : null,
                          loading: _loading,
                          padding: EdgeInsets.zero,
                        );
                      },
                    ),
                  ),
                ),
                if (widget.enableLoginButton) spacer,
                if (widget.enableLoginButton)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      constraints:
                          BoxConstraints(maxWidth: context.panelMaxWidth),
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
                              child: Text(S.of(context).log_in),
                              onPressed: _onLogin,
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
        onWillPop: () async {
          if (widget.onCancel != null) {
            widget.onCancel!.call();
            return false;
          }
          return true;
        });
  }
}
