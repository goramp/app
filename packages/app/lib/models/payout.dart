import 'package:equatable/equatable.dart';
import 'package:goramp/models/payment_transaction.dart';
import 'package:goramp/utils/index.dart';

class PayoutTransaction extends Equatable {
  PayoutTransaction({
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
    this.partnerId,
    this.payoutId,
    this.escrowAddress,
    this.destinationMintAddress,
    this.hold,
    this.paidAt,
    this.sourceWalletAddress,
    this.destinationWalletAddress,
    this.settled,
    this.instantSettlement,
    this.stripeAccountId,
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
        partnerId,
        payoutId,
        escrowAddress,
        destinationMintAddress,
        hold,
        paidAt,
        destinationWalletAddress,
        sourceWalletAddress,
        settled,
        instantSettlement,
        stripeAccountId
      ];

  final String? transactionId;
  final String? externalTransactionId;
  final String? defaultCardPaymentMethodId;
  final String? paymentMethodId;
  final String? paymentMethodType;
  final String? providerId;
  final String? currency;
  final num? fee;
  final num? amount;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final DateTime? settleAt;
  final DateTime? paidAt;
  final PaymentTransactionStatus? status;
  final String? referenceId;
  final PaymentTransactionReferenceType? referenceType;
  final String? partnerId;
  final String? payoutId;
  final String? escrowAddress;
  final String? destinationWalletAddress;
  final String? sourceWalletAddress;
  final String? destinationMintAddress;
  final bool? hold;
  final bool? settled;
  final bool? instantSettlement;
  final String? stripeAccountId;

  factory PayoutTransaction.fromMap(Map<String, dynamic> map) {
    return PayoutTransaction(
      transactionId: map['transactionId'],
      externalTransactionId: map['externalTransactionId'],
      paymentMethodId: map['paymentMethodId'],
      defaultCardPaymentMethodId: map['defaultCardPaymentMethodId'],
      paymentMethodType: map['paymentMethodType'],
      providerId: map['providerId'],
      fee: map['fee'],
      amount: map['amount'],
      currency: map['currency'],
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
      settleAt: parseDate(map['settleAt']),
      paidAt: parseDate(map['paidAt']),
      status: PaymentTransaction.stringPaymentTransactionStatus(map['status']),
      referenceId: map['referenceId'],
      partnerId: map['partnerId'],
      payoutId: map['payoutId'],
      escrowAddress: map['escrowAddress'],
      destinationMintAddress: map['destinationMintAddress'],
      sourceWalletAddress: map['sourceWalletAddress'],
      destinationWalletAddress: map['destinationWalletAddress'],
      hold: map['hold'],
      settled: map['settled'],
      instantSettlement: map['instantSettlement'],
      stripeAccountId: map['stripeAccountId'],
    );
  }
}
