import 'package:collection/collection.dart' show IterableExtension;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/vendor/stripe/web/stripe_country_picker.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

const _kVerticalSpace = 24.0;
const _countriesWithZip = ['CA', 'US', 'GB', 'UK'];

class StripePayWithCard extends StatefulWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSuccess;
  final Order? order;
  const StripePayWithCard({
    this.order,
    this.onCancel,
    this.onSuccess,
  });
  @override
  State<StatefulWidget> createState() {
    List<Map> jsonList = codes;
    List<CountryCode> items = jsonList
        .map((json) => CountryCode.fromJson(json as Map<String, dynamic>))
        .toList()
      ..sort((c1, c2) => c1.name!.compareTo(c2.name!));
    return _StripePaymentMethodsState(items);
  }
}

class _StripePaymentMethodsState extends State<StripePayWithCard> {
  //Stripe _stripe;
  final _formKey = GlobalKey<FormState>();
  final List<CountryCode> countryCodes;
  _StripePaymentMethodsState(this.countryCodes);
  ValueNotifier<CountryCode?> _selectedCountry =
      ValueNotifier<CountryCode?>(null);

  ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);
  //ValueNotifier<StripeEvent> _cardInput = ValueNotifier<StripeEvent>(null);
  ValueNotifier<String?> _zipCode = ValueNotifier<String?>(null);
  ValueNotifier<bool> _saving = ValueNotifier<bool>(false);
  ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  late CardSetup _cardSetup;
  //StripeElementController _cardController;
  Object? _error;

  @override
  void initState() {
    super.initState();
    //_cardInput.addListener(_validate);
    _zipCode.addListener(_validate);
    _selectedCountry.addListener(_validate);
    _setupCards();
  }

  void _setupCards() async {
    try {
      if (_loading.value) return;
      _loading.value = true;
      AppConfig config = context.read();
      _cardSetup = await StripeService.setupCards(config);
      _selectedCountry.value = countryCodes.firstWhereOrNull((country) =>
          country.code!.toLowerCase() == _cardSetup.country?.toLowerCase());
    } catch (e, s) {
      ErrorHandler.report(e, s);
      _error = e;
    } finally {
      _loading.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool get isUSPostal =>
      _selectedCountry.value != null &&
      _selectedCountry.value!.code!.toUpperCase() == 'US';

  bool get _postalCodeRequired =>
      _selectedCountry.value != null &&
      _countriesWithZip.contains(_selectedCountry.value!.code!.toUpperCase());

  bool get _isZipValid {
    if (_postalCodeRequired)
      return _zipCode.value != null &&
          _zipCode.value!.length >= 5 &&
          RegExp(r"^[a-z0-9][a-z0-9\- ]{0,10}[a-z0-9]$", caseSensitive: false)
              .hasMatch(_zipCode.value!);
    return true;
  }

  void _validate() {
    // _isValid.value =
    //     _isZipValid && _cardInput.value != null && _cardInput.value.complete;
  }

  Future<void> _saveCard() async {
    // try {
    //   if (_saving.value) return;
    //   _saving.value = true;
    //   final ConfirmCardSetUpResult result = await promiseToFuture(
    //     await _stripe.confirmCardSetup(
    //         _cardSetup.clientSecret,
    //         CardSetupData(
    //           payment_method: StripePaymentMethod(
    //             card: _cardController.element,
    //             billing_details: BillingDetails(
    //               address: Address(postal_code: _zipCode.value),
    //             ),
    //           ),
    //         ),
    //         CardSetupOptions()),
    //   );
    //   if (result.error != null) {
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text(result.error.message),
    //     ));
    //   } else {
    //     AppConfig config = context.read();
    //     await StripeService.savePaymentMethod(
    //         result.setupIntent.payment_method, config);
    //     Navigator.of(context).pop(result.setupIntent);
    //   }
    // } catch (error) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(StringResources.DEFAULT_ERROR_TITLE),
    //     ),
    //   );
    // } finally {
    //   _saving.value = false;
    // }
  }

  Widget _buildForm() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ValueListenableBuilder<String>(
              //     valueListenable: _zipCode,
              //     builder: (_, zip, __) {
              //       return StripeElementWeb(
              //         elementName: 'card',
              //         stripe: _stripe,
              //         fieldName: 'Card',
              //         onChange: (event) {
              //           _cardInput.value = event;
              //         },
              //         prefixIcon: Icon(
              //           Icons.payment_outlined,
              //         ),
              //         zipCode: zip,
              //         onInitialized: (controller) {
              //           _cardController = controller;
              //         },
              //         // hideIcon: true,
              //       );
              //     }),
              // const SizedBox(height: _kVerticalSpace),
              ValueListenableBuilder(
                  valueListenable: _selectedCountry,
                  builder: (_, dynamic value, __) {
                    return StripeCountryPickerField(
                      fieldName: S.of(context).select_country,
                      icon: Icon(
                        Icons.language,
                      ),
                      selected: value,
                      enabled: true,
                      items: countryCodes,
                      onChanged: (CountryCode value) {
                        _selectedCountry.value = value;
                      },
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: _selectedCountry,
                  builder: (_, dynamic value, child) {
                    final hidePostalCode =
                        !_countriesWithZip.contains(value.code.toUpperCase());
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: hidePostalCode
                          ? const SizedBox.shrink()
                          : Column(children: [
                              const SizedBox(height: _kVerticalSpace),
                              TextFormField(
                                autocorrect: false,
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
                                keyboardType: isUSPostal
                                    ? TextInputType.numberWithOptions()
                                    : TextInputType.streetAddress,
                                cursorColor:
                                    isDark ? Colors.white : Colors.black,
                                decoration: InputDecoration(
                                  prefixIcon: SizedBox(
                                    width: 32.0,
                                    height: 24.0,
                                    child: Center(
                                      child: Icon(Icons.map_outlined),
                                    ),
                                  ),
                                  hintText: 'Postal Code',
                                  filled: true,
                                  hintStyle: theme.textTheme.subtitle1!
                                      .copyWith(color: theme.hintColor),
                                  helperStyle: theme.textTheme.caption,
                                  enabledBorder: kEventInputBorder,
                                  disabledBorder: kEventInputBorder,
                                  focusedBorder: kEventInputBorder,
                                  errorBorder: kEventInputBorder,
                                ),
                                cursorWidth: 1,
                                inputFormatters: isUSPostal
                                    ? [
                                        LengthLimitingTextInputFormatter(5),
                                        FilteringTextInputFormatter.digitsOnly
                                      ]
                                    : null,
                                onChanged: (String name) {
                                  _zipCode.value = name;
                                },
                              ),
                            ]),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.fastOutSlowIn,
                      transitionBuilder:
                          (Widget widget, Animation<double> animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          child: widget,
                          axisAlignment: -1,
                        );
                      },
                    );
                  }),
              const SizedBox(height: 8),
              SafeArea(
                bottom: true,
                child: ButtonBar(
                  alignment: MainAxisAlignment.end,
                  buttonPadding:
                      EdgeInsets.symmetric(horizontal: 0, vertical: Insets.ls),
                  children: [
                    TextButton(
                      onPressed: widget.onCancel,
                      child: Text('Cancel'),
                    ),
                    ValueListenableBuilder<bool>(
                        valueListenable: _isValid,
                        child: Text(
                          'Pay Now',
                        ),
                        builder: (_, valid, cardText) {
                          return ValueListenableBuilder<bool>(
                              valueListenable: _saving,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 18.0,
                                    width: 18.0,
                                    child: PlatformCircularProgressIndicator(
                                      theme.colorScheme.primary,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    'processing...',
                                  ),
                                ],
                              ),
                              builder: (_, saving, child) {
                                return ElevatedButton(
                                  style: context.raisedStyle.copyWith(
                                    visualDensity: VisualDensity.standard,
                                    textStyle: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .textTheme
                                          .button!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  child: saving ? child : cardText,
                                  onPressed: valid
                                      ? saving
                                          ? null
                                          : _saveCard
                                      : null,
                                );
                              });
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final errorEl = EmptyContent(
      key: ValueKey('error'),
      title: Text(
        StringResources.DEFAULT_ERROR_TITLE2,
        style: Theme.of(context).textTheme.caption,
        textAlign: TextAlign.center,
      ),
      icon: Icon(
        MdiIcons.alert,
        size: 96.0,
        color: isDark ? Colors.white38 : Colors.grey[300],
      ),
      action: TextButton(
        child: Text('RETRY'),
        onPressed: () {
          setState(() {
            print('should rebuild');
          });
        },
      ),
    );
    const loader =
        Padding(padding: EdgeInsets.all(48.0), child: const FeedLoader());
    return ValueListenableBuilder<bool>(
        valueListenable: _loading,
        child: _buildForm(),
        builder: (_, loading, form) {
          Widget? body;
          if (loading) {
            body = loader;
          } else if (_error != null) {
            body = errorEl;
          } else {
            body = form;
          }
          return AnimatedSwitcher(
            child: body,
            duration: kThemeAnimationDuration,
          );
        });
  }
}
