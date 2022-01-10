@JS()
library solana_web;

import 'dart:async';
import 'dart:typed_data';
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:solana/solana.dart';
// ignore: avoid_web_libraries_in_flutter
import 'interface.dart' as inter;

@JS('solanaWeb.Transaction.from')
external Transaction fromTransaction(dynamic buffer);
@JS('solanaWeb.Transaction.populate')
external Transaction populateTransaction(
    Message message, List<String> signatures);
@JS('solanaWeb.PublicKey.findProgramAddress')
external dynamic findProgramAddress(List<Buffer> seeds, PublicKey programId);

@JS('solanaWeb.WalletServiceClient')
class WalletServiceClient {
  external factory WalletServiceClient(String rpcUrl);
  external TransferOutputJS createTransferBetweenSplTokenAccounts(
      CreateAndTransferToAccountInputJS params);
  external dynamic createAndTransferToAccount(
      CreateAndTransferToAccountInputJS params); //promise to future
  external dynamic createAssociatedTokenAccount(
      CreateAssociatedTokenInputJS params);
  external TransferOutputJS nativeTransferTx(NativeTransferInputJS params);

  external dynamic initializeSwapTransaction(SwapTxInputJS params);
}

@JS()
@anonymous
class SigJS {
  external String pubKey;
  external String? signature;
}

@JS()
@anonymous
class InitializeSwapOutputJS {
  external String message;
  external List<String> signatures;
  external factory InitializeSwapOutputJS({
    required String message,
    required List<String> signatures,
  });
}

@JS()
@anonymous
class SwapExchangeRateJS {
  external String rate;
  external num fromDecimals;
  external num quoteDecimals;
  external bool strict;
  external factory SwapExchangeRateJS({
    required String rate,
    required num fromDecimals,
    required num fromWalletAddress,
    required bool strict,
  });
}

@JS()
@anonymous
class SwapTxInputJS {
  external factory SwapTxInputJS({
    required String walletAddress,
    required String amount,
    required String? fromWalletAddress,
    required String? toWalletAddress,
    String? quoteWalletAddress,
    required String fromMintAddress,
    required String toMintAddress,
    required String quoteMintAddress,
    required SwapExchangeRateJS minExchangeRate,
    String? minExpectedSwapAmount,
    required String fromMarketAddress,
    String? toMarketAddress,
    required String recentBlockhash,
    String? memo,
  });
  external String walletAddress;
  external String amount;
  external String? fromWalletAddress;
  external String? toWalletAddress;
  external String? quoteWalletAddress;
  external String fromMintAddress;
  external String toMintAddress;
  external String quoteMintAddress;
  external SwapExchangeRateJS minExchangeRate;
  external String minExpectedSwapAmount;
  external String fromMarketAddress;
  external String? toMarketAddress;
  external String recentBlockhash;
  external String? memo;
}

@JS()
@anonymous
class CreateAndTransferToAccountInputJS {
  external factory CreateAndTransferToAccountInputJS(
      {required String walletAddress,
      required String tokenMintAddress,
      required String sourcePublicKey,
      required String destinationPublicKey,
      required String amount,
      required String recentBlockhash,
      String? memo});
  external String walletAddress;
  external String tokenMintAddress;
  external String sourcePublicKey;
  external String destinationPublicKey;
  external String amount;
  external String recentBlockhash;
  external String? memo;
}

@JS()
@anonymous
class NativeTransferInputJS {
  external String walletAddress;
  external String destinationPublicKey;
  external String recentBlockhash;
  external String amount;

  external factory NativeTransferInputJS(
      {required String walletAddress,
      required String destinationPublicKey,
      required String recentBlockhash,
      required String amount});
}

@JS()
@anonymous
class CreateAssociatedTokenInputJS {
  external String walletAddress;
  external String tokenMintAddress;
  external String recentBlockhash;
  external factory CreateAssociatedTokenInputJS({
    required String walletAddress,
    required String tokenMintAddress,
    required String recentBlockhash,
  });
}

@JS()
@anonymous
class CreateAssociatedTokenOutputJS {
  external String address;
  external String message;
  external String signatures;
  external factory CreateAssociatedTokenOutputJS({
    required String address,
    required String message,
    required String signatures,
  });
}

@JS()
@anonymous
class TransferOutputJS {
  external String message;
  external List<String> signatures;
  external factory TransferOutputJS({
    required String message,
    required String signatures,
  });
}

@JS('solanaWeb.Transaction')
class Transaction {
  external Buffer serializeMessage();
  external List<SignaturePubkeyPair> signatures;
}

@JS()
@anonymous
class SignaturePubkeyPair {
  external Buffer? signature;
  external PublicKey publicKey;
}

@JS()
@anonymous
class SignaturePubkeyString {
  external String signature;
  external String publicKey;
}

@JS()
@anonymous
class Message {
  external Buffer serialize();
}

@JS()
@anonymous
class Buffer {
  external String toString();
  external BufferJson toJSON();
}

