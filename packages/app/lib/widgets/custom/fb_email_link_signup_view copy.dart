import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/services.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:url_launcher/link.dart' as launcher;
import 'package:goramp/generated/l10n.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class _TermsWidget extends StatelessWidget {
  final ValueChanged<bool?>? onAccept;
  final bool accept;
  final String? error;
  _TermsWidget({this.onAccept, required this.accept, this.error});
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final baseTextStyle =
        theme.textTheme.caption!.copyWith(fontWeight: FontWeight.bold);
    final buttonStyle =
        baseTextStyle.copyWith(color: theme.colorScheme.primary);

    AppConfig config = Provider.of(context, listen: false);

    return Align(
      alignment: Alignment.center,
      child: Container(
          constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    onChanged: onAccept,
                    value: accept,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(style: baseTextStyle, children: [
                        TextSpan(
                          text: S.of(context).confirm_age_terms,
                          style: baseTextStyle,
                        ),
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
                      ]),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              if (error != null)
                Text(
                  error!,
                  style: theme.textTheme.caption
                      ?.copyWith(color: theme.errorColor),
                )
            ],
          )),
    );
  }
}

class _DateField extends StatefulWidget {
  final TextStyle? valueStyle;
  final DateTime? selectedDate;
  final String fieldName;
  final ValueChanged<DateTime> selectDate;
  final VoidCallback? onTap;
  final String? error;
  final FocusNode? focusNode;
  final bool? showError;
  final ValidationBloc validationBloc;
  final FieldErrors? fieldErrors;
  final double? maxWidth;

