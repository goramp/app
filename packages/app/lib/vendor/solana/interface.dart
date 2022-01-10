class Sig {
  final String pubKey;
  final String? signature;
  Sig({required this.pubKey, this.signature});
}

class InitializeSwapOutput {
  final String message;
  final List<String> signatures;
  InitializeSwapOutput({required this.message, required this.signatures});
}

class SwapExchangeRate {
  final String rate;
  final num fromDecimals;
  final num quoteDecimals;
  final bool strict;
  SwapExchangeRate(
      {required this.rate,
      required this.fromDecimals,
      required this.quoteDecimals,
      this.strict = true});
}

class SwapTxInput {
  final dynamic walletAddress;
  final String amount;
  final String? fromWalletAddress;
  final String? toWalletAddress;
  final String? quoteWalletAddress;
  final String fromMintAddress;
  final String toMintAddress;
  final String quoteMintAddress;
  final SwapExchangeRate minExchangeRate;
  final String minExpectedSwapAmount;
  final String fromMarketAddress;
  final String? toMarketAddress;
  final String recentBlockhash;
  final String? memo;

  SwapTxInput({
    required this.walletAddress,
    required this.amount,
    this.fromWalletAddress,
    this.toMarketAddress,
    this.quoteWalletAddress,
    required this.fromMarketAddress,
    required this.fromMintAddress,
    required this.toMintAddress,
    required this.minExchangeRate,
    required this.minExpectedSwapAmount,
    required this.quoteMintAddress,
    this.toWalletAddress,
    required this.recentBlockhash,
    this.memo,
  });
}

class CreateAndTransferToAccountInput {
  final dynamic walletAddress;
  final String tokenMintAddress;
  final String sourcePublicKey;
  final String destinationPublicKey;
  final String amount;
  final String recentBlockhash;
  final String? memo;
  CreateAndTransferToAccountInput(
      {required this.walletAddress,
      required this.tokenMintAddress,
      required this.sourcePublicKey,
      required this.destinationPublicKey,
      required this.amount,
      required this.recentBlockhash,
      this.memo});
}

class NativeTransferInput {
  final dynamic walletAddress;
  final String destinationPublicKey;
  final String recentBlockhash;
  final String amount;
  NativeTransferInput(
      {required this.walletAddress,
      required this.destinationPublicKey,
      required this.recentBlockhash,
      required this.amount});
}

class CreateAssociatedTokenInput {
  final dynamic walletAddress;
  final String tokenMintAddress;
  final String recentBlockhash;
  CreateAssociatedTokenInput(
      {required this.walletAddress,
      required this.tokenMintAddress,
      required this.recentBlockhash});
}

class CreateAssociatedTokenOutput {
  final String address;
  final String message;
  CreateAssociatedTokenOutput({required this.address, required this.message});
}

class TransferOutput {
  final String message;
  TransferOutput({required this.message});
}

abstract class SolanaClientHelper {
  TransferOutput createTransferBetweenSplTokenAccounts(
      CreateAndTransferToAccountInput params);

  Future<TransferOutput> createAndTransferToAccount(
      CreateAndTransferToAccountInput params); //promise to future\

  Future<CreateAssociatedTokenOutput> createAssociatedToken(
      CreateAssociatedTokenInput params);

  Future<List<InitializeSwapOutput>> initializeSwapTransaction(
      SwapTxInput params);

  TransferOutput createNativeTransfer(NativeTransferInput params);
}
