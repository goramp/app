import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/index.dart';
import '../utils/index.dart';

const String path = 'transactions';

class CallException implements Exception {
  final int? statusCode;
  final String? message;
  final String? code;
  CallException({this.statusCode, this.code, this.message});

  @override
  String toString() {
    return "[statusCode: $statusCode, code: $code, message: $message]";
  }
}

class UnavailableException implements Exception {
  final String? message;
  UnavailableException({this.message});

  @override
  String toString() {
    return "[message: $message]";
  }
}

class LowCreditException implements Exception {
  final String? message;
  LowCreditException({this.message});

  @override
  String toString() {
    return "[message: $message]";
  }
}

class PaymentTransactionService {
  static StreamSubscription getPaymemtTransactionsSubscription(
      String? userId, void onData(List<PaymentTransaction> transactions),
      {PaymentTransaction? last,
      required int limit,
      void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError}) {
    Query query = FirebaseFirestore.instance
        .collection(path)
        .where("userId", isEqualTo: userId)
        //.where("status", isEqualTo: 'success')
        .where("transactionType", whereIn: ['refund', 'payment', 'payout'])
        //.orderBy("status", descending: true)
        .orderBy("createdAt", descending: true)
        .limit(limit);
    if (last != null) {
      query = query.startAfter([last.createdAt]);
    }
    return query.snapshots().listen((QuerySnapshot querySnapshot) {
      List schedules = querySnapshot.docs.map((DocumentSnapshot snapshot) {
        final map =
            asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
        map['id'] = snapshot.id;
        return PaymentTransaction.fromMap(map);
      }).toList();
      onData(schedules as List<PaymentTransaction>);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static Future<List<PaymentTransaction>> fetchPaymemtTransactions(
      String userId,
      {Call? first,
      Call? last,
      required limit}) async {
    Query query = FirebaseFirestore.instance
        .collection(path)
        .where("userId", isEqualTo: userId)
        .where("transactionType", whereIn: ['refund', 'payment', 'payout'])
        //.orderBy("status", descending: true)
        .orderBy("createdAt")
        .limit(limit);
    if (first != null) {
      query = query.endBefore([first.scheduledAt]);
    }
    if (last != null) {
      query = query.startAfter([last.scheduledAt]);
    }
    QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((DocumentSnapshot snapshot) {
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return PaymentTransaction.fromMap(map as Map<String, dynamic>);
    }).toList();
  }

  static Future<PaymentTransaction?> getPaymentTransaction(
      String? userId, String transactionId) async {
    final transactionDoc = await FirebaseFirestore.instance
        .collection(path)
        .doc(transactionId)
        .get();
    if (!transactionDoc.exists) {
      return null;
    }
    return PaymentTransaction.fromMap(
        asStringKeyedMap(transactionDoc as Map<dynamic, dynamic>?)!);
  }
}
