import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/models/checkout.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/models/payment_provider.dart';
import 'package:goramp/utils/index.dart';

enum StripeExceptionCode {
  InvalidGrantCode,
  CustomerNotFound,
  MaximumCardsReached,
  UnAuthorized,
  PaymentMethodNotFound,
  Unknown
}

class StripeConnectException implements Exception {
  final StripeExceptionCode code;
  final String? message;
  StripeConnectException(this.code,
      {this.message = StringResources.UNKNOWN_ERROR});

  static StripeExceptionCode stringToCode(String? code) {
    switch (code) {
      case "customer/customer_not_found":
        return StripeExceptionCode.CustomerNotFound;
      case "customer/unauthorized":
        return StripeExceptionCode.UnAuthorized;
      case "cards/maximum_reached":
        return StripeExceptionCode.MaximumCardsReached;
      case "payment_method/payment_method_not_found":
        return StripeExceptionCode.PaymentMethodNotFound;
      case "invalid-argument":
        return StripeExceptionCode.InvalidGrantCode;
      default:
        return StripeExceptionCode.Unknown;
    }
  }

  StripeConnectException.unknown()
      : this.code = StripeExceptionCode.Unknown,
        this.message = StringResources.UNKNOWN_ERROR;

  factory StripeConnectException.fromMap(Map<String, dynamic> map) {
    return StripeConnectException(
      stringToCode(map['code']),
      message: map['errorMessage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'errorMessage': message,
    };
  }

  String toString() {
    return '${toMap()}';
  }
}

class StripeAuthorizationResponse {
  final String? authorizeUrl;
  final String? redirectUrl;
  final String? refreshUrl;

  StripeAuthorizationResponse(
      {this.authorizeUrl, this.redirectUrl, this.refreshUrl});

  factory StripeAuthorizationResponse.fromMap(Map<String, dynamic> map) {
    return StripeAuthorizationResponse(
      authorizeUrl: map['authorizeUrl'],
      redirectUrl: map['redirectUrl'],
      refreshUrl: map['refreshUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorizeUrl': authorizeUrl,
      'redirectUrl': redirectUrl,
      'refreshUrl': refreshUrl,
    };
  }
}

class StripeService {
  static Future<StripeAuthorizationResponse> authorizeUrl(
      AppConfig config) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: config.region)
            .httpsCallable('stripeAuthorize');
    final result = await callable.call();
    return StripeAuthorizationResponse.fromMap(asStringKeyedMap(result.data)!);
  }

  static Stream<UserPaymentProvider?> getPaymentProviderStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('payment_settings')
        .doc(uid)
        .collection('providers')
        .doc(STRIPE_PROVIDER_ID)
        .snapshots()
        .map<UserPaymentProvider?>((DocumentSnapshot snapshot) {
      if (!snapshot.exists) return null;
      final map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return UserPaymentProvider.fromMap(map);
    });
  }

  static Future<void> disconnect(AppConfig config) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: config.region)
            .httpsCallable('stripeDisconnect');
    await callable.call();
  }

  static Future<void> connect(AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('stripeConnect');
      await callable.call();
    } catch (error) {
      print("error a: $error");
      throw mapToStripeException(error);
    }
  }

  static Future<CardSetup> setupCards(AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('stripeSetupCard');
      final result = await callable.call();
      return CardSetup.fromMap(asStringKeyedMap(result.data)!);
    } catch (error) {
      print("error a: $error");
      throw mapToStripeException(error);
    }
  }

  static Future<void> savePaymentMethod(
      String paymentMethodId, AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('stripeSavePaymentMethod');
      await callable.call({'paymentMethodId': paymentMethodId});
    } catch (error) {
      print("error a: $error");
      throw mapToStripeException(error);
    }
  }

  static Future<void> removePaymentMethod(
      String? paymentMethodId, AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('stripeRemovePaymentMethod');
      await callable.call({'paymentMethodId': paymentMethodId});
    } catch (error) {
      print("error a: $error");
      throw mapToStripeException(error);
    }
  }

  static Future<void> setDefaultPaymentMethod(
      String? paymentMethodId, AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('stripeSetDefaultPaymentMethod');
      await callable.call({'paymentMethodId': paymentMethodId});
    } catch (error) {
      print("error a: $error");
      throw mapToStripeException(error);
    }
  }

  static StripeConnectException mapToStripeException(Object exception) {
    if (exception is FirebaseFunctionsException) {
      if (exception.details != null) {
        return StripeConnectException.fromMap(
            asStringKeyedMap(exception.details)!);
      }
      return StripeConnectException(StripeExceptionCode.Unknown);
    } else {
      return StripeConnectException(StripeExceptionCode.Unknown);
    }
  }

  static Future<Checkout> getChekout(
      String successUrl, String cancelUrl, AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('stripeCheckoutSavePaymentMethod');
      final result = await callable
          .call({'successUrl': successUrl, 'cancelUrl': cancelUrl});
      return Checkout.fromMap(asStringKeyedMap(result.data)!);
    } on FirebaseFunctionsException catch (error) {
      print('error: $error');
      throw mapToStripeException(error);
    } catch (error) {
      print('error: $error');
      throw StripeConnectException.unknown();
    }
  }
}
