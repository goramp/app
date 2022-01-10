import 'package:flutter/material.dart';
import 'package:goramp/widgets/pages/wallets/crypto/buy/interface.dart';

import 'buy_stub.dart'
    if (dart.library.io) 'buy_mobile.dart'
    if (dart.library.js) 'buy_web.dart' as impl;

void buyWithRamp(BuildContext context, RampOptions options,
        {VoidCallback? onSuccess, VoidCallback? onCancel}) =>
    impl.buyWithRamp(context, options,
        onSuccess: onSuccess, onCancel: onCancel);

void buyWithTransack(BuildContext context, TransackOptions options,
        {VoidCallback? onSuccess, VoidCallback? onCancel}) =>
    impl.buyWithTransack(context, options,
        onSuccess: onSuccess, onCancel: onCancel);

void buyWithFTXPay(BuildContext context, FTXOptions options,
        {VoidCallback? onSuccess, VoidCallback? onCancel}) =>
    impl.buyWithFTXPay(context, options,
        onSuccess: onSuccess, onCancel: onCancel);
