@JS()
library stripe;

import 'package:js/js.dart';

import 'dart:async';
import 'stripe.dart';

class StripeElementController {
  StripeElementController(this.elementName, this.stripe,
      {this.onChange,
      this.onBlur,
      this.onFocus,
      this.onClick,
      this.onReady,
      this.onEscape,
      this.options,
      this.initialOptions});

  StripeElement? _element;
  final Stripe? stripe;
  final String elementName;
  final UpdateOptions? initialOptions;
  final StripeEventHandler? onChange;
  final StripeEventHandler? onBlur;
  final StripeEventHandler? onFocus;
  final StripeEventHandler? onClick;
  final StripeEventHandler? onReady;
  final StripeEventHandler? onEscape;
  final ElementsOptions? options;
  bool _initialized = false;
  bool get initialized => _initialized;

  StripeElement? get element => _element;
  Future<void> initialize() async {
    _element = stripe!.elements(options).create(elementName, initialOptions);

    // ignore: undefined_prefixed_nam
    _element!.mount('#card-element');
    if (onChange != null) {
      _element!.on('change', allowInterop(onChange!));
    }
    if (onReady != null) {
      _element!.on('ready', allowInterop(onReady!));
    }
    if (onFocus != null) {
      _element!.on('focus', allowInterop(onFocus!));
    }
    if (onBlur != null) {
      _element!.on('blur', allowInterop(onBlur!));
    }
    if (onEscape != null) {
      _element!.on('escape', allowInterop(onEscape!));
    }
    if (onClick != null) {
      _element!.on('click', allowInterop(onClick!));
    }
    _initialized = true;
  }

  void focus() {
    _element!.focus();
  }

  void blur() {
    _element!.blur();
  }

  void hideIcons(bool hide) {
    _element!.update(UpdateOptions(hideIcon: hide));
  }

  void hidePostCode(bool hide) {
    _element!.update(UpdateOptions(hidePostalCode: hide));
  }

  void disable(bool disabled) {
    _element!.update(UpdateOptions(disabled: disabled));
  }

  void setZip(String zip) {
    _element!.update(UpdateOptions(value: PostalCodeInput(postalCode: zip)));
  }

  Future<void> dispose() async {
    _element!.unmount();
  }
}
