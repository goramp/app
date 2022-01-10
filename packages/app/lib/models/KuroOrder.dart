import 'package:equatable/equatable.dart';
import 'package:goramp/models/customer.dart';
import '../utils/index.dart';

enum KOrderStatus { draft, processing, confirmed, expired, canceled }

class KOrderLineItem extends Equatable {
  KOrderLineItem(
      {this.itemId,
      this.itemType,
      this.price,
      this.quantity,
      this.total,
      this.itemName});

  List<Object?> get props =>
      [itemId, itemType, price, quantity, total, itemName];

  final String? itemId;
  final String? itemType;
  final String? itemName;
  final num? price;
  final num? quantity;
  final num? total;

  factory KOrderLineItem.fromMap(Map<String, dynamic> map) {
    return KOrderLineItem(
        itemId: map['itemId'],
        itemType: map['itemType'],
        price: map['price'],
        quantity: map['quantity'],
        total: map['total'],
        itemName: map['itemName']);
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'price': price,
      'itemType': itemType,
      'itemId': itemId,
      'total': total,
      'itemName': itemName
    };
  }
}

class KOrderPaymentProvider extends Equatable {
  KOrderPaymentProvider(
      {this.providerId, this.publicKey, this.stripeAccountId});

  List<Object?> get props => [
        providerId,
        publicKey,
        stripeAccountId,
      ];
  final String? providerId;
  final String? publicKey;
  final String? stripeAccountId;

  factory KOrderPaymentProvider.fromMap(Map<String, dynamic> map) {
    return KOrderPaymentProvider(
      providerId: map['providerId'],
      publicKey: map['publicKey'],
      stripeAccountId: map['stripeAccountId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'publicKey': publicKey,
      'stripeAccountId': stripeAccountId
    };
  }
}

class KOrder extends Equatable {
  KOrder({
    this.id,
    this.status = KOrderStatus.draft,
    this.createdAt,
    this.sourceAmount,
    this.sourceCurrency,
    this.fiatAmount,
    this.updatedAt,
    this.fiatCurrency,
    this.customer,
    this.destinationAmount,
    this.destinationCurrency,
    this.expiresAt,
    this.partnerOrderId,
  });

  List<Object?> get props => [
        id,
        createdAt,
        sourceCurrency,
        fiatCurrency,
        updatedAt,
        createdAt,
        status,
        fiatAmount,
        fiatCurrency,
        customer,
        destinationCurrency,
        expiresAt,
        partnerOrderId,
        sourceAmount,
        destinationAmount,
      ];

  final String? id;
  final String? sourceCurrency;
  final String? fiatCurrency;
  final String? destinationCurrency;
  final Customer? customer;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final KOrderStatus status;
  final double? fiatAmount;
  final DateTime? expiresAt;
  final String? partnerOrderId;
  final double? sourceAmount;
  final double? destinationAmount;

  static String stringFromKOrderStatus(KOrderStatus status) {
    switch (status) {
      case KOrderStatus.draft:
        return 'draft';
      case KOrderStatus.processing:
        return 'processing';
      case KOrderStatus.confirmed:
        return 'confirmed';
      case KOrderStatus.expired:
        return 'expired';
      case KOrderStatus.canceled:
        return 'canceled';
    }
    throw StateError("Inalid type");
  }

  static KOrderStatus stringToKOrderStatus(String? status) {
    switch (status) {
      case 'draft':
        return KOrderStatus.draft;
      case 'processing':
        return KOrderStatus.processing;
      case 'confirmed':
        return KOrderStatus.confirmed;
      case 'expired':
        return KOrderStatus.expired;
      case 'canceled':
        return KOrderStatus.canceled;
    }
    throw StateError("Inalid type");
  }

  KOrder copyWith(
      {String? id,
      String? sourceCurrency,
      DateTime? updatedAt,
      DateTime? createdAt,
      KOrderStatus? status,
      double? fiatAmount,
      String? fiatCurrency,
      num? feePercent,
      num? fee,
      num? total,
      String? destinationCurrency,
      Customer? customer,
      int? decimals,
      double? sourceAmount,
      double? destinationAmount}) {
    return KOrder(
        id: id ?? this.id,
        sourceCurrency: sourceCurrency ?? this.sourceCurrency,
        fiatCurrency: fiatCurrency ?? this.fiatCurrency,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        fiatAmount: fiatAmount ?? this.fiatAmount,
        destinationCurrency: destinationCurrency ?? this.destinationCurrency,
        customer: customer ?? this.customer,
        expiresAt: expiresAt ?? this.expiresAt,
        partnerOrderId: partnerOrderId ?? this.partnerOrderId,
        sourceAmount: sourceAmount ?? this.sourceAmount,
        destinationAmount: destinationAmount ?? this.destinationAmount);
  }

  factory KOrder.fromMap(Map<String, dynamic> map) {
    return KOrder(
      id: map['id'],
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
      sourceCurrency: map['sourceCurrency'],
      sourceAmount: map['sourceAmount'],
      destinationAmount: map['destinationAmount'],
      fiatCurrency: map['fiatCurrency'],
      status: stringToKOrderStatus(map['status']),
      destinationCurrency: map['destinationCurrency'],
      customer: map['customer'] != null
          ? Customer.fromMap(asStringKeyedMap(map['customer'])!)
          : null,
      fiatAmount: map['fiatAmount'],
      expiresAt: parseDate(map['expiresAt']),
      partnerOrderId: map['partnerOrderId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fiatAmount': fiatAmount,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'sourceCurrency': sourceCurrency,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'status': stringFromKOrderStatus(status),
      'customer': customer?.toMap(),
      'expiresAt': expiresAt?.millisecondsSinceEpoch,
      'partnerOrderId': partnerOrderId,
      'destinationCurrency': destinationCurrency,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
