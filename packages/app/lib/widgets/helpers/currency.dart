import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/fiat_rate_cubit.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CurrencyHelper {
  static NumberFormat format(BuildContext context, String? currency,
      {bool useSymbol = false}) {
    bool isCrypto = isValidCryptoCurrency(context, currency);
    return isCrypto
        ? kCryptoFormatter
        : useSymbol
            ? NumberFormat.simpleCurrency(
                name: currency,
              )
            : NumberFormat.currency(name: currency, symbol: '');
  }

  static bool isValidCryptoCurrency(BuildContext context, String? currency) {
    if (currency == null) return false;
    AppConfig config = context.read();
    final tokens = KURO_TOKENS[config.solanaCluster];
    return tokens!
        .where((token) => !token.deprecated)
        .map((e) => e.tokenSymbol)
        .contains(currency.toUpperCase());
  }

  static String formatCurrency(
      BuildContext context, String amount, String currency,
      {int? decimals = 2}) {
    bool isCrypto = isValidCryptoCurrency(context, currency);
    final NumberFormat formatter = isCrypto
        ? kCryptoFormatter
        : currency == 'USD'
            ? NumberFormat.simpleCurrency(
                name: currency,
              )
            : NumberFormat.currency(
                name: currency,
              );
    num total = (BigInt.tryParse(amount) ?? BigInt.zero) /
        BigInt.from(math.pow(10, decimals ?? 2));
    final text = isCrypto
        ? '${formatter.format(total)} $currency'
        : formatter.format(total);
    return text;
  }

  static String convertToFiat(
    BuildContext context,
    String amount,
    String currency,
    int decimals,
    String? destination,
  ) {
    if (destination == null || currency == destination) {
      return formatCurrency(context, amount, currency, decimals: decimals);
    }
    bool isCrypto = isValidCryptoCurrency(context, currency);
    double source = (BigInt.tryParse(amount) ?? BigInt.zero) /
        BigInt.from(math.pow(10, decimals));
    var usdAmount;
    if (isCrypto) {
      CryptoPriceCubit cryptoPriceCubit = Provider.of(context, listen: false);
      if (cryptoPriceCubit.state.rates[currency] != null) {
        final rate = cryptoPriceCubit.state.rates[currency]?.quote?.price ??
            cryptoPriceCubit.state.rates[currency]?.rate;
        if (rate != null) {
          usdAmount = rate * source;
        }
      }
    } else {
      FiatRatesCubit fiateRateCubit = Provider.of(context, listen: false);
      if (fiateRateCubit.state.rates[currency] != null) {
        final rate = fiateRateCubit.state.rates[currency];
        if (rate != null) {
          usdAmount = rate * source;
        }
      }
    }
    if (usdAmount == null) {
      return formatCurrency(context, amount, currency, decimals: decimals);
    }
    var amountInDst;
    FiatRatesCubit fiateRateCubit = Provider.of(context, listen: false);
    if (fiateRateCubit.state.rates[destination] != null) {
      final rate = fiateRateCubit.state.rates[destination];
      if (rate != null) {
        amountInDst = usdAmount * rate;
      }
    }
    if (amountInDst == null) {
      return formatCurrency(context, amount, currency, decimals: decimals);
    }
    if (destination == 'USD') {
      return NumberFormat.simpleCurrency(
                name: destination,
              ).format(amountInDst);
    }
    final formatter = NumberFormat.currency(name: destination, symbol: '');
    return '$destination ${formatter.format(amountInDst)}';
  }
}
