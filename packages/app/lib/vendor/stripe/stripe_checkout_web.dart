library stripe;

import 'package:flutter/material.dart';
import 'package:goramp/models/checkout.dart';
import 'web/stripe.dart';

void redirectToCheckout(BuildContext _, Checkout checkout,
    {VoidCallback? onSuccess, VoidCallback? onCancel, String? title}) async {
  final stripe = Stripe(
      checkout.apiKey,
      checkout.stripeAccountId != null
          ? StripeOptions(stripeAccount: checkout.stripeAccountId)
          : null);
  stripe.redirectToCheckout(
    CheckoutOptions(
      sessionId: checkout.id,
    ),
  );
}
