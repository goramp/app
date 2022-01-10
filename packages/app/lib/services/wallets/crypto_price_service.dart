import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/utils/index.dart';

class CryptoPriceService {
  static StreamSubscription subscribeRates(
      void onData(Map<String, ExchangeRate> schedules),
      {void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError}) {
    return FirebaseFirestore.instance
        .collection('rates')
        .doc('latest')
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists) {
        onData({});
        return;
      }
      final rates = (documentSnapshot.data() as Map<dynamic, dynamic>)
          .map<String, ExchangeRate>((key, value) {
        final map = asStringKeyedMap(value as Map<dynamic, dynamic>?)!;
        return MapEntry(key, ExchangeRate.fromMap(map));
      });
      onData(rates);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static StreamSubscription subscribeMarkets(
      void onData(Map<String, Market> map),
      {void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError}) {
    return FirebaseFirestore.instance.collection('markets').snapshots().listen(
        (QuerySnapshot querySnapshot) {
      final markets = querySnapshot.docs.map<Market>((value) {
        final map = asStringKeyedMap(value.data() as Map<dynamic, dynamic>?)!;
        map['id'] = value.id;
        return Market.fromMap(map);
      });
      final Map<String, Market> map = markets.fold({}, (memo, market) {
        memo["${market.publicKey}"] = market;
        return memo;
      });
      onData(map);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}
