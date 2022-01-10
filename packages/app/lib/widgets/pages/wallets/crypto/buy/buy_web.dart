library stripe;

import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:goramp/widgets/pages/wallets/crypto/buy/interface.dart' as inter;
import 'package:goramp/widgets/pages/wallets/crypto/buy/web/index.dart';
import 'package:js/js.dart';

void buyWithRamp(BuildContext _, inter.RampOptions options,
    {VoidCallback? onSuccess, VoidCallback? onCancel}) async {
  final ramp = RampSdk(
    RampSDKOptions(
      swapAsset: options.swapAsset,
      userAddress: options.userAddress,
      swapAmount: options.swapAmount,
      userEmailAddress: options.userEmailAddress,
      hostApiKey: options.hostApiKey,
      hostLogoUrl: options.hostLogoUrl,
      hostAppName: options.hostAppName,
      finalUrl: options.finalUrl,
      variant: options.variant,
      defaultAsset: options.defaultAsset,
    ),
  );
  ramp.show();
  ramp.on(
    RAMP_PURCHASE_SUCCESSFUL,
    allowInterop(
      (_) => onSuccess!(),
    ),
  );
  ramp.on(
    RAMP_WIDGET_CLOSE,
    allowInterop(
      (_) => onCancel!(),
    ),
  );
}

void buyWithTransack(BuildContext _, inter.TransackOptions options,
    {VoidCallback? onSuccess, VoidCallback? onCancel}) async {
  final transack = TransackSdk(
    TransackOptions(
        apiKey: options.apiKey,
        environment: options.environment,
        cryptoCurrencyCode: options.cryptoCurrencyCode,
        email: options.email,
        redirectURL: options.redirectURL,
        themeColor: options.themeColor,
        walletAddress: options.walletAddress,
        hostURL: html.window.location.origin,
        network: options.network,
        defaultCryptoAmount: options.defaultCryptoAmount,
        defaultCryptoCurrency: options.defaultCryptoCurrency,
        fiatCurrency: options.fiatCurrency,
        fiatAmount: options.fiatAmount,
        disableWalletAddressForm: options.disableWalletAddressForm,
        hideExchangeScreen: options.hideExchangeScreen,
        hideMenu: options.hideMenu,
        partnerCustomerId: options.partnerCustomerId,
        partnerOrderId: options.partnerOrderId,
        widgetHeight: '650px',
        widgetWidth: '100%'),
  );
  transack.init();
  transack.on(
    TRANSAK_ORDER_SUCCESSFUL,
    allowInterop(
      (_) => onSuccess!(),
    ),
  );
  transack.on(
    TRANSAK_ORDER_CANCELLED,
    allowInterop(
      (_) => onCancel!(),
    ),
  );
}

void buyWithFTXPay(BuildContext _, inter.FTXOptions options,
    {VoidCallback? onSuccess, VoidCallback? onCancel}) async {
  html.window.open(options.url, '_blank', 'resizable,width=450,height=780');
}
