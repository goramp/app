export 'crypto_wallet.dart';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/pages/wallets/crypto/deposit.dart';
import 'package:goramp/widgets/pages/wallets/crypto/detail.dart';
import 'package:goramp/widgets/pages/wallets/crypto/send.dart';
import 'package:goramp/widgets/pages/wallets/crypto/swap.dart';
import 'package:provider/provider.dart';

class WalletPages extends StatelessWidget {
  WalletPages(
      {required this.token,
      required this.page,
      this.tokenAccount,
      this.swapFrom,
      this.swapTo});
  final String token;
  final TokenAccount? tokenAccount;
  final String page;
  final String? swapFrom;
  final String? swapTo;
  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (page) {
      case 'deposit':
        {
          body = DepositPage(
            token,
            tokenAccount: tokenAccount,
          );
          break;
        }
      case 'send':
        {
          body = SendFundsPage(
            token,
            tokenAccount: tokenAccount,
          );
          break;
        }
      case 'swap':
        {
          AppConfig config = Provider.of(context, listen: false);
          final tokens = KURO_TOKENS[config.solanaCluster] ?? [];
          final from = tokens.firstWhereOrNull((element) =>
              element.tokenSymbol?.toUpperCase() ==
              (swapFrom?.toUpperCase() ?? token.toUpperCase()));
          final to = tokens.firstWhereOrNull((element) =>
              element.tokenSymbol?.toUpperCase() == swapTo?.toUpperCase());
          body = SwapPage(
            fromMint: from,
            toMint: to,
            onClose: () => Navigator.of(context).pop(),
          );
          break;
        }
      default:
        body = TokenDetailPage(
          token,
          tokenAccount: tokenAccount,
        );
    }
    return body;
  }
}
