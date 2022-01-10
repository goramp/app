import 'package:equatable/equatable.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/models/payment_provider.dart';
import 'package:goramp/utils/index.dart';

class OrderPaymentMethod extends Equatable {
  OrderPaymentMethod({this.checkout, this.paymentMethodType, this.providerId});

  List<dynamic> get props => [checkout, paymentMethodType, providerId];

  final OrderCheckout? checkout;
  final PaymentMethodType? paymentMethodType;
  final String? providerId;

  factory OrderPaymentMethod.fromMap(Map<String, dynamic> map) {
    final providerId = map['providerId'];
    final checkoutMap = asStringKeyedMap(map['checkout']);
    OrderCheckout? checkout;
    switch (providerId) {
      case STRIPE_PROVIDER_ID:
        checkout = StripeCheckout.fromMap(checkoutMap!);
        break;
      case SOLANA_PAYMENT_PROVIDER:
        checkout = CryptoCheckout.fromMap(checkoutMap!);
        break;
    }
    return OrderPaymentMethod(
        providerId: providerId,
        checkout: checkout,
        paymentMethodType: stringToPaymentMethodType(map['type']));
  }

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'checkout': checkout?.toMap(),
      'type': stringFromPaymentMethodType(paymentMethodType),
    };
  }

  String toString() => '${toMap()}';
}

abstract class OrderCheckout extends Equatable {
  final String? id;
  final String providerId;
  const OrderCheckout(this.id, this.providerId);
  Map<String, dynamic> toMap();

  @override
  String toString() {
    return "${toMap()}";
  }
}

enum CardWalletType { google_pay, apple_pay, unknown }

String stringFromCardWalletType(CardWalletType wallet) {
  switch (wallet) {
    case CardWalletType.google_pay:
      return 'google_pay';
    case CardWalletType.apple_pay:
      return 'apple_pay';
    default:
      return 'unknown';
  }
}

CardWalletType stringToCardWalletType(String wallet) {
  switch (wallet) {
    case 'google_pay':
      return CardWalletType.google_pay;
    case 'apple_pay':
      return CardWalletType.apple_pay;
    default:
      return CardWalletType.unknown;
  }
}

class StripeCheckout extends OrderCheckout {
  const StripeCheckout(
      {String? id,
      this.stripeAccountId,
      this.successUrl,
      this.cancelUrl,
      this.wallets,
      this.apiKey})
      : super(id, STRIPE_PROVIDER_ID);
  final String? stripeAccountId;
  final String? successUrl;
  final String? cancelUrl;
  final String? apiKey;
  final List<CardWalletType>? wallets;

  List<dynamic> get props =>
      [id, providerId, stripeAccountId, successUrl, cancelUrl, wallets, apiKey];

  factory StripeCheckout.fromMap(Map<String, dynamic> map) {
    return StripeCheckout(
      id: map['id'],
      stripeAccountId: map['stripeAccountId'],
      successUrl: map['successUrl'],
      cancelUrl: map['cancelUrl'],
      wallets: map['wallets'] != null
          ? (map['wallets'] as List<dynamic>)
              .map((e) => stringToCardWalletType(e as String))
              .toList()
          : null,
      apiKey: map['apiKey'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'providerId': providerId,
      'stripeAccountId': stripeAccountId,
      'wallets': wallets?.map((e) => stringFromCardWalletType(e)).toList(),
      'successUrl': successUrl,
      'cancelUrl': cancelUrl,
      'apiKey': apiKey
    };
  }

  @override
  String toString() {
    return "${toMap()}";
  }
}

class CoinPrice extends Equatable {
  CoinPrice({this.rate, this.amount, this.coin, this.total, this.decimals});

  List<dynamic> get props => [rate, amount, coin, total, decimals];

  final num? rate;
  final String? coin;
  final String? amount;
  final num? total;
  final num? decimals;

  factory CoinPrice.fromMap(Map<String, dynamic> map) {
    return CoinPrice(
        rate: map['rate'],
        coin: map['coin'],
        amount: map['amount'],
        total: map['total'],
        decimals: map['decimals']);
  }

  Map<String, dynamic> toMap() {
    return {
      'rate': rate,
      'coin': coin,
      'amount': amount,
      'total': total,
      'decimals': decimals
    };
  }

  @override
  String toString() {
    return "${toMap()}";
  }
}

class CryptoCheckout extends OrderCheckout {
  const CryptoCheckout({String? id, this.coins})
      : super(id, SOLANA_PAYMENT_PROVIDER);
  final Map<String, CoinPrice>? coins;

  List<dynamic> get props => [id, providerId, coins];

  factory CryptoCheckout.fromMap(Map<String, dynamic> map) {
    return CryptoCheckout(
      id: map['id'],
      coins: map['coins'] != null
          ? asStringKeyedMap(map['coins'])!.map<String, CoinPrice>(
              (coin, details) =>
                  MapEntry(coin, CoinPrice.fromMap(asStringKeyedMap(details)!)))
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'providerId': providerId,
      'coins': coins?.map<String, dynamic>(
        (coin, detail) => MapEntry(
          coin,
          detail.toMap(),
        ),
      ),
    };
  }

  @override
  String toString() {
    return "${toMap()}";
  }
}
