import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/bloc/fiat_rate_cubit.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/widgets/index.dart';

typedef CurrencyPriceBuilder = Widget Function(
    BuildContext context, String value);

class CurrencyPriceItem extends StatefulWidget {
  final String amount;
  final String currency;
  final int decimals;
  final CurrencyPriceBuilder priceBuilder;
  CurrencyPriceItem(
      this.amount, this.currency, this.decimals, this.priceBuilder);

  @override
  State<CurrencyPriceItem> createState() => _CurrencyPriceItemState();
}

class _CurrencyPriceItemState extends State<CurrencyPriceItem> {
  Widget build(BuildContext context) {
    final isCrypto =
        CurrencyHelper.isValidCryptoCurrency(context, widget.currency);
    var destination = context.select<MyAppModel, String?>((value) {
      final coutryCode = value.userKYC?.country ?? value.session?.lastCountry;
      if (coutryCode == null) return null;
      return value.countries[coutryCode.toUpperCase()]?.currencyCode;
    });
    if (destination == null) {
      return widget.priceBuilder(
        context,
        CurrencyHelper.convertToFiat(context, widget.amount, widget.currency,
            widget.decimals, destination),
      );
    }
    return isCrypto
        ? BlocBuilder<CryptoPriceCubit, CryptoPriceState>(
            buildWhen: (prevState, currState) {
            final prevPrice = prevState.rates[widget.currency]?.quote?.price ??
                prevState.rates[widget.currency]?.rate;
            final currPrice = currState.rates[widget.currency]?.quote?.price ??
                currState.rates[widget.currency]?.rate;
            return prevPrice != currPrice;
          }, builder: (context, state) {
            return widget.priceBuilder(
              context,
              CurrencyHelper.convertToFiat(context, widget.amount,
                  widget.currency, widget.decimals, destination),
            );
          })
        : BlocBuilder<FiatRatesCubit, FiatRatesState>(
            buildWhen: (prevState, currState) {
              final prevPrice = prevState.rates[widget.currency];
              final currPrice = currState.rates[widget.currency];
              return prevPrice != currPrice;
            },
            builder: (context, state) {
              return widget.priceBuilder(
                context,
                CurrencyHelper.convertToFiat(context, widget.amount,
                    widget.currency, widget.decimals, destination),
              );
            },
          );
  }
}
