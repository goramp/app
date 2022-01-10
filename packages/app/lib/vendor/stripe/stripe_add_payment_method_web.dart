import 'package:collection/collection.dart' show IterableExtension;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/vendor/stripe/web/stripe.dart';
import 'package:goramp/vendor/stripe/web/stripe_country_picker.dart';
import 'package:goramp/vendor/stripe/web/stripe_element_controller.dart';
import 'package:goramp/vendor/stripe/web/stripe_element_web.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:js/js_util.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

const _kVerticalSpace = 24.0;
const _countriesWithZip = ['CA', 'US', 'GB', 'UK'];

class StripeAddPaymentMethod extends StatefulWidget {
  const StripeAddPaymentMethod();
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

class _StripePaymentMethodsState extends State<StripeAddPaymentMethod> {
  Stripe? _stripe;
  final _formKey = GlobalKey<FormState>();
  final List<CountryCode> countryCodes;
  _StripePaymentMethodsState(this.countryCodes);
  ValueNotifier<CountryCode?> _selectedCountry =
      ValueNotifier<CountryCode?>(null);

  ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);
  ValueNotifier<StripeEvent?> _cardInput = ValueNotifier<StripeEvent?>(null);
  ValueNotifier<String?> _zipCode = ValueNotifier<String?>(null);
  ValueNotifier<bool> _saving = ValueNotifier<bool>(false);
  late CardSetup _cardSetup;
  late StripeElementController _cardController;
  ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  //StripeElementController _cardController;
  Object? _error;
  FocusNode _cardNode = FocusNode();
  FocusNode _countryNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cardInput.addListener(_validate);
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
      _stripe = Stripe(_cardSetup.publishKey, null);
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
    _isValid.value =
        _isZipValid && _cardInput.value != null && _cardInput.value!.complete;
  }

  Future<void> _saveCard() async {
    try {
      if (_saving.value) return;
      _saving.value = true;
      final ConfirmCardSetUpResult result = await promiseToFuture(
        await _stripe!.confirmCardSetup(
            _cardSetup.clientSecret,
            CardSetupData(
              payment_method: StripePaymentMethod(
                card: _cardController.element,
                billing_details: BillingDetails(
                  address: Address(postal_code: _zipCode.value),
                ),
              ),
            ),
            CardSetupOptions()),
      );
      if (result.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result.error!.message),
        ));
      } else {
        AppConfig config = context.read();
        await StripeService.savePaymentMethod(
            result.setupIntent.payment_method, config);
        Navigator.of(context).pop(result.setupIntent);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(StringResources.DEFAULT_ERROR_TITLE),
        ),
      );
    } finally {
      _saving.value = false;
    }
  }

  Widget _buildForm() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: SizedBox.expand(
          child: Padding(
            padding: isDisplayDesktop(context)
                ? const EdgeInsets.all(24.0)
                : const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: CenteredWidget(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ValueListenableBuilder<String?>(
                        valueListenable: _zipCode,
                        builder: (_, zip, __) {
                          return StripeElementWeb(
                            elementName: 'card',
                            stripe: _stripe,
                            fieldName: 'Card',
                            onChange: (event) {
                              _cardInput.value = event;
                            },
                            prefixIcon: Icon(
                              Icons.payment_outlined,
                            ),
                            zipCode: zip,
                            onInitialized: (controller) {
                              _cardController = controller;
                            },
                            focusNode: _cardNode,
                            // hideIcon: true,
                          );
                        }),
                    const SizedBox(height: _kVerticalSpace),
                    ValueListenableBuilder(
                        valueListenable: _selectedCountry,
                        builder: (_, dynamic value, __) {
                          return StripeCountryPickerField(
                            fieldName: "Country",
                            icon: Icon(
                              Icons.language,
                            ),
                            selected: value,
                            enabled: true,
                            items: countryCodes,
                            onChanged: (CountryCode value) {
                              _selectedCountry.value = value;
                            },
                            focusNode: _countryNode,
                          );
                        }),
                    ValueListenableBuilder(
                        valueListenable: _selectedCountry,
                        builder: (_, dynamic value, child) {
                          final hidePostalCode = !_countriesWithZip
                              .contains(value.code.toUpperCase());
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: hidePostalCode
                                ? const SizedBox.shrink()
                                : Column(children: [
                                    const SizedBox(height: _kVerticalSpace),
                                    TextFormField(
                                      autocorrect: false,
                                      maxLines: 1,
                                      onTap: () {
                                        _cardNode.unfocus();
                                      },
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
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                12.0, 0.0, 0.0, 0.0),
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
                                      // validator: (value) {
                                      //   if (value == null ||
                                      //       value.isEmpty) {
                                      //     return 'Zipcode cannot be blank';
                                      //   }
                                      //   return null;
                                      // },
                                      inputFormatters: isUSPostal
                                          ? [
                                              LengthLimitingTextInputFormatter(
                                                  5),
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ]
                                          : null,
                                      onChanged: (String name) {
                                        _zipCode.value = name;
                                      },
                                    ),
                                    // InputDecorator(
                                    //   decoration: InputDecoration(
                                    //     prefixIcon: Icon(Icons.map_outlined),
                                    //     //hintText: 'Postal Code',
                                    //     filled: true,
                                    //     hintStyle: theme.textTheme.subtitle1
                                    //         .copyWith(color: theme.hintColor),
                                    //     helperStyle: theme.textTheme.caption,
                                    //     enabledBorder: kEventInputBorder,
                                    //     disabledBorder: kEventInputBorder,
                                    //     focusedBorder: kEventInputBorder,
                                    //     errorBorder: kEventInputBorder,
                                    //   ),
                                    //   child: Row(
                                    //     children: <Widget>[
                                    //       Expanded(
                                    //         flex: 1,
                                    //         child: Text(
                                    //           'Postal Code',
                                    //           style: theme.textTheme.subtitle1
                                    //               .copyWith(
                                    //                   color: theme.hintColor),
                                    //         ),
                                    //       ),
                                    //       const SizedBox(
                                    //         width: 8.0,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // )
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
                    const SizedBox(height: _kVerticalSpace),
                    ValueListenableBuilder<bool>(
                        valueListenable: _isValid,
                        child: Text(
                          'Save Card',
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
                                    'Saving...',
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
                                  child: saving
                                      ? child
                                      : Text(
                                          'Save Card',
                                        ),
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
                maxWidth: 400,
              ),
            ),
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ValueListenableBuilder<bool>(
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
        },
      ),
    );
  }
}
