enum PaymentMethodType { card, credit, crypto, unknown }


abstract class PaymentMethod {
  final String? paymentMethodId;
  final PaymentMethodType paymentMethodType;
  const PaymentMethod(this.paymentMethodType, this.paymentMethodId);
}

class Credit extends PaymentMethod {
  const Credit(String paymentMethodId)
      : super(PaymentMethodType.credit, paymentMethodId);
}

String stringFromPaymentMethodType(PaymentMethodType? type) {
  switch (type) {
    case PaymentMethodType.card:
      return 'card';
    case PaymentMethodType.credit:
      return 'credit';
    case PaymentMethodType.crypto:
      return 'crypto';
    default:
      return 'unknown';
  }
}

PaymentMethodType stringToPaymentMethodType(String? type) {
  switch (type) {
    case 'card':
      return PaymentMethodType.card;
    case 'credit':
      return PaymentMethodType.credit;
    case 'crypto':
      return PaymentMethodType.crypto;
    default:
      return PaymentMethodType.unknown;
  }
}


enum CryptoCurrency { usdc, kuro, sol, unknown }

class TokenPaymentMethod extends PaymentMethod {
  final double? amount;
  final String? name;
  final CryptoCurrency currency;
  final num? maxDiscount;
  final String? networkName;
  final String? networkCoin;
  const TokenPaymentMethod(
      {required this.currency,
      required this.amount,
      required String? paymentMethodId,
      required this.name,
      this.maxDiscount = 0,
      this.networkName,
      this.networkCoin})
      : super(PaymentMethodType.card, paymentMethodId);

  factory TokenPaymentMethod.fromMap(Map<String, dynamic> map) {
    return TokenPaymentMethod(
      amount: map['amount'],
      currency: stringToCurrency(map['currency']),
      paymentMethodId: map['paymentMethodId'],
      name: map['name'],
      maxDiscount: map['maxDiscount'],
      networkName: map['networkName'],
      networkCoin: map['networkCoin'],
    );
  }

  @override
  bool operator ==(other) =>
      other is TokenPaymentMethod &&
      other.amount == amount &&
      other.currency == currency &&
      other.name == name &&
      other.maxDiscount == maxDiscount &&
      other.networkName == networkName &&
      other.networkCoin == networkCoin &&
      other.paymentMethodId == paymentMethodId;

  @override
  int get hashCode =>
      amount.hashCode ^
      name.hashCode ^
      currency.hashCode ^
      maxDiscount.hashCode ^
      networkName.hashCode ^
      networkCoin.hashCode ^
      paymentMethodId.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'currency': stringFromCurrency(currency),
      'paymentMethodId': paymentMethodId,
      'maxDiscount': maxDiscount,
      'networkName': networkName,
      'networkCoin': networkCoin,
      'name': name,
    };
  }

  String get currencyName {
    return stringFromCurrency(currency).toUpperCase();
  }

  String get currencyPattern {
    return patternForCurrency(currency);
  }

  static String stringFromCurrency(CryptoCurrency currency) {
    switch (currency) {
      case CryptoCurrency.kuro:
        return 'KURO';
      case CryptoCurrency.usdc:
        return 'USDC';
      case CryptoCurrency.sol:
        return 'SOL';
      default:
        return 'unknown';
    }
  }

  static CryptoCurrency stringToCurrency(String? currency) {
    switch (currency) {
      case 'KURO':
        return CryptoCurrency.kuro;
      case 'USDC':
        return CryptoCurrency.usdc;
      case 'SOL':
        return CryptoCurrency.sol;
      default:
        return CryptoCurrency.unknown;
    }
  }

  static String patternForCurrency(CryptoCurrency currency) {
    switch (currency) {
      case CryptoCurrency.kuro:
        return '##,###.####';
      case CryptoCurrency.usdc:
        return '##,###.##';
      default:
        return '##,###.####';
    }
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
