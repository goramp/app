import 'package:equatable/equatable.dart';
import '../utils/index.dart';

class IAPReceipt extends Equatable {
  final String? userId;
  final String? storeCode;
  final String? transactionId;
  final String? sku;
  final DateTime? purchaseDate;
  final String? orderData;
  final String? package;
  final bool? complete;

  IAPReceipt({
    this.userId,
    this.storeCode,
    this.transactionId,
    this.sku,
    this.orderData,
    this.purchaseDate,
    this.complete = false,
    this.package,
  });

  List<Object?> get props => [
        userId,
        storeCode,
        transactionId,
        sku,
        orderData,
        purchaseDate,
        complete,
        package,
      ];

  factory IAPReceipt.fromMap(Map<String, dynamic> map) {
    return IAPReceipt(
      userId: map['userId'],
      storeCode: map['storeCode'],
      transactionId: map['transactionId'],
      sku: map['sku'],
      orderData: map['orderData'],
      purchaseDate: parseDate(map['purchaseDate']),
      complete: map['complete'],
      package: map['package'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'storeCode': storeCode,
      'transactionId': transactionId,
      'sku': sku,
      'orderData': orderData,
      'purchaseDate': purchaseDate,
      'complete': complete,
      'package': package,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
