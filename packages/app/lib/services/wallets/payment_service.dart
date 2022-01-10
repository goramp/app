import 'dart:async';
import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/utils/index.dart';
import 'package:solana/solana.dart';

enum WalletPaymentExceptionCode {
  OrderNotFound,
  PaymentMethodNotFound,
  CallLinkNotFound,
  CallLinkAlreadyConfirmed,
  CallLinkExpired,
  CallLinkCanceled,
  InvalidSignatures,
  TransactionFailure,
  OrderExpired,
  OrderInProgress,
  DuplicateOrder,
  InsufficientFunds,
  Unknown, //unknown
}

class WalletPaymentException implements Exception {
  final WalletPaymentExceptionCode code;
  final String? message;
  WalletPaymentException(this.code,
      {this.message = StringResources.UNKNOWN_ERROR});

  factory WalletPaymentException.fromMap(Map<String, dynamic> map) {
    return WalletPaymentException(
      mapToWalletException(map['code']),
      message: map['errorMessage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'errorMessage': message,
    };
  }

  static WalletPaymentExceptionCode mapToWalletException(String? code) {
    switch (code) {
      case 'order_payment/order_not_found':
        return WalletPaymentExceptionCode.OrderNotFound;
      case 'order_payment/payment_method_not_found':
        return WalletPaymentExceptionCode.PaymentMethodNotFound;
      case 'order_payment/call_link_not_found':
        return WalletPaymentExceptionCode.CallLinkNotFound;
      case 'order_payment/call_link_already_confirmed':
        return WalletPaymentExceptionCode.CallLinkAlreadyConfirmed;
      case 'order_payment/call_link_expired':
        return WalletPaymentExceptionCode.CallLinkExpired;
      case 'order_payment/call_link_canceled':
        return WalletPaymentExceptionCode.CallLinkCanceled;
      case 'order_payment/invalid_signatures':
        return WalletPaymentExceptionCode.InvalidSignatures;
      case 'order_payment/transaction_failed':
        return WalletPaymentExceptionCode.TransactionFailure;
      case 'order_payment/expired':
        return WalletPaymentExceptionCode.OrderExpired;
      case 'order_payment/duplicate':
        return WalletPaymentExceptionCode.DuplicateOrder;
      case 'order_payment/in_progress':
        return WalletPaymentExceptionCode.OrderInProgress;
      case 'order_payment/insufficient_funds':
        return WalletPaymentExceptionCode.InsufficientFunds;
      default:
        return WalletPaymentExceptionCode.Unknown;
    }
  }

  String toString() {
    return '${toMap()}';
  }
}

class WalletPaymentService {
  final AppConfig config;
  final WalletProvider wallet;
  final RPCClient client;

  bool configured = false;

  WalletPaymentService(
      {required this.config, required this.wallet, required this.client});

  Future<void> orderPayment(Order order, TokenAccount account) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region).httpsCallable(
              'solInitOrderPaymentTx',
              options:
                  HttpsCallableOptions(timeout: const Duration(seconds: 540)));
      final params = {
        'orderId': order.id,
        'walletAddress': wallet.publicKey,
        'tokenAccountAddress': account.address,
        'coin': account.token!.tokenSymbol,
        'tokenMintAddress': account.token!.mintAddress == NATIVE_SOL.mintAddress
            ? WSOL.mintAddress
            : account.token!.mintAddress
      };
      var result = await callable.call(params);
      final response = asStringKeyedMap(result.data)!;
      final message = base64Decode(response['message']);
      List<Map<String, dynamic>?> signatures =
          (response['signatures'] as List<dynamic>)
              .map((signature) => asStringKeyedMap(signature))
              .toList();
      final signatureList = await Future.wait(
        signatures.map<Future<Signature>>(
          (sig) async {
            if (sig!['pubKey'] == wallet.publicKey) {
              return Signature.fromBytes((await wallet.sign(message)).toList());
            } else {
              return Signature.fromBytes(
                  base64Decode(sig['signature'] as String));
            }
          },
        ),
      );
      final rawTransaction = SignedTx(
        signatures: signatureList,
        messageBytes: message,
      );

      callable = FirebaseFunctions.instanceFor(region: config.region)
          .httpsCallable('solSendOrderPaymentTx', options: HttpsCallableOptions(timeout: Duration(seconds: 540)));
      await callable.call(rawTransaction.encode());
    } on FirebaseFunctionsException catch (error) {
      print('error: $error');
      throw mapToWalletException(error);
    } catch (error) {
      print('ERROR: $error');
      throw WalletPaymentException(
        WalletPaymentExceptionCode.Unknown,
        message: error.toString(),
      );
    }
  }

  static WalletPaymentException mapToWalletException(Exception exception) {
    if (exception is FirebaseFunctionsException) {
      print('Exception Details:${exception.details}');
      if (exception.details != null) {
        return WalletPaymentException.fromMap(
            asStringKeyedMap(exception.details)!);
      }
      return WalletPaymentException(WalletPaymentExceptionCode.Unknown);
    } else {
      return WalletPaymentException(WalletPaymentExceptionCode.Unknown);
    }
  }

  Future<void> deposit(TokenAccount source, TokenAccount destination,
      num amount, String contributionId) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('solInitConversion');
      final params = {
        'source': source.token!.tokenSymbol!,
        'destination': destination.token!.tokenSymbol!,
        'amount': amount,
        'contributionId': contributionId,
      };
      var result = await callable.call(params);
      final response = asStringKeyedMap(result.data)!;
      final message = base64Decode(response['message']);
      List<Map<String, dynamic>?> signatures =
          (response['signatures'] as List<dynamic>)
              .map((signature) => asStringKeyedMap(signature))
              .toList();
      final signatureList = await Future.wait(
        signatures.map<Future<Signature>>(
          (sig) async {
            if (sig!['pubKey'] == wallet.publicKey) {
              return Signature.fromBytes(
                  (await wallet.signTransaction(message)).toList());
            } else {
              return Signature.fromBytes(
                  base64Decode(sig['signature'] as String));
            }
          },
        ),
      );
      final rawTransaction = SignedTx(
        signatures: signatureList,
        messageBytes: message,
      );

      callable = FirebaseFunctions.instanceFor(region: config.region)
          .httpsCallable('solSendConversionTx');
      await callable.call(rawTransaction.encode());
    } on FirebaseFunctionsException catch (error) {
      print('error: $error');
      throw mapToWalletException(error);
    } catch (error) {
      print('ERROR: $error');
      throw WalletPaymentException(
        WalletPaymentExceptionCode.Unknown,
        message: error.toString(),
      );
    }
  }
}
