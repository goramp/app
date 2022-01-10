import 'package:flutter/material.dart';
import 'package:goramp/models/checkout.dart';

import 'stripe_checkout_stub.dart'
    if (dart.library.io) 'stripe_checkout_mobile.dart'
    if (dart.library.js) 'stripe_checkout_web.dart' as impl;

export 'stripe_add_payment_method_stub.dart'
    if (dart.library.html) 'stripe_add_payment_method_web.dart';

void redirectToCheckout(BuildContext context, Checkout checkout,
        {VoidCallback? onSuccess, VoidCallback? onCancel, String? title}) =>
    impl.redirectToCheckout(context, checkout,
        onSuccess: onSuccess, onCancel: onCancel, title: title);
