import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/custom/login_code.dart';
import 'package:goramp/widgets/custom/login_errors.dart';
import 'package:goramp/widgets/index.dart';
import 'package:provider/provider.dart';
import 'package:goramp/generated/l10n.dart';
import 'dart:async';

class FBEmailUpdateForm extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onCancel;
  final String? title;
  final String? email;
  FBEmailUpdateForm({
    Key? key,
    required this.onSuccess,
    this.title,
    this.email,
    required this.onCancel,
  }) : super(key: key);
  @override
  _EmailLoginPageState createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<FBEmailUpdateForm>
    with SingleTickerProviderStateMixin {
  bool _loading = false;
  bool _sendingCode = false;
  String? _email;
  String? _code;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, StreamSubscription<ValidationState>> validationSubscriptions = {};
  Map<String, ValidationState> validationStates = {};
  Map<String, ValidationBloc> validationBlocs = {};
  Map<String, FocusNode> _focusNodes = {};
  Map<String, TextEditingController> _controllers = {};
  String? _errorText;
  bool _success = false;
  List<String> _errors = [];
  ValueNotifier<bool> _valid = ValueNotifier<bool>(false);

  initState() {
    super.initState();
    _email = widget.email ?? "";
    _controllers[Constants.EMAIL_FIELD] = TextEditingController();
    _focusNodes[Constants.EMAIL_FIELD] = FocusNode();
    _controllers[Constants.EMAIL_FIELD]!.addListener(() {
      validationBlocs[Constants.EMAIL_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.EMAIL_FIELD]!.text);
    });
    validationBlocs[Constants.EMAIL_FIELD] = ValidationBloc<String>(
        EmailValidator(Constants.EMAIL_FIELD,
            config: context.read(), checkExistence: true, context: context));
    validationSubscriptions[Constants.EMAIL_FIELD] =
        validationBlocs[Constants.EMAIL_FIELD]!
            .state
            .listen((ValidationState state) {
      _handleFieldValidation(Constants.EMAIL_FIELD, state);
    });
    _controllers[Constants.EMAIL_FIELD]!.text = _email!;
    _focusNodes[Constants.CODE_FIELD] = FocusNode();
  }

  didUpdateWidget(FBEmailUpdateForm old) {
    if (old.email != widget.email) {
      _email = widget.email ?? "";
      _controllers[Constants.EMAIL_FIELD]!.text = _email!;
    }
    super.didUpdateWidget(old);
  }

  void _checkIsValid() {
    final statesValid = validationBlocs.values
        .map<ValidationState>((bloc) => bloc.state.value)
        .every((ValidationState? state) {
      if (state is ValidationResult) {
        return state.isValid;
      }
      return false;
    });
    _valid.value = statesValid && _code != null && _code!.length == 6;
  }

  _handleFieldValidation(String fieldName, ValidationState state) {
    _checkIsValid();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  dispose() {
    super.dispose();
    _focusNodes.forEach((String _, FocusNode node) => node.dispose());
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
      final user = await LoginService.updateEmailOTP(
        _email!,
        _code!,
        config,
      );
      if (user != null) {
        MyAppModel appModel = context.read();
        appModel.currentUser = user;
      }
      widget.onSuccess.call();
    } on SignUpException catch (error, _) {
      if (mounted)
        setState(() {
          _errors = [
            SignUpException.mapCodeToMessage(error.code, context: context),
          ];
        });
    } catch (error, _) {
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
      await LoginService.sendEmailOTP(_email!.trim(), config);
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
    _checkIsValid();
    if (!_valid.value) {
      return;
    }
    _formKey.currentState!.save();
    await _doLogin();
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
                S.of(context).sent_verification_link,
                style: Theme.of(context).textTheme.headline4,
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
    final spacer = const SizedBox(height: 16.0);
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
                  S.of(context).enter_email_address,
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 64.0),
            WithTextFieldValidation(
              validationEnabled: true,
              validationBloc: validationBlocs[Constants.EMAIL_FIELD],
              textController: _controllers[Constants.EMAIL_FIELD],
              autoCorrect: false,
              enabled: widget.email == null,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              focusNode: _focusNodes[Constants.EMAIL_FIELD],
              errorText: _errorText,
              maxWidth: context.panelMaxWidth,
              onFieldSubmitted: (value) {
                _fieldFocusChange(context, _focusNodes[Constants.EMAIL_FIELD]!,
                    _focusNodes[Constants.CODE_FIELD]!);
              },
              onSaved: (String? val) {
                _email = val?.trim();
              },
              labelText: S.of(context).your_email,
            ),
            spacer,
            KeyedSubtree(
              key: ValueKey(_sendingCode),
              child: StreamBuilder<ValidationState>(
                  stream: validationBlocs[Constants.EMAIL_FIELD]!.state,
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
                        _checkIsValid();
                      },
                    );
                  }),
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
                constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
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
          ],
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
            fillColor: Colors.transparent,
          );
        },
        child: body,
      ),
    );
  }
}
