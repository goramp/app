import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/widgets/custom/login_code.dart';
import 'package:goramp/widgets/custom/login_errors.dart';
import 'package:goramp/widgets/custom/fb_email_link_signup_view2.dart';
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
                  SizedBox(
                    child: Center(
                      child: Checkbox(
                        onChanged: onAccept,
                        value: accept,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    width: 48.0,
                    height: 48.0,
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
                              S.of(context).kurobi_terms,
                              style: buttonStyle,
                            ).clickable(follow),
                          ),
                        ),
                      ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                    height: 48,
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
  final ValueChanged<UserWithProfile>? onSuccess;

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
  bool _sendingCode = false;
  String? _code;
  String? _acceptTermsError;
  List<String> _errors = [];
  ValueNotifier<bool> _valid = ValueNotifier<bool>(false);
  ValueNotifier<bool> _acceptTerms = ValueNotifier<bool>(false);
  User? _user;

  initState() {
    super.initState();
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
    _focusNodes[Constants.CODE_FIELD] = FocusNode();
  }

  void _checkIsSignUpValid() {
    final statesValid = _validationBlocs.values
        .map<ValidationState>((bloc) => bloc.state.value)
        .every((ValidationState? state) {
      if (state is ValidationResult) {
        return state.isValid;
      }
      return false;
    });
    _valid.value = statesValid &&
        _code != null &&
        _code!.length == 6 &&
        _acceptTerms.value;
  }

  _handleFieldValidation(String fieldName, ValidationState state) {
    _checkIsSignUpValid();
  }

  int? get age {
    if (_birthDay == null) return null;
    final ageDifMs = DateTime.now().difference(_birthDay!).inMilliseconds;
    final ageDate = DateTime.fromMillisecondsSinceEpoch(ageDifMs);
    final age = ageDate.year - 1970;
    return age;
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

  Future<void> _signUp() async {
    if (_loading) {
      return;
    }
    AppConfig config = context.read();
    try {
      final email = _controllers[Constants.EMAIL_FIELD]!.text.trim();
      final password = _controllers[Constants.PASSWORD_FIELD]!.text.trim();
      setState(() {
        _loading = true;
      });
      final user = await LoginService.signUp(email, password, _code!, config);
      setState(() {
        _user = user;
      });
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

  Future<void> _sendCode() async {
    if (_sendingCode) {
      return;
    }
    AppConfig config = context.read();
    try {
      setState(() {
        _sendingCode = true;
      });
      _formKey.currentState!.save();
      final email = _controllers[Constants.EMAIL_FIELD]!.text.trim();
      await LoginService.sendSignUpEmailOTP(email, config);
      setState(() {
        _sendingCode = false;
      });
      SnackbarHelper.show(S.of(context).verification_code_sent, context);
    } on SignUpException catch (error, _) {
      if (mounted)
        setState(() {
          _errors = [
            SignUpException.mapCodeToMessage(error.code, context: context),
          ];
        });
    } catch (error) {
      if (mounted)
        setState(() {
          _errors = [
            SignUpException.mapCodeToMessage(SignUpExceptionCode.Unknown,
                context: context),
          ];
        });
    } finally {
      if (mounted) {
        setState(() {
          _sendingCode = false;
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

  Widget _buildStep1() {
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
                SizedBox(height: 64.0),
                // _DateField(
                //   validationBloc: _validationBlocs[Constants.BIRTHDAY_FIELD]!,
                //   fieldName: S.of(context).birthday,
                //   selectedDate: _birthDay,
                //   focusNode: _focusNodes[Constants.BIRTHDAY_FIELD],
                //   onTap: unfocus,
                //   selectDate: (DateTime value) {
                //     _birthDay = value;
                //     _validationBlocs[Constants.BIRTHDAY_FIELD]!
                //         .onTextChanged
                //         .add(age);
                //     _checkIsSignUpValid();
                //   },
                //   maxWidth: context.panelMaxWidth,
                // ),
                // spacer,
                WithTextFieldValidation(
                  validationEnabled: true,
                  validationBloc: _validationBlocs[Constants.EMAIL_FIELD],
                  textController: _controllers[Constants.EMAIL_FIELD],
                  autoCorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodes[Constants.EMAIL_FIELD],
                  maxWidth: context.panelMaxWidth,
                  onFieldSubmitted: (value) {
                    _fieldFocusChange(
                        context,
                        _focusNodes[Constants.EMAIL_FIELD]!,
                        _focusNodes[Constants.PASSWORD_FIELD]!);
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
                  onFieldSubmitted: (value) {
                    _fieldFocusChange(
                        context,
                        _focusNodes[Constants.PASSWORD_FIELD]!,
                        _focusNodes[Constants.CODE_FIELD]!);
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
                KeyedSubtree(
                  key: ValueKey(_sendingCode),
                  child: StreamBuilder<ValidationState>(
                      stream: _validationBlocs[Constants.EMAIL_FIELD]!.state,
                      builder: (context, snapshot) {
                        final isEmailValid = snapshot.hasData &&
                            snapshot.data! is ValidationResult &&
                            (snapshot.data! as ValidationResult).isValid;
                        return DigitCode(
                          focusNode: _focusNodes[Constants.CODE_FIELD],
                          maxWidth: context.panelMaxWidth,
                          onSaved: (String? val) {
                            _code = val?.trim();
                          },
                          onFieldSubmitted: (value) {
                            _code = value.trim();
                            _onSubmit();
                          },
                          enabled: isEmailValid,
                          maxLength: 6,
                          sending: _sendingCode,
                          onSend: _sendCode,
                          onChanged: (String? val) {
                            _code = val?.trim();
                            _checkIsSignUpValid();
                          },
                        );
                      }),
                ),
                ValueListenableBuilder(
                  valueListenable: _acceptTerms,
                  builder: (_, bool accepted, __) {
                    return _TermsWidget(
                      accept: accepted,
                      onAccept: (bool? accept) {
                        _acceptTermsError = null;
                        _acceptTerms.value = accept ?? false;
                        _checkIsSignUpValid();
                      },
                      error: _acceptTermsError,
                    );
                  },
                ),
                spacer,
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
                    alignment: Alignment.center,
                    constraints:
                        BoxConstraints(maxWidth: context.panelMaxWidth),
                    child: ValueListenableBuilder(
                      valueListenable: _valid,
                      builder: (_, bool valid, __) {
                        return LoginButton(
                          text: S.of(context).next.toUpperCase(),
                          onPressed: valid ? _onSubmit : null,
                          loading: _loading,
                          padding: EdgeInsets.zero,
                        );
                      },
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

  @override
  Widget build(BuildContext context) {
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
          key: ValueKey(_user),
          child: _user != null
              ? SignUpForm2(
                  user: _user!,
                  onSuccess: widget.onSuccess,
                  onCancel: widget.onCancel)
              : _buildStep1(),
        ));
  }
}
