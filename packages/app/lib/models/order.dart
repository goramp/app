import 'package:equatable/equatable.dart';
import 'package:goramp/models/customer.dart';
import 'package:goramp/models/index.dart';
import '../utils/index.dart';

enum OrderStatus { draft, processing, confirmed, expired, canceled }

class OrderLineItem extends Equatable {
  OrderLineItem(
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
  final String? price;
  final num? quantity;
  final String? total;

  factory OrderLineItem.fromMap(Map<String, dynamic> map) {
    return OrderLineItem(
        itemId: map['itemId'],
        itemType: map['itemType'],
        price: map['price']?.toString(),
        quantity: map['quantity'],
        total: map['total']?.toString(),
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

class OrderPaymentProvider extends Equatable {
  OrderPaymentProvider({this.providerId, this.publicKey, this.stripeAccountId});

  List<Object?> get props => [
        providerId,
        publicKey,
        stripeAccountId,
      ];
  final String? providerId;
  final String? publicKey;
  final String? stripeAccountId;

  factory OrderPaymentProvider.fromMap(Map<String, dynamic> map) {
    return OrderPaymentProvider(
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

class Order extends Equatable {
  Order(
      {this.id,
      this.status = OrderStatus.draft,
      this.createdAt,
      this.lineItems,
      this.paymentMethods,
      this.updatedAt,
      this.subTotal,
      this.total,
      this.feePercent,
      this.customer,
      this.currency,
      this.timeToDisputeEndsAt,
      this.disputed,
      this.expiresAt,
      this.partnerId,
      this.decimals});

  List<Object?> get props => [
        id,
        createdAt,
        lineItems,
        subTotal,
        updatedAt,
        createdAt,
        status,
        paymentMethods,
        subTotal,
        total,
        feePercent,
        customer,
        currency,
        timeToDisputeEndsAt,
        disputed,
        expiresAt,
        partnerId,
        decimals
      ];

  final String? id;
  final List<OrderLineItem>? lineItems;
  final String? subTotal;
  final num? feePercent;
  final String? total;
  final int? decimals;
  final String? currency;
  final Customer? customer;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final OrderStatus status;
  final List<OrderPaymentMethod>? paymentMethods;
  final DateTime? timeToDisputeEndsAt;
  final bool? disputed;
  final DateTime? expiresAt;
  final String? partnerId;

  static String stringFromOrderStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.draft:
        return 'draft';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.expired:
        return 'expired';
      case OrderStatus.canceled:
        return 'canceled';
    }
    throw StateError("Inalid type");
  }

  static OrderStatus stringToOrderStatus(String? status) {
    switch (status) {
      case 'draft':
        return OrderStatus.draft;
      case 'processing':
        return OrderStatus.processing;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'expired':
        return OrderStatus.expired;
      case 'canceled':
        return OrderStatus.canceled;
    }
    throw StateError("Inalid type");
  }

  Order copyWith(
      {String? id,
      DateTime? lineItems,
      DateTime? updatedAt,
      DateTime? createdAt,
      OrderStatus? status,
      OrderPaymentProvider? paymentMethods,
      String? subTotal,
      num? feePercent,
      String? total,
      String? currency,
      Customer? customer,
      int? decimals}) {
    return Order(
      id: id ?? this.id,
      lineItems: lineItems as List<OrderLineItem>? ?? this.lineItems,
      subTotal: subTotal ?? this.subTotal,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      paymentMethods:
          paymentMethods as List<OrderPaymentMethod>? ?? this.paymentMethods,
      feePercent: feePercent ?? this.feePercent,
      total: total ?? this.total,
      currency: currency ?? this.currency,
      customer: customer ?? this.customer,
      timeToDisputeEndsAt: timeToDisputeEndsAt ?? this.timeToDisputeEndsAt,
      disputed: disputed ?? this.disputed,
      expiresAt: expiresAt ?? this.expiresAt,
      partnerId: partnerId ?? this.partnerId,
      decimals: decimals ?? this.decimals,
    );
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
        id: map['id'],
        createdAt: parseDate(map['createdAt']),
        updatedAt: parseDate(map['updatedAt']),
        lineItems: map['lineItems'] != null
            ? (map['lineItems'] as List)
                .map((map) => OrderLineItem.fromMap(asStringKeyedMap(map)!))
                .toList()
            : null,
        subTotal: map['subTotal']?.toString(),
        status: stringToOrderStatus(map['status']),
        feePercent: map['feePercent'],
        total: map['total']?.toString(),
        currency: map['currency'],
        customer: map['customer'] != null
            ? Customer.fromMap(asStringKeyedMap(map['customer'])!)
            : null,
        paymentMethods: map['paymentMethods'] != null
            ? (map['paymentMethods'] as List<dynamic>)
                .map((e) => OrderPaymentMethod.fromMap(asStringKeyedMap(e)!))
                .toList()
            : null,
        expiresAt: parseDate(map['expiresAt']),
        timeToDisputeEndsAt: parseDate(map['timeToDisputeEndsAt']),
        disputed: map['disputed'],
        partnerId: map['partnerId'],
        decimals: map['decimals']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paymentMethods': paymentMethods?.map((e) => e.toMap()).toList(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'lineItems': lineItems?.map((e) => e.toMap()).toList(),
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'status': stringFromOrderStatus(status),
      'customer': customer?.toMap(),
      'expiresAt': expiresAt?.millisecondsSinceEpoch,
      'timeToDisputeEndsAt': timeToDisputeEndsAt?.millisecondsSinceEpoch,
      'disputed': disputed,
      'partnerId': partnerId,
      'total': total,
      'currency': currency,
      'decimals': decimals
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
