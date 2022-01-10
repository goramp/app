import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/models/customer.dart';
import 'package:goramp/models/payment_provider.dart';
import 'package:universal_platform/universal_platform.dart';
import '../models/index.dart';
import '../utils/index.dart';

const kProductNotFoundErrorCode = "product/not_found";

class IAPurchaseException implements Exception {
  final String? message;
  final String? code;
  IAPurchaseException({this.code, this.message});
}

class PaymentsService {
  static String getStoreCode() {
    if (UniversalPlatform.isIOS) {
      return "app_store";
    } else if (UniversalPlatform.isAndroid) {
      return "google_play_store";
    } else {
      throw new StateError("unsupported in app purchase");
    }
  }

  static Stream<List<UserPaymentProvider>> getUserPaymentProvidersStream(
      String uid) {
    return FirebaseFirestore.instance
        .collection('payment_settings')
        .doc(uid)
        .collection('providers')
        .where('connected', isEqualTo: true)
        .snapshots()
        .map<List<UserPaymentProvider>>((QuerySnapshot snapshot) {
      return snapshot.docs.map<UserPaymentProvider>((doc) {
        return UserPaymentProvider.fromMap(
            asStringKeyedMap(doc.data() as Map<dynamic, dynamic>?)!);
      }).toList();
    });
  }

  static Stream<Customer?> getCustomerStream(String? uid) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('customers')
        .doc(uid)
        .collection('providers')
        .doc(STRIPE_PROVIDER_ID)
        .snapshots()
        .map<Customer?>((DocumentSnapshot snapshot) {
      if (!snapshot.exists) return null;
      return Customer.fromMap(
          asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!);
    });
  }

  static Stream<List<PaymentProvider>> getPaymentProvidersStream() {
    return FirebaseFirestore.instance
        .collection('payment_providers')
        .where('enabled', isEqualTo: true)
        .snapshots()
        .map<List<PaymentProvider>>((QuerySnapshot snapshot) {
      try {
        return snapshot.docs.map<PaymentProvider>((doc) {
          return PaymentProvider.fromMap(
              asStringKeyedMap(doc.data() as Map<dynamic, dynamic>?)!);
        }).toList();
      } catch (error) {
        return [];
      }
    });
  }

  static Stream<UserPaymentProvider?> getUserPaymentProviders(
      String? paymentProviderId) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('payment_settings')
        .doc(uid)
        .collection('providers')
        .doc(paymentProviderId)
        .snapshots()
        .map<UserPaymentProvider?>((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        return UserPaymentProvider.fromMap(
            asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!);
      }
      return null;
    });
  }

  static Future<List<PaymentProvider>> getPaymentProviders(
      AppConfig config) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: config.region)
            .httpsCallable('getPaymentProviders');
    final result = await callable.call();
    return (result as List).map<PaymentProvider>((item) {
      return PaymentProvider.fromMap(
          asStringKeyedMap(item as Map<dynamic, dynamic>?)!);
    }).toList();
  }
}
