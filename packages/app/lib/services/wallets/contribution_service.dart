import 'dart:async';
import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:solana/solana.dart';

enum ContributionExceptionCode {
  ContributionNotFound,
  ContributionNotStarted,
  ContributionEnded,
  ContributionInvalidAmount,
  ContributionAmountOverflow,
  ContributionMaxUserAmountOverflow,
  InvalidSignatures,
  TransactionFailure,
  OrderExpired,
  OrderInProgress,
  DuplicateOrder,
  InsufficientFunds,
  InvalidWalletAddress,
  InvalidTransaction,
  TokenNotFound,
  Unavailable,
  Unknown, //unknown
}

class ContributionException implements Exception {
  final ContributionExceptionCode code;
  final String? message;
  ContributionException(this.code,
      {this.message = StringResources.UNKNOWN_ERROR});

  factory ContributionException.fromMap(Map<String, dynamic> map) {
    return ContributionException(
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

  static ContributionExceptionCode mapToWalletException(String? code) {
    switch (code) {
      case 'contributions/not_found':
        return ContributionExceptionCode.ContributionNotFound;
      case 'contributions/not_started':
        return ContributionExceptionCode.ContributionNotStarted;
      case 'contributions/ended':
        return ContributionExceptionCode.ContributionEnded;
      case 'contributions/invalid_amount':
        return ContributionExceptionCode.ContributionInvalidAmount;
      case 'contributions/amount_overflow':
        return ContributionExceptionCode.ContributionAmountOverflow;
      case 'contributions/max_user_amount_overflow':
        return ContributionExceptionCode.ContributionMaxUserAmountOverflow;
      case 'order_payment/invalid_signatures':
        return ContributionExceptionCode.InvalidSignatures;
      case 'contributions/insufficient_funds':
        return ContributionExceptionCode.InsufficientFunds;
      case 'contributions/invalid_wallet_address':
        return ContributionExceptionCode.InvalidWalletAddress;
      case 'contributions/token_not_found':
        return ContributionExceptionCode.TokenNotFound;
      case 'contributions/invalid_transaction':
        return ContributionExceptionCode.InvalidTransaction;
      case 'contributions/unavailable':
        return ContributionExceptionCode.Unavailable;

      default:
        return ContributionExceptionCode.Unknown;
    }
  }

  String toString() {
    return '${toMap()}';
  }
}

class ContributionsService {
  final AppConfig config;
  final WalletProvider wallet;
  final RPCClient client;

  bool configured = false;

  ContributionsService(
      {required this.config, required this.wallet, required this.client});

  static ContributionException mapToWalletException(Exception exception) {
    if (exception is FirebaseFunctionsException) {
      if (exception.details != null) {
        return ContributionException.fromMap(
            asStringKeyedMap(exception.details)!);
      }
      return ContributionException(ContributionExceptionCode.Unknown);
    } else {
      return ContributionException(ContributionExceptionCode.Unknown);
    }
  }

  Future<void> claim() async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region).httpsCallable(
              'solClaimContributionTx',
              options:
                  HttpsCallableOptions(timeout: const Duration(seconds: 540)));

      await callable.call();
    } on FirebaseFunctionsException catch (error) {
      print('error: $error');
      throw mapToWalletException(error);
    } catch (error) {
      print('ERROR: $error');
      throw ContributionException(
        ContributionExceptionCode.Unknown,
        message: error.toString(),
      );
    }
  }

  Future<void> deposit(num amount, String contributionId) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region).httpsCallable(
              'solInitDepositTx',
              options:
                  HttpsCallableOptions(timeout: const Duration(seconds: 540)));
      final params = {
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
              return await wallet.sign(message);
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
          .httpsCallable(
              'solSendDepositTx',
              options:
                  HttpsCallableOptions(timeout: const Duration(seconds: 540)));
      await callable.call(rawTransaction.encode());
    } on FirebaseFunctionsException catch (error) {
      print('error: $error');
      throw mapToWalletException(error);
    } catch (error) {
      print('ERROR: $error');
      throw ContributionException(
        ContributionExceptionCode.Unknown,
        message: error.toString(),
      );
    }
  }
}
