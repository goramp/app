import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/bloc/index.dart';
import 'package:intl/intl.dart';

typedef PirceBuilder = Widget Function(
    BuildContext context, num usdValue, NumberFormat format);

final cryptoFormatter = NumberFormat(
  '##,###.####',
);

class USDCryptoPriceItem extends StatefulWidget {
  final String token;
  final PirceBuilder pirceBuilder;
  USDCryptoPriceItem(this.token, this.pirceBuilder);

  @override
  State<USDCryptoPriceItem> createState() => _USDCryptoPriceItemState();
}

class _USDCryptoPriceItemState extends State<USDCryptoPriceItem> {
  Widget build(BuildContext context) {
    final curr = NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 2);
    return BlocBuilder<CryptoPriceCubit, CryptoPriceState>(
        buildWhen: (prevState, currState) {
      final prevPrice = prevState.rates[widget.token]?.quote?.price ??
          prevState.rates[widget.token]?.rate;
      final currPrice = currState.rates[widget.token]?.quote?.price ??
          currState.rates[widget.token]?.rate;
      return prevPrice != currPrice;
    }, builder: (context, state) {
      final price = state.rates[widget.token]?.quote?.price ??
          state.rates[widget.token]?.rate ??
          0;
      return widget.pirceBuilder(context, price, curr);
    });
  }
}

class TotalUSDCryptoPriceItem extends StatelessWidget {
  final PirceBuilder pirceBuilder;
  TotalUSDCryptoPriceItem(this.pirceBuilder);

  Widget build(BuildContext context) {
    final curr = NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 2);

    return BlocBuilder<WalletCubit, WalletsState>(
        builder: (context, walletState) {
      return BlocBuilder<CryptoPriceCubit, CryptoPriceState>(
          builder: (context, state) {
        final total = walletState.tokenAccounts?.map((tokenAccount) {
              try {
                final coin = tokenAccount.token!.tokenSymbol!.toUpperCase();
                final rate =
                    state.rates[coin]?.quote?.price ?? state.rates[coin]?.rate;
                double price = rate ?? 0;
                final balance = tokenAccount.amount! /
                    BigInt.from(math.pow(10, tokenAccount.decimals!));
                return balance * price;
              } catch (error, stack) {
                print(stack);
                return 0;
              }
            }).fold(0, (dynamic memo, element) => memo + element) ??
            0;
        return pirceBuilder(context, total, curr);
      });
    });
  }
}
