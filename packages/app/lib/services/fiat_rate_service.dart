import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FiatRatesService {
  static StreamSubscription subscribeRates(
      void onData(Map<String, double> rates),
      {void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError}) {
    return FirebaseFirestore.instance
        .collection('fiat_rates')
        .doc('latest')
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists) {
        onData({});
        return;
      }
      final rates = (documentSnapshot.data() as Map<dynamic, dynamic>)
          .map<String, double>((key, value) {
        return MapEntry(key, (value as num).toDouble());
      });
      onData(rates);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}
