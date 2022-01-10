import 'package:equatable/equatable.dart';
import 'package:goramp/utils/index.dart';

enum PaymentTransactionType { refund, payment, payout }

enum PaymentTransactionStatus { success, processing, pending, failed, canceled }

enum PaymentTransactionReferenceType {
  order,
}

enum PaymentTransactionRefundType { full, partial }

class PaymentTransaction extends Equatable {
  PaymentTransaction({
    this.transactionId,
    this.externalTransactionId,
    this.paymentMethodId,
    this.defaultCardPaymentMethodId,
    this.paymentMethodType,
    this.providerId,
    this.currency,
    this.amount,
    this.fee,
    this.updatedAt,
    this.createdAt,
    this.settleAt,
    this.status,
    this.referenceId,
    this.referenceType,
    this.refundType,
    this.partnerId,
    this.payoutId,
    this.escrowAddress,
    this.tokenMintAddress,
    this.hold,
    this.transactionType,
    this.decimals,
    this.name,
    this.description,
  });

  List<Object?> get props => [
        transactionId,
        externalTransactionId,
        defaultCardPaymentMethodId,
        paymentMethodId,
        paymentMethodType,
        providerId,
        currency,
        amount,
        fee,
        updatedAt,
        createdAt,
        settleAt,
        status,
        referenceId,
        referenceType,
        refundType,
        partnerId,
        payoutId,
        escrowAddress,
        tokenMintAddress,
        hold,
        transactionType,
        decimals,
        name,
        description
      ];
  final String? transactionId;
  final String? externalTransactionId;
  final String? defaultCardPaymentMethodId;
  final String? paymentMethodId;
  final String? paymentMethodType;
  final String? providerId;
  final String? currency;
  final num? decimals;
  final String? fee;
  final String? amount;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final DateTime? settleAt;
  final PaymentTransactionStatus? status;
  final String? referenceId;
  final PaymentTransactionReferenceType? referenceType;
  final PaymentTransactionRefundType? refundType;
  final String? partnerId;
  final String? payoutId;
  final String? escrowAddress;
  final String? tokenMintAddress;
  final bool? hold;
  final PaymentTransactionType? transactionType;
  final String? name;
  final String? description;

  factory PaymentTransaction.fromMap(Map<String, dynamic> map) {
    return PaymentTransaction(
        transactionId: map['transactionId'],
        externalTransactionId: map['externalTransactionId'],
        paymentMethodId: map['paymentMethodId'],
        defaultCardPaymentMethodId: map['defaultCardPaymentMethodId'],
        paymentMethodType: map['paymentMethodType'],
        providerId: map['providerId'],
        fee: map['fee']?.toString(),
        amount: map['amount']?.toString(),
        currency: map['currency'],
        name: map['name'],
        description: map['description'],
        createdAt: parseDate(map['createdAt']),
        updatedAt: parseDate(map['updatedAt']),
        settleAt: parseDate(map['settleAt']),
        status: stringPaymentTransactionStatus(map['status']),
        referenceId: map['referenceId'],
        referenceType:
            stringPaymentTransactionReferenceType(map['referenceType']),
        refundType: map['refundType'] != null
            ? stringPaymentTransactionRefundType(map['refundType'])
            : null,
        partnerId: map['partnerId'],
        payoutId: map['payoutId'],
        escrowAddress: map['escrowAddress'],
        tokenMintAddress: map['tokenMintAddress'],
        hold: map['hold'],
        transactionType: stringToPaymentTransactionType(map['transactionType']),
        decimals: map['decimals']);
  }

  static PaymentTransactionType stringToPaymentTransactionType(String? status) {
    switch (status) {
      case 'refund':
        return PaymentTransactionType.refund;
      case 'payment':
        return PaymentTransactionType.payment;
      case 'payout':
        return PaymentTransactionType.payout;
    }
    throw StateError("Inalid type");
  }

  static PaymentTransactionStatus stringPaymentTransactionStatus(
      String? status) {
    switch (status) {
      case 'success':
        return PaymentTransactionStatus.success;
      case 'processing':
        return PaymentTransactionStatus.processing;
      case 'pending':
        return PaymentTransactionStatus.pending;
      case 'failed':
        return PaymentTransactionStatus.failed;
      case 'canceled':
        return PaymentTransactionStatus.canceled;
    }
    throw StateError("Inalid type");
  }

  static PaymentTransactionReferenceType stringPaymentTransactionReferenceType(
      String? status) {
    switch (status) {
      case 'Order':
        return PaymentTransactionReferenceType.order;
    }
    throw StateError("Inalid type");
  }

  static PaymentTransactionRefundType stringPaymentTransactionRefundType(
      String? status) {
    switch (status) {
      case 'full':
        return PaymentTransactionRefundType.full;
      case 'partial':
        return PaymentTransactionRefundType.partial;
    }
    throw StateError("Inalid type");
  }
}