@JS()
@anonymous
class BufferJson {
  external String type;
  external List<int> data;
}

@JS('solanaWeb.PublicKey')
class PublicKey {
  external factory PublicKey(String address);
  external Uint8List toBytes();
  external String toString();
  external Buffer toBuffer();
  external bool equals(PublicKey publicKey);
}

@JS()
@anonymous
class SignatureResponse {
  external PublicKey publicKey;
  external Buffer signature;
}

Future<String> findAssociatedTokenAddress(
    String walletAddress, String tokenMintAddress) async {
  final promise = await findProgramAddress(
    [
      PublicKey(walletAddress).toBuffer(),
      PublicKey(TokenProgram.programId).toBuffer(),
      PublicKey(tokenMintAddress).toBuffer(),
    ],
    PublicKey(AssociatedTokenAccountProgram.programId),
  );
  final result = await promiseToFuture(promise);
  final PublicKey key = result[0];
  return key.toString();
}

inter.SolanaClientHelper createSolanaClientHelper(String rpcUrl,
    {String? region}) {
  return SolanaClientHelperWeb(rpcUrl);
}

class SolanaClientHelperWeb implements inter.SolanaClientHelper {
  final WalletServiceClient client;

  SolanaClientHelperWeb(String rpcUrl) : client = WalletServiceClient(rpcUrl);

  @override
  Future<inter.TransferOutput> createAndTransferToAccount(
      inter.CreateAndTransferToAccountInput params) async {
    final TransferOutputJS result = await promiseToFuture(
      client.createAndTransferToAccount(
        CreateAndTransferToAccountInputJS(
            walletAddress: params.walletAddress,
            tokenMintAddress: params.tokenMintAddress,
            sourcePublicKey: params.sourcePublicKey,
            destinationPublicKey: params.destinationPublicKey,
            amount: params.amount,
            recentBlockhash: params.recentBlockhash,
            memo: params.memo),
      ),
    );
    return inter.TransferOutput(message: result.message);
  }

  @override
  Future<inter.CreateAssociatedTokenOutput> createAssociatedToken(
      inter.CreateAssociatedTokenInput params) async {
    final CreateAssociatedTokenOutputJS result = await promiseToFuture(
      client.createAssociatedTokenAccount(
        CreateAssociatedTokenInputJS(
            walletAddress: params.walletAddress,
            tokenMintAddress: params.tokenMintAddress,
            recentBlockhash: params.recentBlockhash),
      ),
    );
    return inter.CreateAssociatedTokenOutput(
      address: result.address,
      message: result.message,
    );
  }

  @override
  Future<List<inter.InitializeSwapOutput>> initializeSwapTransaction(
      inter.SwapTxInput params) async {
    final result = await promiseToFuture<List<dynamic>>(
      client.initializeSwapTransaction(
        SwapTxInputJS(
          walletAddress: params.walletAddress,
          amount: params.amount,
          fromWalletAddress: params.fromWalletAddress,
          toWalletAddress: params.toWalletAddress,
          quoteWalletAddress: params.quoteWalletAddress,
          fromMintAddress: params.fromMintAddress,
          toMintAddress: params.toMintAddress,
          quoteMintAddress: params.quoteMintAddress,
          minExchangeRate: SwapExchangeRateJS(
              fromDecimals: params.minExchangeRate.fromDecimals,
              fromWalletAddress: params.minExchangeRate.fromDecimals,
              rate: params.minExchangeRate.rate,
              strict: params.minExchangeRate.strict),
          minExpectedSwapAmount: params.minExpectedSwapAmount,
          fromMarketAddress: params.fromMarketAddress,
          toMarketAddress: params.toMarketAddress,
          recentBlockhash: params.recentBlockhash,
          memo: params.memo,
        ),
      ),
    );
    return result.map((e) {
      final ret = e as InitializeSwapOutputJS;
      return inter.InitializeSwapOutput(
          message: ret.message, signatures: ret.signatures);
    }).toList();
  }

  @override
  inter.TransferOutput createTransferBetweenSplTokenAccounts(
      inter.CreateAndTransferToAccountInput params) {
    final TransferOutputJS result =
        client.createTransferBetweenSplTokenAccounts(
      CreateAndTransferToAccountInputJS(
          walletAddress: params.walletAddress,
          tokenMintAddress: params.tokenMintAddress,
          sourcePublicKey: params.sourcePublicKey,
          destinationPublicKey: params.destinationPublicKey,
          amount: params.amount,
          recentBlockhash: params.recentBlockhash,
          memo: params.memo),
    );
    return inter.TransferOutput(message: result.message);
  }

  @override
  inter.TransferOutput createNativeTransfer(inter.NativeTransferInput params) {
    final TransferOutputJS result = client.nativeTransferTx(
      NativeTransferInputJS(
        walletAddress: params.walletAddress,
        destinationPublicKey: params.destinationPublicKey,
        amount: params.amount,
        recentBlockhash: params.recentBlockhash,
      ),
    );
    return inter.TransferOutput(message: result.message);
  }
}
