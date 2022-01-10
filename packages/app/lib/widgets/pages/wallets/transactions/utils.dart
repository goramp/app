import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/models/payment_provider.dart';
import 'package:goramp/widgets/pages/wallets/crypto/price_builder.dart';
import 'package:intl/intl.dart';

String formatDate(BuildContext context, DateTime dateTime) {
  TimeOfDay start = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  return '${DateFormat('MMM d, yyyy').format(dateTime)} @ ${start.format(context)}';
}

String typeString(PaymentTransaction transaction) {
  String paymentS;
  if (transaction.transactionType == PaymentTransactionType.payment) {
    paymentS = 'payment';
  } else if (transaction.transactionType == PaymentTransactionType.payout) {
    paymentS = 'payout';
  } else {
    paymentS = 'refund';
  }
  return paymentS;
}

String amountString(PaymentTransaction transaction) {
  String balance;
  if (transaction.providerId == SOLANA_PAYMENT_PROVIDER) {
    final amountS = (BigInt.tryParse(transaction.amount!) ?? BigInt.zero) /
        BigInt.from(math.pow(10, transaction.decimals ?? 2));
    balance = "${cryptoFormatter.format(amountS)} ${transaction.currency}";
  } else {
    final formatter = NumberFormat.simpleCurrency(
        name: transaction.currency, decimalDigits: 2);
    balance = "${formatter.format(transaction.amount)}";
  }
  return balance;
}

String toFormattedAmount(String amount, int decimals, String currency) {
  String balance;
  final amountS = (BigInt.tryParse(amount) ?? BigInt.zero) /
      BigInt.from(math.pow(10, decimals));
  balance = "${cryptoFormatter.format(amountS)} ${currency}";
  return balance;
}

String feeString(PaymentTransaction transaction) {
  String balance;
  if (transaction.providerId == SOLANA_PAYMENT_PROVIDER) {
    final amountS = (BigInt.tryParse(transaction.fee!) ?? BigInt.zero) /
        BigInt.from(math.pow(10, transaction.decimals ?? 2));
    balance = "${cryptoFormatter.format(amountS)} ${transaction.currency}";
  } else {
    final formatter = NumberFormat.simpleCurrency(
        name: transaction.currency, decimalDigits: 2);
    balance = "${formatter.format(transaction.fee)}";
  }
  return balance;
}

Color? colorForTransaction(
    BuildContext context, PaymentTransactionType? transactionType) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  Color? color = Colors.black87;
  if (transactionType == PaymentTransactionType.payment) {
    color = isDark ? Colors.red[200]! : Colors.red[400]!;
  } else {
    color = isDark ? Colors.green[200]! : Colors.green[400]!;
  }
  return color;
}
