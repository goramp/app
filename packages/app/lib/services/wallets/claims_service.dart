import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/utils/index.dart';
import 'package:solana/solana.dart';

enum ClaimExceptionCode {
  ClaimNotFound,
  ClaimAlreadyClaimed,
  ClaimProcessing,
  ClaimExpired,
  ClaimInvalid,
  ClaimWalletNotFound,
  ClaimWalletInvalid,
  ClaimProcessingError,
  Unknown, //unknown
}

class ClaimException implements Exception {
  final ClaimExceptionCode code;
  final String? message;
  ClaimException(this.code, {this.message = StringResources.UNKNOWN_ERROR});

  factory ClaimException.fromMap(Map<String, dynamic> map) {
    return ClaimException(
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

  static ClaimExceptionCode mapToWalletException(String? code) {
    switch (code) {
      case 'claims/not_found':
        return ClaimExceptionCode.ClaimNotFound;
      case 'claims/already_claimed':
        return ClaimExceptionCode.ClaimAlreadyClaimed;
      case 'claims/processiing':
        return ClaimExceptionCode.ClaimProcessing;
      case 'claims/expired':
        return ClaimExceptionCode.ClaimExpired;
      case 'claims/invalid':
        return ClaimExceptionCode.ClaimInvalid;
      case 'claims/wallet_not_found':
        return ClaimExceptionCode.ClaimWalletNotFound;
      case 'claims/wallet_invalid':
        return ClaimExceptionCode.ClaimWalletInvalid;
      case 'claims/processing_error':
        return ClaimExceptionCode.ClaimProcessingError;
      default:
        return ClaimExceptionCode.Unknown;
    }
  }

  String toString() {
    return '${toMap()}';
  }
}

class ClaimService {
  final AppConfig config;
  final RPCClient client;

  bool configured = false;

  ClaimService({required this.config, required this.client});

  static ClaimException mapToWalletException(Exception exception) {
    if (exception is FirebaseFunctionsException) {
      if (exception.details != null) {
        return ClaimException.fromMap(asStringKeyedMap(exception.details)!);
      }
      return ClaimException(ClaimExceptionCode.Unknown);
    } else {
      return ClaimException(ClaimExceptionCode.Unknown);
    }
  }

  Future<void> claim(String claimId, {String? walletAddress}) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region).httpsCallable(
              'solClaim',
              options:
                  HttpsCallableOptions(timeout: const Duration(seconds: 540)));

      await callable.call({'claimId': claimId, 'walletAddress': walletAddress});
    } on FirebaseFunctionsException catch (error) {
      print('error: $error');
      throw mapToWalletException(error);
    } catch (error) {
      print('ERROR: $error');
      throw ClaimException(
        ClaimExceptionCode.Unknown,
        message: error.toString(),
      );
    }
  }
}
