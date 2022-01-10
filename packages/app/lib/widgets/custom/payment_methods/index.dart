import 'package:flutter/material.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/custom/payment_methods/crypto/crypto_payment_method.dart';
import 'package:goramp/widgets/index.dart';
import 'package:provider/provider.dart';
import 'crypto/crypto_payment_method.dart';

const kMaxCards = 3;

enum PaymentMethodExpandionType { Card, Crypto, Credit, GooglePay, ApplePay }

typedef PaymentMethodItemBodyBuilder = Widget Function(
    ValueNotifier<bool> loading);
typedef ValueToString<T> = String Function(T value);

class ExpansionItem {
  ExpansionItem(
      {this.isExpanded = false,
      this.type,
      this.bodyBuilder,
      this.headerBuilder});
  bool isExpanded;
  final PaymentMethodExpandionType? type;
  final PaymentMethodItemBodyBuilder? bodyBuilder;
  final ExpansionPanelHeaderBuilder? headerBuilder;
}

class PaymentMethods extends StatefulWidget {
  final Order order;
  const PaymentMethods({Key? key, required this.order}) : super(key: key);

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  ValueNotifier<bool> _loadingPayment = ValueNotifier<bool>(false);
  ValueNotifier<bool> _loadingPaymentMethods = ValueNotifier<bool>(false);
  PaymentMethodExpandionType? _intitialOpen;
  List<ExpansionItem> _expansionItems = [];

  @override
  void initState() {
    _loadPaymentMethods();
    super.initState();
  }

  void _loadPaymentMethods() {
    try {
      _loadingPaymentMethods.value = true;
      widget.order.paymentMethods!.forEach((paymentMethod) {
        if (paymentMethod.paymentMethodType == PaymentMethodType.crypto) {
          _expansionItems.add(
            ExpansionItem(
              type: PaymentMethodExpandionType.Crypto,
              bodyBuilder: (ValueNotifier<bool> loading) =>
                  CryptoPaymentMethodBody(
                paymentLoading: loading,
                checkout: paymentMethod.checkout as CryptoCheckout,
              ),
              headerBuilder: (context, isExpaneded) =>
                  CryptoPaymentMethodHeader(
                isExpanded: isExpaneded,
              ),
            ),
          );
        }
      });
      if (_expansionItems.isNotEmpty) {
        _expansionItems.first.isExpanded = true;
        _intitialOpen = _expansionItems.first.type;
      }
    } finally {
      _loadingPaymentMethods.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: widget.order,
      child: SingleChildScrollView(
        child: Container(
          child: _buildPanel(),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return CenteredWidget(
      ValueListenableBuilder(
          valueListenable: _loadingPaymentMethods,
          builder: (contex, dynamic loading, child) {
            return AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: loading
                  ? FeedLoader()
                  : GTExpansionPanelList.radio(
                      initialOpenPanelValue: _intitialOpen,
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _expansionItems[index].isExpanded = !isExpanded;
                        });
                      },
                      children: _expansionItems
                          .map<ExpansionPanelRadio>((ExpansionItem item) {
                        return ExpansionPanelRadio(
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return item.headerBuilder!(context, isExpanded);
                          },
                          canTapOnHeader: true,
                          body: item.bodyBuilder!(_loadingPayment),
                          value: item.type!,
                        );
                      }).toList(),
                    ),
            );
          }),
      maxWidth: 500,
    );
  }
}
