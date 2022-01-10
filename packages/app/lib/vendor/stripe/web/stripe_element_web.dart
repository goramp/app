import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/vendor/stripe/web/stripe.dart';
import 'package:goramp/vendor/stripe/web/stripe_element_controller.dart';
import 'dart:html' as html;
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:provider/provider.dart';
import 'ui_fake.dart' if (dart.library.html) 'dart:ui' as ui;

typedef OnStripeElementControllerInitialized = void Function(
    StripeElementController controller);

class StripeElementWeb extends StatefulWidget {
  final String elementName;
  final Stripe? stripe;
  final StripeEventHandler? onChange;
  final String fieldName;
  final bool enabled;
  final bool hideIcon;
  final bool hidePostCode;
  final Widget? prefixIcon;
  final String? zipCode;
  final OnStripeElementControllerInitialized? onInitialized;
  final FocusNode? focusNode;

  const StripeElementWeb({
    required this.stripe,
    this.onChange,
    required this.elementName,
    required this.fieldName,
    this.hidePostCode = true,
    this.hideIcon = false,
    this.enabled = true,
    this.prefixIcon,
    this.zipCode,
    this.onInitialized,
    this.focusNode,
  });

  @override
  State<StatefulWidget> createState() {
    return _StripeElementState();
  }
}

class _StripeElementState extends State<StripeElementWeb> {
  StripeElementController? _cardController;
  late AppConfig _config;
  ValueNotifier<bool> _isFocused = ValueNotifier<bool>(false);
  ValueNotifier<String?> _error = ValueNotifier<String?>(null);

  final html.DivElement container = html.DivElement()
    ..id = 'card-element'
    ..style.border = 'none'
    ..style.height = '100%'
    ..style.width = '100%';

  @override
  void initState() {
    super.initState();
    _config = context.read();
    ui.platformViewRegistry.registerViewFactory(
        'StripeElement-${widget.fieldName}', (int viewId) => container);
    _initStripe();
  }

  FocusNode _focusNode = FocusNode(debugLabel: 'CardField');
  FocusNode get _effectiveNode => widget.focusNode ?? _focusNode;

  void _initStripe() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 1), () {
        _cardController ??= _initializeCardElement();
      });
    });
  }

  void _onFocus(event) {
    _isFocused.value = true;
    print('about to request card focus');
    _effectiveNode.requestFocus();
  }

  void _onBlur(event) {
    _isFocused.value = false;
    print('about to request card unfocus');
    _effectiveNode.unfocus();
  }

  void _onChange(StripeEvent event) {
    widget.onChange?.call(event);
    _error.value = event.error.message;
  }

  StripeElementController _initializeCardElement() {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white70 : Colors.black45;
    var base = CSSStyle(
        backgroundColor: 'transparent',
        color: theme.colorScheme.onBackground.toRgba(),
        iconColor: iconColor.toRgba(),
        //padding: '0px',
        fontFamily: "${_config.stripeElementFontFamily}, sans-serif",
        fontWeight: _config.stripeElementFontWeight,
        fontSize: '${theme.textTheme.subtitle1!.fontSize!.toInt()}px');
    appendPseudo(
      base,
      '::placeholder',
      CSSStyle(
        color: theme.hintColor.toRgba(),
        iconColor: iconColor.toRgba(),
      ),
    );
    appendPseudo(
      base,
      ':-webkit-autofill',
      CSSStyle(
        color: theme.colorScheme.secondary.toRgba(),
        iconColor: theme.colorScheme.secondary.toRgba(),
      ),
    );
    var invalid = CSSStyle(
      color: theme.errorColor.toRgba(),
      iconColor: theme.errorColor.toRgba(),
    );
    final cardController = StripeElementController(
      widget.elementName,
      widget.stripe,
      onChange: _onChange,
      onFocus: _onFocus,
      onBlur: _onBlur,
      initialOptions: UpdateOptions(
        style: Style(base: base, invalid: invalid),
        disabled: !widget.enabled,
        hideIcon: widget.hideIcon,
        hidePostalCode: widget.hidePostCode,
      ),
      options: ElementsOptions(
        fonts: [
          CssFontSource(cssSrc: _config.stripeElementFontUrl),
        ],
      ),
    );
    cardController.initialize();
    container
      ..style.flex = '1'
      ..classes = ['field']
      ..style.flexDirection = 'column'
      ..style.display = 'flex'
      ..style.justifyContent = 'center'
      ..style.outline = 'none'
      ..style.cursor = 'text';
    widget.onInitialized?.call(cardController);
    return cardController;
  }

  @override
  void didUpdateWidget(covariant StripeElementWeb oldWidget) {
    if (oldWidget.enabled != widget.enabled && _cardController != null) {
      _cardController!.disable(!widget.enabled);
    }
    if (oldWidget.hideIcon != widget.hideIcon && _cardController != null) {
      _cardController!.hideIcons(widget.hideIcon);
    }
    if (oldWidget.hidePostCode != widget.hidePostCode &&
        _cardController != null) {
      _cardController!.hidePostCode(widget.hidePostCode);
    }
    if (oldWidget.zipCode != widget.zipCode && _cardController != null) {
      _cardController!.hidePostCode(widget.hidePostCode);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _effectiveNode.dispose();
    _cardController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
        focusNode: _effectiveNode,
        // onFocusChange: (hasFocus) {
        //   if (hasFocus) {
        //     if (_isFocused.value) {
        //       print('returning a native focus');
        //       return;
        //     }
        //     _cardController.focus();
        //     print('Card has focus');
        //   } else {
        //     if (!_isFocused.value) {
        //       print('returning a native unfocus');
        //       return;
        //     }
        //     _cardController.blur();
        //     print('Card has lost focus');
        //   }
        // },
        child: ValueListenableBuilder(
          valueListenable: _isFocused,
          child: Container(
            constraints: BoxConstraints(maxHeight: 48.0),
            child:
                HtmlElementView(viewType: 'StripeElement-${widget.fieldName}'),
          ),
          builder: (context, dynamic focused, elementContainer) {
            return ValueListenableBuilder(
              valueListenable: _error,
              child: elementContainer,
              builder: (context, dynamic error, child) {
                return InputDecorator(
                  decoration: InputDecoration(
                      border: kEventInputBorder,
                      contentPadding:
                          const EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
                      enabledBorder: kEventInputBorder,
                      disabledBorder: kEventInputBorder,
                      focusedBorder: kEventInputBorder,
                      errorBorder: kEventInputBorder,
                      errorText: error,
                      //prefixIcon: widget.prefixIcon,
                      filled: true),
                  child: child,
                  isFocused: focused,
                );
              },
            );
          },
        ));
  }
}
