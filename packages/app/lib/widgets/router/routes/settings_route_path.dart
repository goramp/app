import 'package:goramp/models/token.dart';
import 'package:goramp/widgets/router/paths/index.dart';
import 'package:goramp/widgets/router/routes/in_app_route_path.dart';

const _kBaseRoute = '/settings';

class SettingsRoutePath extends InAppRoutePath {
  String get location {
    switch (path) {
      case SettingsPath.none:
        return "$_kBaseRoute";
      case SettingsPath.wallet:
        return "$_kBaseRoute/wallet";
      case SettingsPath.payout:
        return "$_kBaseRoute/payout";
      case SettingsPath.notifications:
        return "$_kBaseRoute/notifications";
      case SettingsPath.profile:
        return "$_kBaseRoute/profile";
    }
    return "$_kBaseRoute";
  }

  SettingsRoutePath({this.path = SettingsPath.none});
  String get name => "Settings";
  final SettingsPath path;
}

class AddCardRoutePath extends InAppRoutePath {
  AddCardRoutePath();
  String get location => "$_kBaseRoute/payments/add_card";
  String get name => "Add Card";
}

class EditProfileSettingsRoutePath extends InAppRoutePath {
  EditProfileSettingsRoutePath();
  String get location => "$_kBaseRoute/profile/edit";
  String get name => "Edit Profile";
}

class DepositWalletRoutePath extends InAppRoutePath {
  final TokenAccount tokenAccount;
  DepositWalletRoutePath(this.tokenAccount);
  String get location => "$_kBaseRoute/wallet/deposit/${tokenAccount.address}";
  String get name => "Deposit";
}
