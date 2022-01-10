import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/index.dart';
import '../../bloc/index.dart';
import '../../services/index.dart';

enum VerifyAction { cancel, change, verify }

class LoginHelper {
  static Future<void> logout(BuildContext context, {String? returnTo}) async {
    MyAppModel appModel = context.read();
    appModel.currentUser = null;
    BlocProvider.of<AuthenticationBloc>(context)
        .add(AppLoggedOut(returnTo: returnTo));
    appModel.currentUser = null;
    appModel.profile = null;
    appModel.pendingAuthCredential = null;
    if (returnTo != null) {
      context.go('/login?returnTo=$returnTo');
    } else {
      context.go('/login');
    }
  }

  static Future<UserProfile> onLogin(
    BuildContext context,
    User user,
  ) async {
    AppConfig config = context.read();
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    UserProfile? profile = await UserService.getProfile(user.id);
    if (profile == null) {
      profile = await UserService.createProfile(config);
    }
    await LoginService.saveProfile(profile);
    authBloc.model.currentUser = user;
    authBloc.model.profile = profile;
    authBloc.model.pendingAuthCredential = null;
    authBloc.add(AuthLoggedIn(user, profile));
    return profile;
  }

  static Future<void> onSignup(
    BuildContext context,
    User user,
    UserProfile profile,
  ) async {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    LoginService.saveProfile(profile);
    authBloc.model.currentUser = user;
    authBloc.model.profile = profile;
    authBloc.model.pendingAuthCredential = null;
    authBloc.add(AuthLoggedIn(user, profile));
  }

  static Future<bool?> showVerifyEmailDialog(
      BuildContext context, String email) async {
    return showEmailUpdateDialog(
        context: context, title: S.of(context).verify_email, email: email);
  }

  static String authExceptionMessage(
      BuildContext context, AuthException authException) {
    switch (authException.code) {
      case AuthExceptionCode.AccountExistWithDifferentCredentials:
        return S.of(context).an_account_already_exists;
      case AuthExceptionCode.InvalidEmail:
        return S.of(context).email_invalid;
      case AuthExceptionCode.ExpiredActionCode:
        return S.of(context).verification_code_expired;
      case AuthExceptionCode.InvalidActionCode:
        return S.of(context).invalid_verification_code;
      case AuthExceptionCode.UserDisabled:
        return S.of(context).account_disabled;
      case AuthExceptionCode.UserNotFound:
        return S.of(context).user_not_found;
      case AuthExceptionCode.WeakPassword:
        return S.of(context).weak_password;
      case AuthExceptionCode.WrongPassword:
        return S.of(context).invalid_email_or_password;
      case AuthExceptionCode.NetworkError:
        return S.of(context).please_check_your_connection;
      case AuthExceptionCode.ClosedByUser:
        return S.of(context).closed;
      case AuthExceptionCode.TokenExpired:
        return S.of(context).auth_token_expired;
      default:
        return S.of(context).unknown_error;
    }
  }
}
