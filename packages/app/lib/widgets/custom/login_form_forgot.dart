import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:goramp/widgets/index.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:goramp/generated/l10n.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../bloc/index.dart';
import '../../../utils/index.dart';
import '../../../services/index.dart';

class ForgotPassword extends StatefulWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSuccess;
  final VoidCallback? onLogin;

  ForgotPassword({this.onCancel, this.onSuccess, this.onLogin});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<ForgotPassword> {
  bool _loading = false;
  String? _email;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, StreamSubscription<ValidationState>> validationSubscriptions = {};
  Map<String, ValidationState> validationStates = {};
  Map<String, ValidationBloc> validationBlocs = {};
  Map<String, FocusNode> _focusNodes = {};
  Map<String, TextEditingController> _controllers = {};
  bool _success = false;

  initState() {
    super.initState();
    _controllers[Constants.EMAIL_FIELD] = TextEditingController();
    _focusNodes[Constants.EMAIL_FIELD] = FocusNode();
    _controllers[Constants.EMAIL_FIELD]!.addListener(() {
      validationBlocs[Constants.EMAIL_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.EMAIL_FIELD]!.text);
    });
    _setEmailValidation();
  }

  _setEmailValidation() {
    validationBlocs[Constants.EMAIL_FIELD] = ValidationBloc<String>(
        EmailValidator(Constants.EMAIL_FIELD,
            config: context.read(),
            existsIsValid: true,
            context: context,
            checkExistence: false));
    validationSubscriptions[Constants.EMAIL_FIELD] =
        validationBlocs[Constants.EMAIL_FIELD]!
            .state
            .listen((ValidationState state) {
      _handleFieldValidation(Constants.EMAIL_FIELD, state);
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
    _focusNodes.forEach((String _, FocusNode node) => node.dispose());
    validationSubscriptions
        .forEach((String _, StreamSubscription sub) => sub.cancel());
    _controllers.forEach(
        (String _, TextEditingController controller) => controller.dispose());
  }

  Future<void> _forgot() async {
    if (_loading) {
      return;
    }
    try {
      setState(() {
        _loading = true;
      });
      await LoginService.forgotPassword(_email!, context.read());
      setState(() {
        _success = true;
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

  void _onSubmit() async {
    if (isValid) {
      _formKey.currentState!.save();
      await _forgot();
    } else {
      _formKey.currentState!.validate();
    }
  }

  Future<void> _openEmailApp() async {
    const url = 'mailto://';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SnackbarHelper.show(S.of(context).could_not_open_mail_app, context);
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
          const SizedBox(height: 48.0),
          Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
              child: Text(
                "${S.of(context).click_link_sent(_email!)}",
                style: Theme.of(context).textTheme.subtitle2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Align(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
              child: UniversalPlatform.isWeb
                  ? TextButton.icon(
                      icon: Icon(Icons.chevron_left_outlined),
                      label: Text(S.of(context).all_signin_options),
                      onPressed: widget.onCancel,
                    )
                  : Row(
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
                          child: TextButton.icon(
                            icon: Icon(MdiIcons.emailOpenOutline),
                            label: Text('Open Mail'),
                            onPressed: _openEmailApp,
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildForm() {
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
                  S.of(context).reset_your_password,
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 48.0),
            WithTextFieldValidation(
              validationBloc: validationBlocs[Constants.EMAIL_FIELD],
              textController: _controllers[Constants.EMAIL_FIELD],
              autoCorrect: false,
              helperText: S.of(context).email_link_reset_password,
              hintText: S.of(context).example_com,
              autoFocus: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              focusNode: _focusNodes[Constants.EMAIL_FIELD],
              onFieldSubmitted: (value) {
                _onSubmit();
              },
              onSaved: (String? val) {
                _email = val?.trim();
              },
              labelText: S.of(context).email,
              maxWidth: context.panelMaxWidth,
            ),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(maxWidth: context.panelMaxWidth),
                child: LoginButton(
                  key: ValueKey("LoginButton"),
                  text: S.of(context).reset.toUpperCase(),
                  onPressed: isValid ? _onSubmit : null,
                  loading: _loading,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(height: 16.0),
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
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_success) {
      body = _buildSuccess();
    } else {
      body = _buildForm();
    }
    return WillPopScope(
        child: SafeArea(
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
