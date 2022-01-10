@JS()
library stripe;

import 'package:js/js.dart';

import 'package:js/js_util.dart';

typedef StripeEventHandler = void Function(StripeEvent event);

// @JS('appendPseudoStyle')
// external CSSStyle appendPseudoStyle(CSSStyle style, String psuedoClass, CSSStyle pesudoStyle);

void appendPseudo(CSSStyle base, String className, CSSStyle style) {
  setProperty(base, className, style);
}

@JS()
@anonymous
class CssFontSource {
  external String get cssSrc;
  external factory CssFontSource({String? cssSrc});
}

@JS()
@anonymous
class CustomFontSource {
  external String get family;
  external String get src;
  external String get weight;
  external factory CustomFontSource(
      {String? family, String? src, String? weight});
}

@JS()
@anonymous
class StripeOptions {
  external String get stripeAccount;
  external factory StripeOptions({String? stripeAccount});
}

@JS()
@anonymous
class StripeError {
  external String get message;
  external String get code;
  external String get type;

  external factory StripeError({
    String? message,
    String? code,
    String? type,
  });
}

@JS()
@anonymous
class StripeEvent {
  external String get elementType;
  external bool get empty;
  external bool get complete;
  external String get brand;
  external dynamic get value;
  external StripeError get error;

  external factory StripeEvent({
    String? elementType,
    bool? empty,
    bool? complete,
    bool? brand,
    StripeError? error,
    dynamic value,
  });
}

@JS()
@anonymous
class Classes {
  external String get base;
  external bool get complete;
  external bool get empty;
  external String get focus;
  external String get invalid;
  external String get webkitAutofill;

  external factory Classes({
    String? base,
    bool? complete,
    bool? empty,
    String? focus,
    String? invalid,
    String? webkitAutofill,
  });
}

@JS()
@anonymous
class CSSStyle {
  external String get backgroundColor;
  external String get iconColor;
  external String get color;
  external String get fontWeight;
  external String get fontFamily;
  external String get fontSize;
  external String get letterSpacing;
  external String get lineHeight;
  external String get textAlign;
  external String get textTransform;
  external String get textDecoration;
  external String get textShadow;
  external String get padding;

  external factory CSSStyle({
    String? backgroundColor,
    String? iconColor,
    String? color,
    String? fontWeight,
    String? fontFamily,
    String? fontSize,
    String? letterSpacing,
    String? lineHeight,
    String? textAlign,
    String? textTransform,
    String? textDecoration,
    String? textShadow,
    String? padding,
  });
}

@JS()
@anonymous
class Style {
  external CSSStyle get base;
  external CSSStyle get invalid;
  external CSSStyle get complete;
  external CSSStyle get empty;
  external CSSStyle get focus;
  external CSSStyle get webkitAutofill;
  external CSSStyle get placeHolder;
  external factory Style(
      {CSSStyle? base,
      CSSStyle? invalid,
      CSSStyle? complete,
      CSSStyle? empty,
      CSSStyle? focus,
      CSSStyle? webkitAutofill,
      CSSStyle? placeHolder});
}

@JS()
@anonymous
class PostalCodeInput {
  external String get postalCode;

  external factory PostalCodeInput({
    String? postalCode,
  });
}

@JS()
@anonymous
class UpdateOptions {
  external Classes get classes;
  external Style get style;
  external dynamic get value;
  external bool get hidePostalCode;
  external bool get disabled;
  external bool get hideIcon;
  external String get iconStyle;

  external factory UpdateOptions({
    Classes? classes,
    Style? style,
    dynamic value,
    bool? hidePostalCode,
    bool? hideIcon,
    bool? disabled,
    bool? iconStyle,
  });
}

@JS()
class StripeElement {
  external mount(dynamic container);
  external unmount();
  external clear();
  external blur();
  external focus();
  external destroy();
  external on(String eventName, StripeEventHandler handler);
  external update(UpdateOptions options);
}

@JS()
class Elements {
  external StripeElement create(String elementName, UpdateOptions? options);
}

@JS()
@anonymous
class ElementsOptions {
  external List<dynamic> get fonts;

  external String get locale;

  external factory ElementsOptions({
    List<dynamic>? fonts,
    String? locale,
  });
}

@JS()
class Stripe {
  external Stripe(String? key, StripeOptions? options);
  external redirectToCheckout(CheckoutOptions options);
  external Elements elements(ElementsOptions? options);
  external Future<ConfirmCardSetUpResult> confirmCardSetup(
    String? secret,
    CardSetupData data,
    CardSetupOptions options,
  );
}

@JS()
@anonymous
class BillingDetails {
  external String get name;
  external String get phone;
  external String get email;
  external Address get address;

  external factory BillingDetails({
    String? name,
    String? phone,
    String? email,
    Address? address,
  });
}

@JS()
@anonymous
class Address {
  external String get city;
  external String get county;
  external String get line1;
  external String get line2;
  external String get postal_code;
  external String get state;

  external factory Address({
    String? city,
    String? country,
    String? line1,
    String? line2,
    String? postal_code,
    String? state,
  });
}

@JS()
@anonymous
class StripePaymentMethod {
  external StripeElement get card;

  external BillingDetails get billing_details;

  external factory StripePaymentMethod({
    StripeElement? card,
    BillingDetails? billing_details,
  });
}

@JS()
@anonymous
class CardSetupOptions {
  external bool get handleActions;

  external factory CardSetupOptions({
    bool? handleActions,
  });
}

@JS()
@anonymous
class CardSetupData {
  external StripePaymentMethod get payment_method;

  external String get return_url;

  external factory CardSetupData({
    StripePaymentMethod? payment_method,
    String? return_url,
  });
}

@JS()
@anonymous
class ConfirmCardSetUpResult {
  external CardSetupIntent get setupIntent;

  external StripePaymentError? get error;

  external factory ConfirmCardSetUpResult({
    CardSetupIntent? setupIntent,
    StripePaymentError? error,
  });
}

@JS()
@anonymous
class NextAction {
  external String get redirect_to_url;

  external String get type;

  external factory NextAction({
    String? redirect_to_url,
    String? type,
  });
}

@JS()
@anonymous
class CardSetupIntent {
  external String get status;

  external String get id;

  external String get client_secret;

  external NextAction get next_action;
  external String get customer;
  external String get payment_method;
  external factory CardSetupIntent({
    String? status,
    String? id,
    String? client_secret,
    NextAction? next_action,
    String? customer,
    String? payment_method,
  });
}

@JS()
@anonymous
class StripePaymentError {
  external String get type;

  external String get code;

  external String get message;

  external String get decline_code;
  external String get param;

  external factory StripePaymentError({
    String? type,
    String? code,
    String? message,
    String? decline_code,
    String? param,
  });
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;

  external String get successUrl;

  external String get cancelUrl;

  external factory CheckoutOptions({
    List<LineItem>? lineItems,
    String? mode,
    String? successUrl,
    String? cancelUrl,
    String? sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;

  external int get quantity;

  external factory LineItem({String? price, int? quantity});
}
