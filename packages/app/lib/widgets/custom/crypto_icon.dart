import 'package:flutter/material.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/index.dart';

class CryptoCurrencyIcon extends StatelessWidget {
  final CryptoCurrency currency;
  final double width;
  CryptoCurrencyIcon(this.currency, {this.width = 32.0});
  Widget build(BuildContext context) {
    String img = "";
    switch (currency) {
      case CryptoCurrency.kuro:
        img = COINS.KURO;
        break;
      case CryptoCurrency.usdc:
        img = COINS.USDC;
        break;
      case CryptoCurrency.sol:
        img = COINS.SOL;
        break;
    }
    if (img.isNotEmpty) {
      return PlatformSvg.asset(img, width: width, height: width);
    } else {
      return const SizedBox.shrink();
    }
  }
}
