import 'dart:typed_data';

import 'package:browser_adapter/browser_adapter.dart';
import 'package:goramp/bloc/wallet/wallet_provider/external_wallet/phantom/index.dart';
import 'package:goramp/bloc/wallet/wallet_provider/external_wallet/sollet/index.dart';
import 'package:goramp/utils/event_emitter.dart';
import 'package:goramp/utils/index.dart';
import 'package:solana/solana.dart';
import 'package:universal_platform/universal_platform.dart';

enum WalletProviderExceptionCode {
  TimeoutError,
  WindowClosedError,
  WindowBlockedError,
  NotConnectedError,
  DisconnectedError,
  ConnectionError,
  NotFoundError,
  SignMessageError,
  Unknown, //unknown
}

class WalletProviderException implements Exception {
  final WalletProviderExceptionCode code;
  final String? message;
  final WalletProvider provider;
  WalletProviderException(this.provider, this.code,
      {this.message = StringResources.UNKNOWN_ERROR});

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'provider': provider,
    };
  }
}

abstract class WalletProvider extends EventEmitter {
  WalletProvider();
  bool get connected;
  bool get connecting;
  bool get autoApprove;
  String? get errorDescription;
  String? get publicKey;
  dynamic get keypair;
  String get name;
  String get iconUrl;
  bool get ready;

  Future<void> connect();
  Future<void> disconnect();
  Future<Signature> sign(Uint8List message);
  Future<Signature> signTransaction(Uint8List transaction);
  Future<List<Signature>> signAllTransactions(List<Uint8List> transactions);

  static List<WalletProvider> getExternalWalletProviders({String? network}) {
    if (UniversalPlatform.isWeb && isDesktopBrowser()) {
      if (isDesktopBrowser()) {
        return [
          if (PhantomWalletProvider.hasInstalledProvider())
            PhantomWalletProvider(
                config: PhantomWalletAdapterConfig(network: network)),
          if (SolletWalletProvider.hasInstalledProvider())
            SolletWalletProvider(
                config: SolletWalletAdapterConfig(network: network)),
          SolletWalletProvider(
              config: SolletWalletAdapterConfig(
                  network: network, provider: kBaseSolletUrl)),
        ];
      }
      return [
        SolletWalletProvider(
            config: SolletWalletAdapterConfig(
                network: network, provider: kBaseSolletUrl)),
      ];
    }
    return [];
  }
}