  _DateField({
    Key? key,
    required this.fieldName,
    this.selectedDate,
    this.valueStyle,
    this.error,
    this.showError,
    this.onTap,
    this.focusNode,
    required this.validationBloc,
    this.maxWidth,
    required this.selectDate,
    this.fieldErrors,
  }) : super(key: key);

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<_DateField>
    with SingleTickerProviderStateMixin {
  bool _focused = false;
  bool _error = false;
  initState() {
    super.initState();
    _error = widget.showError ?? _error;
    widget.focusNode?.addListener(handleFocus);
  }

  handleFocus() {
    if (widget.focusNode?.hasFocus ?? false) {
      onPress();
    }
  }

  Future<void> _selectTimeCupertino(BuildContext context) async {
    // await showCupertinoModalPopup<DateTime>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return BottomSheetHelper.buildBottomPicker(
    //         CupertinoDatePicker(
    //           initialDateTime: widget.selectedDate,
    //           mode: CupertinoDatePickerMode.date,
    //           onDateTimeChanged: widget.selectDate,
    //         ),
    //         backgroundColor: Color.alphaBlend(
    //             Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
    //             Theme.of(context).colorScheme.surface));
    //   },
    // );
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (dateTime != null) {
      widget.selectDate(dateTime);
    }
  }

  onPress() async {
    if (!mounted) {
      return;
    }
    setState(() {
      _focused = true;
    });
    if (widget.onTap != null) {
      widget.onTap!();
    }
    await _selectTimeCupertino(context);
    if (mounted) {
      setState(() {
        _focused = false;
        _error = false;
      });
    }
    widget.focusNode?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: widget.maxWidth ?? double.infinity),
        child: StreamBuilder<ValidationState>(
          stream: widget.validationBloc.state,
          initialData: widget.fieldErrors != null
              ? ValidationResult(fieldError: widget.fieldErrors)
              : ValidationNoTerm(),
          builder:
              (BuildContext context, AsyncSnapshot<ValidationState> snapshot) {
            final state = snapshot.data;
            String? errorText;
            bool isValid = false;
            if (state is ValidationNoTerm) {
              errorText = null;
              isValid = false;
            } else if (state is ValidationResult) {
              if (state.isValid) {
                errorText = null;
                isValid = true;
              } else {
                errorText = state.fieldError?.errors[0].message;
                isValid = false;
              }
            }

            return GestureDetector(
                // borderRadius: kBorderRadius,
                onTap: onPress,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InputDecorator(
                    isFocused: _focused,
                    isEmpty: widget.selectedDate == null,
                    decoration: InputDecoration(
                      labelText: widget.fieldName,
                      errorText: errorText,
                      helperText: "Data will not be stored",
                      filled: true,
                      suffixIcon: isValid
                          ? Icon(
                              Icons.check_circle,
                              color: isDark ? Colors.green[200] : Colors.green,
                            )
                          : errorText != null
                              ? IconButton(
                                  icon: Icon(
                                    MdiIcons.closeCircle,
                                    color: theme.errorColor,
                                  ),
                                  onPressed: () {
                                    widget.validationBloc.onTextChanged
                                        .add(null);
                                  },
                                )
                              : null,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: kinputFieldHeight),
                      child: widget.selectedDate != null
                          ? Text(
                              DateFormat('MMM d yyyy')
                                  .format(widget.selectedDate!),
                              style: theme.textTheme.subtitle1)
                          : const Text(""),
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }
}

class SignUpForm1 extends StatefulWidget {
  final String? email;
  final VoidCallback? onCancel;
  final VoidCallback? onLogin;
  final ValueChanged<User>? onSuccess;

  const SignUpForm1(
      {Key? key, this.email, this.onCancel, this.onSuccess, this.onLogin})
      : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm1> {
  bool _loading = false;
  DateTime? _birthDay;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, StreamSubscription<ValidationState>> _validationSubscriptions =
      {};
  Map<String, ValidationState> validationStates = {};
  Map<String, ValidationBloc> _validationBlocs = {};
  Map<String, FocusNode> _focusNodes = {};
  Map<String, TextEditingController> _controllers = {};
  bool _showPassword = false;
  bool _acceptTerms = false;
  String? _acceptTermsError;
  Map<String, String?> _errors = {};

  initState() {
    super.initState();
    // name setup
    _controllers[Constants.EMAIL_FIELD] = TextEditingController();
    _validationBlocs[Constants.EMAIL_FIELD] = ValidationBloc<String>(
      EmailValidator(Constants.EMAIL_FIELD,
          config: context.read(), context: context),
    );
    _controllers[Constants.EMAIL_FIELD]!.addListener(() {
      _validationBlocs[Constants.EMAIL_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.EMAIL_FIELD]!.text);
    });
    _validationSubscriptions[Constants.EMAIL_FIELD] =
        _validationBlocs[Constants.EMAIL_FIELD]!
            .state
            .listen((ValidationState state) {
      _handleFieldValidation(Constants.EMAIL_FIELD, state);
    });
    _focusNodes[Constants.EMAIL_FIELD] = FocusNode();

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

    _controllers[Constants.PASSWORD_FIELD] = TextEditingController();
    _validationBlocs[Constants.PASSWORD_FIELD] = ValidationBloc<String>(
        PasswordValidator(Constants.PASSWORD_FIELD, context: context));
    _controllers[Constants.PASSWORD_FIELD]!.addListener(() {
      _validationBlocs[Constants.PASSWORD_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.PASSWORD_FIELD]!.text);
    });

    _validationSubscriptions[Constants.PASSWORD_FIELD] =
        _validationBlocs[Constants.PASSWORD_FIELD]!
            .state
            .listen((ValidationState state) {
      _handleFieldValidation(Constants.PASSWORD_FIELD, state);
    });
    _focusNodes[Constants.PASSWORD_FIELD] = FocusNode();

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
  }

  double get desktopMaxWidth => 400.0 + 100.0 * (cappedTextScale(context) - 1);

  bool get isValid {
    final allFieldsValid = validationStates.values.isEmpty
        ? false
        : validationStates.values.every((ValidationState state) {
            if (state is ValidationResult) {
              return state.isValid;
            }
            return false;
          });
    final valid = allFieldsValid && _acceptTerms;
    return valid;
  }

  int? get age {
    if (_birthDay == null) return null;
    final ageDifMs = DateTime.now().difference(_birthDay!).inMilliseconds;
    final ageDate = DateTime.fromMillisecondsSinceEpoch(ageDifMs);
    final age = ageDate.year - 1970;
    return age;
  }

  _handleFieldValidation(String fieldName, ValidationState state) {
    setState(() {
      validationStates[fieldName] = state;
    });
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
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<void> _onSignUp(User user) async {
    AppConfig config = context.read();
    await LoginHelper.onLogin(context, user);
    LoginService.updateLogin(config);
    widget.onSuccess?.call(user);
  }

  Future<void> _signUp() async {
    if (_loading) {
      return;
    }
    AppConfig config = context.read();
    try {
      setState(() {
        _loading = true;
      });
      // final user = await LoginService.signUp(
      //     firstName, lastName, email, username, password, config);
      // _onSignUp.call(user);
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
    //_runValidation();
    if (!isValid) {
      //_runValidation();
      //_formKey.currentState?.validate();
      return;
    }
    // _formKey.currentState?.save();
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
                      S.of(context).sign_up_with_email,
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 64.0),
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
                            errorText: _errors[Constants.FIRST_NAME_FIELD],
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
                                  _focusNodes[Constants.EMAIL_FIELD]!);
                            },
                            labelText: S.of(context).last_name,
                            textCapitalization: TextCapitalization.words,
                            errorText: _errors[Constants.LAST_NAME_FIELD],
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
                  validationBloc: _validationBlocs[Constants.EMAIL_FIELD],
                  textController: _controllers[Constants.EMAIL_FIELD],
                  autoCorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodes[Constants.EMAIL_FIELD],
                  errorText: _errors[Constants.EMAIL_FIELD],
                  maxWidth: context.panelMaxWidth,
                  onFieldSubmitted: (value) {
                    _fieldFocusChange(
                        context,
                        _focusNodes[Constants.EMAIL_FIELD]!,
                        _focusNodes[Constants.PASSWORD_FIELD]!);
                  },
                  validator: (value) {
                    final state = validationStates[Constants.EMAIL_FIELD];
                    if (state != null) {
                      if (state is ValidationResult)
                        return state.isValid
                            ? null
                            : state.fieldError?.errors.first.message;
                      if (state is ValidationNoTerm) {
                        return S.of(context).enter_valid_email;
                      }
                    }
                    return null;
                  },
                  labelText: S.of(context).your_email,
                  // errorHandler: _handleError,
                ),
                spacer,
                WithTextFieldValidation(
                  validationEnabled: true,
                  validationBloc: _validationBlocs[Constants.PASSWORD_FIELD],
                  textController: _controllers[Constants.PASSWORD_FIELD],
                  autoCorrect: false,
                  // textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodes[Constants.PASSWORD_FIELD],
                  obscureText: !_showPassword,
                  errorText: _errors[Constants.PASSWORD_FIELD],
                  onFieldSubmitted: (value) {
                    _fieldFocusChange(
                        context,
                        _focusNodes[Constants.PASSWORD_FIELD]!,
                        _focusNodes[Constants.USERNAME_FIELD]!);
                  },
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
                  validator: (value) {
                    final state = validationStates[Constants.PASSWORD_FIELD];
                    if (state != null) {
                      if (state is ValidationResult) {
                        return state.isValid
                            ? null
                            : state.fieldError!.errors.first.message;
                      }
                      if (state is ValidationNoTerm) {
                        return S.of(context).password_required;
                      }
                    }
                    return null;
                  },
                  labelText: S.of(context).password,
                  maxWidth: context.panelMaxWidth,
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
                  errorText: _errors[Constants.USERNAME_FIELD],
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
                _TermsWidget(
                  accept: _acceptTerms,
                  onAccept: (bool? accept) {
                    setState(() {
                      _acceptTermsError = null;
                      _acceptTerms = accept ?? false;
                    });
                  },
                  error: _acceptTermsError,
                ),
                spacer,
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    constraints:
                        BoxConstraints(maxWidth: context.panelMaxWidth),
                    child: LoginButton(
                      key: ValueKey("Sign Up"),
                      text: S.of(context).sign_up,
                      onPressed: isValid ? _onSubmit : null,
                      loading: _loading,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                spacer,
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
                            onPressed: widget.onLogin,
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
