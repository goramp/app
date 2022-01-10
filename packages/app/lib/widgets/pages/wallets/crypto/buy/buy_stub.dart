import 'package:flutter/material.dart';
import 'package:goramp/widgets/pages/wallets/crypto/buy/interface.dart' as inter;

void buyWithTransack(BuildContext _, inter.TransackOptions options,
        {VoidCallback? onSuccess, VoidCallback? onCancel}) =>
    throw UnsupportedError('Its neither mobile nor web');

void buyWithFTXPay(BuildContext context, inter.FTXOptions options,
        {VoidCallback? onSuccess, VoidCallback? onCancel}) =>
    throw UnsupportedError('Its neither mobile nor web');

void buyWithRamp(BuildContext _, inter.RampOptions options,
        {VoidCallback? onSuccess, VoidCallback? onCancel}) =>
    throw UnsupportedError('Its neither mobile nor web');
