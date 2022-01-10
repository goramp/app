import 'package:flutter/material.dart';
import 'package:goramp/widgets/layout/index.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:goramp/generated/l10n.dart';
import '../../custom/index.dart';
import '../../../bloc/index.dart';
import '../../../events/index.dart';
import '../../../models/index.dart';
import '../../../utils/index.dart';
import '../../helpers/index.dart';
import '../../../services/index.dart';
import '../../../app_config.dart';

class Login extends StatefulWidget {
  final AppConfig config;
  Login(this.config);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, StreamSubscription<ValidationState>> validationSubscriptions = {};
  Map<String, ValidationState> validationStates = {};
  Map<String, ValidationBloc> validationBlocs = {};
  Map<String, FocusNode> _focusNodes = {};
  Map<String, TextEditingController> _controllers = {};
  bool _connected = false;

  initState() {
    super.initState();
    _controllers[Constants.USERNAME_FIELD] = TextEditingController();
    _focusNodes[Constants.USERNAME_FIELD] = FocusNode();
    _controllers[Constants.USERNAME_FIELD]!.addListener(() {
      validationBlocs[Constants.USERNAME_FIELD]!
          .onTextChanged
          .add(_controllers[Constants.USERNAME_FIELD]!.text);
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
    validationBlocs[Constants.USERNAME_FIELD] = ValidationBloc<String>(
        AnyValidator(Constants.USERNAME_FIELD, context: context));
    validationSubscriptions[Constants.USERNAME_FIELD] =
        validationBlocs[Constants.USERNAME_FIELD]!
            .state
            .listen((ValidationState state) {
      _handleFieldValidation(Constants.USERNAME_FIELD, state);
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

  _runValidation() {
    [Constants.USERNAME_FIELD, Constants.PASSWORD_FIELD]
        .forEach((String field) {
      validationBlocs[field]!.onTextChanged.add(_controllers[field]!.text);
    });
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
    if (state is ValidationError) {
      _handleError(state.error, state.stackTrace);
      return;
    }
    setState(() {
      validationStates[fieldName] = state;
    });
  }

  _handleError(Object error, StackTrace? stacktrace) {
    if (error is SocketException) {
      final connectionBloc =
          Provider.of<ConnectionBloc>(context, listen: false);
      connectionBloc.connectionSink
          .add(ConnectionEvent(status: ConnectionStatus.offline));
      AlertHelper.showErrorLight(context,
          description: CONNECTION_ERROR_MESSAGE);
    } else {
      AlertHelper.showErrorLight(context,
          description: S.of(context).default_error_title2);
      ErrorHandler.report(error, stacktrace);
    }
  }

  StreamSubscription<ConnectionEvent>? _connectionStream;

  @override
  didChangeDependencies() {
    _connectionStream?.cancel();
    final connectionBloc = Provider.of<ConnectionBloc>(context, listen: false);
    _connectionStream =
        connectionBloc.connection.listen(_handleConnectionError);
    super.didChangeDependencies();
  }

  void _handleConnectionError(ConnectionEvent connectionEvent) {
    bool wasConnected = _connected;
    if (connectionEvent.status == ConnectionStatus.online) {
      _connected = true;
    } else if (connectionEvent.status == ConnectionStatus.offline) {
      _connected = false;
    }
    if (mounted) {
      setState(() {
        if (wasConnected != _connected) {
          if (_connected) {
            _runValidation();
          } else {
            AlertHelper.showErrorLight(context,
                description: CONNECTION_ERROR_MESSAGE);
          }
        }
      });
    }
  }

  dispose() {
    super.dispose();
    _connectionStream?.cancel();
    validationBlocs.forEach((String _, ValidationBloc bloc) => bloc.dispose());
    validationSubscriptions
        .forEach((String _, StreamSubscription sub) => sub.cancel());
    _controllers.forEach(
        (String _, TextEditingController controller) => controller.dispose());
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<void> login() async {
    if (_loading) {
      return;
    }
    AppConfig config = Provider.of<AppConfig>(context, listen: false);
    LoginService loginService = LoginService(
      config: config,
    );
    try {
      // setState(() {
      //   _loading = true;
      // });
      // User user = await loginService.login(_username, _password);
      // BlocProvider.of<AuthenticationBloc>(context).add(AuthLoggedIn(user));
      // NavigationService navigationService =
      //     Provider.of<NavigationService>(context, listen: false);
      // navigationService.goToHome();
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
      print('stacktrace ${stacktrace}');
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
    if (isValid) {
      _formKey.currentState!.save();
      await login();
    }
  }

  Future<void> _handleBack() async {
    return Navigator.of(context).pop();
  }

  Widget _buildLoginView() {
    final desktopMaxWidth = 400.0 + 100.0 * (cappedTextScale(context) - 1);
    return ListView(
      padding: EdgeInsets.only(left: 16.0, right: 16),
      shrinkWrap: true,
      children: <Widget>[
        WithTextFieldValidation(
          validationEnabled: false,
          validationBloc: validationBlocs[Constants.USERNAME_FIELD],
          textController: _controllers[Constants.USERNAME_FIELD],
          autoCorrect: false,
          // textCapitalization: TextCapitalization.words,
          autoFocus: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          focusNode: _focusNodes[Constants.USERNAME_FIELD],
          onFieldSubmitted: (value) {
            _fieldFocusChange(context, _focusNodes[Constants.USERNAME_FIELD]!,
                _focusNodes[Constants.PASSWORD_FIELD]);
          },
          labelText: S.of(context).username_or_email,
          maxWidth: desktopMaxWidth,
        ),
        const SizedBox(height: 16.0),
        Center(child: _buildPasswordView()),
        SizedBox(height: 16.0),
        Align(
          alignment: Alignment.center,
          child: Container(
            constraints: BoxConstraints(maxWidth: desktopMaxWidth),
            child: LoginButton(
              text: S.of(context).sign_in.toUpperCase(),
              onPressed: isValid ? _onSubmit : null,
              loading: _loading,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Center(
          child: FlatButton(
            //elevation: 0.0,
            color: Colors.transparent,
            onPressed: _goToForgot,
            child: Text(
              S.of(context).forgot_password,
              style: Theme.of(context).textTheme.button!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w600),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(24.0),
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              //GalleryLocalizations.of(context).rallyLoginNoAccount,
              S.of(context).dont_have_an_account,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 1.0),
            FlatButton(
              //elevation: 0.0,
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              color: Colors.transparent,
              onPressed: _goToSignUp,
              child: Text(
                S.of(context).sign_up_now,
                style: Theme.of(context).textTheme.button!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w600),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(24.0),
                ),
              ),
            )

            // Text(
            //   "Sign Up",
            //   style: Theme.of(context)
            //       .textTheme
            //       .caption
            //       .copyWith(decoration: TextDecoration.underline),
            // ).clickable(_goToSignUp)
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordView() {
    final desktopMaxWidth = 400.0 + 100.0 * (cappedTextScale(context) - 1);
    return WithTextFieldValidation(
      validationEnabled: false,
      validationBloc: validationBlocs[Constants.PASSWORD_FIELD],
      textController: _controllers[Constants.PASSWORD_FIELD],
      autoCorrect: false,
      // textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      focusNode: _focusNodes[Constants.PASSWORD_FIELD],
      obscureText: true,
      onFieldSubmitted: (value) {
        _onSubmit();
      },
      labelText: S.of(context).password,
      maxWidth: desktopMaxWidth,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Form(
            key: _formKey,
            child: Center(
              child: _buildLoginView(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _goToSignUp() async {
    // NavigationService navigation =
    //     Provider.of<NavigationService>(context, listen: false);
    // return navigation.goToSignUp();
  }

  Future<void> _goToForgot() async {
    // NavigationService navigation =
    //     Provider.of<NavigationService>(context, listen: false);
    // return navigation.navigateTo(ChangePasswordRoute);
  }

  Widget _buildMaterial(BuildContext context) {
    const spacing = SizedBox(
      width: 16.0,
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: SignInAppBar(
          // actions: [
          //   if (UniversalPlatform.isWeb)
          //     Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(
          //           //GalleryLocalizations.of(context).rallyLoginNoAccount,
          //           "Dont't have an account?",
          //           style: Theme.of(context).textTheme.caption,
          //         ),
          //         spacing,
          //         Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: LoginSignUpBorderButton(
          //             text: "Sign Up",
          //             onPress: _goToSignUp,
          //           ),
          //         )
          //       ],
          //     ),
          // ],
          ),
      body: _buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMaterial(context);
  }
}
