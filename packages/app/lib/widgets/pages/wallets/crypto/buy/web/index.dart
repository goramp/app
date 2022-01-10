@JS()
library transack;

import 'package:js/js.dart';

typedef _Handler = void Function(dynamic event);

const TRANSAK_ALL_EVENTS = '*';
const TRANSAK_WIDGET_INITIALISED = 'TRANSAK_WIDGET_INITIALISED';
const TRANSAK_WIDGET_OPEN = 'TRANSAK_WIDGET_OPEN';
const TRANSAK_WIDGET_CLOSE_REQUEST = 'TRANSAK_WIDGET_CLOSE_REQUEST';
const TRANSAK_WIDGET_CLOSE = 'TRANSAK_WIDGET_CLOSE';
const TRANSAK_ORDER_CREATED = 'TRANSAK_ORDER_CREATED';
const TRANSAK_ORDER_CANCELLED = 'TRANSAK_ORDER_CANCELLED';
const TRANSAK_ORDER_FAILED = 'TRANSAK_ORDER_FAILED';
const TRANSAK_ORDER_SUCCESSFUL = 'TRANSAK_ORDER_SUCCESSFUL';

const RAMP_WIDGET_CLOSE = 'WIDGET_CLOSE';
const RAMP_WIDGET_CONFIG_DONE = 'WIDGET_CONFIG_DONE';
const RAMP_WIDGET_CONFIG_FAILED = 'WIDGET_CONFIG_FAILED';
const RAMP_PURCHASE_SUCCESSFUL = 'PURCHASE_SUCCESSFUL';

@JS()
@anonymous
class TransackOptions {
  external String get environment;
  external String get cryptoCurrencyCode;
  external String get walletAddress;
  external String get redirectURL;
  external String get email;
  external String get themeColor;
  external String get apiKey;
  external String get hostURL;
  external String get widgetWidth;
  external String get widgetHeight;
  external String get network;
  external String get defaultCryptoAmount;
  external String get defaultCryptoCurrency;
  external String get fiatCurrency;
  external String get fiatAmount;
  external bool get disableWalletAddressForm;
  external bool get hideExchangeScreen;
  external bool get hideMenu;
  external String get partnerCustomerId;
  external String get partnerOrderId;

  external factory TransackOptions({
    String? environment,
    String? cryptoCurrencyCode,
    String? walletAddress,
    String? redirectURL,
    String? email,
    String? themeColor,
    String? apiKey,
    String? hostURL,
    String? widgetHeight,
    String? widgetWidth,
    String? network,
    String? defaultCryptoAmount,
    String? defaultCryptoCurrency,
    String? fiatCurrency,
    String? fiatAmount,
    bool? disableWalletAddressForm,
    bool? hideExchangeScreen,
    bool? hideMenu,
    String? partnerCustomerId,
    String? partnerOrderId,
  });
}

@JS('TransakSDK.default')
class TransackSdk {
  external TransackSdk(TransackOptions options);
  external init();
  external on(String eventName, _Handler handler);
}

@JS()
@anonymous
class RampSDKOptions {
  external String get swapAsset;
  external String get userAddress;
  external String get swapAmount;
  external String get userEmailAddress;
  external String get hostApiKey;
  external String get hostLogoUrl;
  external String get hostAppName;
  external String get finalUrl;
  external String get variant;
  external String get defaultAsset;

  external factory RampSDKOptions(
      {String? swapAsset,
      String? userAddress,
      String? swapAmount,
      String? userEmailAddress,
      String? hostApiKey,
      String? hostLogoUrl,
      String? hostAppName,
      String? variant,
      String? finalUrl,
      String? defaultAsset});
}

@JS('rampInstantSdk.RampInstantSDK')
class RampSdk {
  external RampSdk(RampSDKOptions options);
  external on(String eventName, _Handler handler);
  external show();
}
