import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  Customer(
      {this.name,
      this.email,
      this.totalCardsCount,
      this.defaultCardPaymentMethodId,
      this.customerId,
      this.maximumCards});

  List<Object?> get props => [
        name,
        email,
        defaultCardPaymentMethodId,
        totalCardsCount,
        customerId,
        maximumCards
      ];
  final String? name;
  final String? email;
  final String? defaultCardPaymentMethodId;
  final num? totalCardsCount;
  final String? customerId;
  final num? maximumCards;

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      name: map['name'],
      email: map['email'],
      totalCardsCount: map['totalCardsCount'],
      defaultCardPaymentMethodId: map['defaultCardPaymentMethodId'],
      customerId: map['customerId'],
      maximumCards: map['maximumCards'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'totalCardsCount': totalCardsCount,
      'defaultCardPaymentMethodId': defaultCardPaymentMethodId,
      'customerId': customerId,
      'maximumCards': maximumCards,
    };
  }
}
