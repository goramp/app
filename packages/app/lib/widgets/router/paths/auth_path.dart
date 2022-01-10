enum AuthPath { login, register, emailCallback }

extension AuthPathExtension on AuthPath {
  int? getView() {
    switch (this) {
      case AuthPath.login:
        return 0;
      case AuthPath.emailCallback:
        return 1;
      case AuthPath.register:
        return 2;
      default:
        return null;
    }
  }
}
