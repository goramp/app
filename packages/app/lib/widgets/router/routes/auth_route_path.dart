import 'package:firebase_auth/firebase_auth.dart';
import 'package:goramp/route_constants.dart';
import 'package:goramp/widgets/router/paths/auth_path.dart';
import 'package:goramp/widgets/router/routes/app_route_path.dart';

abstract class AuthRoutePath extends AppRoutePath {
  String get location;

  AuthRoutePath({this.path = AuthPath.login})
      : assert(path != null),
        super(secureRoot: false);
  final AuthPath path;

  AuthRoutePath.login() : path = AuthPath.login;
  AuthRoutePath.register() : path = AuthPath.register;
  AuthRoutePath.emailCallBack() : path = AuthPath.emailCallback;

  bool get isLogin => path == AuthPath.login;
  bool get isRegister => path == AuthPath.register;
  bool get isEmailCallback => path == AuthPath.emailCallback;
}

class LoginRoutePath extends AuthRoutePath {
  final AppRoutePath? returnTo;
  final String? preferredProvider;
  final AuthCredential? pendingCredential;
  final String? email;
  String get name => "Sign In";

  LoginRoutePath(
      {this.returnTo,
      this.preferredProvider,
      this.pendingCredential,
      this.email})
      : super(path: AuthPath.login);

  @override
  String get location {
    String path = "$LoginRoute";
    if (returnTo != null) {
      path = "$path?returnTo=${returnTo!.location}";
    }
    return path;
  }
}

class RegisterRoutePath extends AuthRoutePath {
  final AppRoutePath? returnPath;
  RegisterRoutePath({this.returnPath});
  String get location => "$SignUpRoute";
  String get name => "Regsister";
}

class EmailCallbackPath extends AuthRoutePath {
  final String? mode;
  final String? code;
  final String? apiKey;
  final String? lang;
  final String? continueUrl;
  String get name => "Sign In";

  EmailCallbackPath(
      {this.mode = "",
      this.code = "",
      this.apiKey = "",
      this.lang = "",
      this.continueUrl = ""})
      : super(path: AuthPath.emailCallback);

  @override
  String get location =>
      '/callbacks/email?mode=${mode ?? ''}&oobCode=$code&apiKey=$apiKey&continueUrl=$continueUrl&lang=$lang';
}
