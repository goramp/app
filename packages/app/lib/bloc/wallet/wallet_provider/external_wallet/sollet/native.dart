import 'package:goramp/bloc/wallet/wallet_provider/index.dart';
import 'package:solana/src/encoder/signature.dart';
import 'interface.dart';

class SolletWalletProvider extends WalletProvider {
  SolletWalletProvider({SolletWalletAdapterConfig? config});

  static bool hasInstalledProvider() => false;
  @override
  // TODO: implement autoApprove
  bool get autoApprove => throw UnimplementedError();

  @override
  Future<void> connect() {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  // TODO: implement connected
  bool get connected => throw UnimplementedError();

  @override
  // TODO: implement connecting
  bool get connecting => throw UnimplementedError();

  @override
  Future<void> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  // TODO: implement errorDescription
  String? get errorDescription => throw UnimplementedError();

  @override
  Future<Signature> sign(List<int> message, {String? display}) {
    // TODO: implement sign
    throw UnimplementedError();
  }

  @override
  Future<List<Signature>> signAllTransactions(List<List<int>> transactions) {
    // TODO: implement signAllTransactions
    throw UnimplementedError();
  }

  @override
  Future<Signature> signTransaction(List<int> transaction) {
    // TODO: implement signTransaction
    throw UnimplementedError();
  }

  @override
  // TODO: implement publicKey
  String? get publicKey => throw UnimplementedError();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  // TODO: implement iconUrl
  String get iconUrl => throw UnimplementedError();

  @override
  // TODO: implement ready
  bool get ready => throw UnimplementedError();

  @override
  // TODO: implement keypair
  get keypair => throw UnimplementedError();
}
