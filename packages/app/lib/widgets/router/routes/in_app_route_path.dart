import 'package:goramp/models/index.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/route_constants.dart';
import 'package:goramp/widgets/router/paths/index.dart';
import 'package:goramp/widgets/router/routes/app_route_path.dart';

abstract class InAppRoutePath extends AppRoutePath {}

class CallDialogPath extends InAppRoutePath {
  final String id;
  CallDialogPath(this.id);
  String get location => "$CallRoute/$id";
  String get name => "Call";
}

class WalletDetailRoutePath extends InAppRoutePath {
  final WalletDetailPath? path;
  final Contribution? contribution;
  final String tokenName;
  final TokenAccount? tokenAccount;
  final Token? swapFrom;
  final Token? swapTo;

  WalletDetailRoutePath(
    this.tokenName, {
    this.path,
    this.swapFrom,
    this.swapTo,
    this.tokenAccount,
    this.contribution,
  });

  String get name => "Wallet Detail";

  String get location {
    final base = "$WalletRoute/$tokenName";
    switch (path) {
      case WalletDetailPath.deposit:
        return "$base/deposit";
      case WalletDetailPath.send:
        return "$base/send";
      case WalletDetailPath.contribute:
        return "$base/contribute";
      case WalletDetailPath.swap:
        return "$base/swap";
      default:
        return base;
    }
  }

  WalletDetailRoutePath copyWith({
    WalletDetailPath? path,
    String? tokenName,
  }) {
    return WalletDetailRoutePath(
      tokenName ?? this.tokenName,
      path: path ?? this.path,
    );
  }
}
