import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:goramp/utils/index.dart';
import 'package:solana/solana.dart';
import 'interface.dart' as inter;

Future<String> findAssociatedTokenAddress(
    String walletAddress, String tokenMintAddress) async {
  final result = await findProgramAddress(
    seeds: [
      Buffer.fromBase58(walletAddress),
      Buffer.fromBase58(TokenProgram.programId),
      Buffer.fromBase58(tokenMintAddress),
    ],
    programId: AssociatedTokenAccountProgram.programId,
  );
  return result[0];
}

inter.SolanaClientHelper createSolanaClientHelper(String rpcUrl,
    {String? region}) {
  return SolanaClientHelperNative(rpcUrl, region: region);
}

class SolanaClientHelperNative implements inter.SolanaClientHelper {
  RPCClient client;
  final String? region;
  SolanaClientHelperNative(String rpcUrl, {this.region})
      : client = RPCClient(rpcUrl);

  @override
  Future<inter.TransferOutput> createAndTransferToAccount(
      inter.CreateAndTransferToAccountInput params) async {
    final associatedTokenAddress = await findAssociatedTokenAddress(
      params.walletAddress,
      params.tokenMintAddress,
    );
    const space = TokenProgram.neededAccountSpace;
    final rent = await client.getMinimumBalanceForRentExemption(space);
    final walletAddress = params.walletAddress as Ed25519HDKeyPair;
    final program = TokenProgram.createAccount(
      address: associatedTokenAddress,
      owner: walletAddress.address,
      mint: params.tokenMintAddress,
      rent: rent,
      space: space,
    );
    program.instructions.add(
      TokenInstruction.transfer(
        source: params.sourcePublicKey,
        destination: associatedTokenAddress,
        owner: walletAddress.address,
        amount: int.parse(params.amount),
      ),
    );
    final compiledMessage = program.compile(
        recentBlockhash: params.recentBlockhash, feePayer: walletAddress);
    return inter.TransferOutput(
      message: base64Encode(compiledMessage.data.toList()),
    );
  }

  @override
  Future<inter.CreateAssociatedTokenOutput> createAssociatedToken(
      inter.CreateAssociatedTokenInput params) async {
    final associatedTokenAddress = await findAssociatedTokenAddress(
      params.walletAddress,
      params.tokenMintAddress,
    );
    const space = TokenProgram.neededAccountSpace;
    final rent = await client.getMinimumBalanceForRentExemption(space);
    final walletAddress = params.walletAddress as Ed25519HDKeyPair;
    final program = TokenProgram.createAccount(
      address: associatedTokenAddress,
      owner: walletAddress.address,
      mint: params.tokenMintAddress,
      rent: rent,
      space: space,
    );
    final compiledMessage = program.compile(
        recentBlockhash: params.recentBlockhash, feePayer: walletAddress);

    return inter.CreateAssociatedTokenOutput(
      address: associatedTokenAddress,
      message: base64Encode(compiledMessage.data.toList()),
    );
  }

  @override
  Future<List<inter.InitializeSwapOutput>> initializeSwapTransaction(
      inter.SwapTxInput params) async {
    HttpsCallable callable = FirebaseFunctions.instanceFor(region: region)
        .httpsCallable('solSwapTx');
    final walletAddress = params.walletAddress as Ed25519HDKeyPair;
    final data = {
      'walletAddress': walletAddress.address,
      'fromWalletAddress': params.fromWalletAddress,
      'toWalletAddress': params.toWalletAddress,
      'quoteWalletAddress': params.quoteWalletAddress,
      'fromMintAddress': params.fromMintAddress,
      'toMintAddress': params.toMintAddress,
      'quoteMintAddress': params.quoteMintAddress,
      'fromMarketAddress': params.fromMarketAddress,
      'toMarketAddress': params.toMarketAddress,
      'minExpectedSwapAmount': params.minExpectedSwapAmount,
      'minExchangeRate': {
        'quoteMintAddress': params.quoteMintAddress,
        'fromDecimals': params.minExchangeRate.fromDecimals,
        'quoteDecimals': params.minExchangeRate.quoteDecimals,
        'rate': params.minExchangeRate.rate,
        'strict': params.minExchangeRate.strict,
      },
      'amount': params.amount,
      'recentBlockhash': params.recentBlockhash,
      'memo': params.memo,
    };
    var result = await callable.call(data,);

    return await Future.wait(
      (result.data as List).map(
        (data) async {
          final response = asStringKeyedMap(data)!;
          return inter.InitializeSwapOutput(
              message: response['message'],
              signatures: (response['signatures'] as List)
                  .map((sig) => sig as String)
                  .toList());
        },
      ),
    );
  }

  @override
  inter.TransferOutput createTransferBetweenSplTokenAccounts(
      inter.CreateAndTransferToAccountInput params) {
    final walletAddress = params.walletAddress as Ed25519HDKeyPair;
    final program = TokenProgram.transfer(
        source: params.sourcePublicKey,
        destination: params.destinationPublicKey,
        owner: walletAddress.address,
        amount: int.parse(params.amount));

    final compiledMessage = program.compile(
        recentBlockhash: params.recentBlockhash, feePayer: walletAddress);
    return inter.TransferOutput(
      message: base64Encode(compiledMessage.data.toList()),
    );
  }

  @override
  inter.TransferOutput createNativeTransfer(inter.NativeTransferInput params) {
    final walletAddress = params.walletAddress as Ed25519HDKeyPair;
    final instructions = [
      SystemInstruction.transfer(
        source: walletAddress.address,
        destination: params.destinationPublicKey,
        lamports: int.parse(params.amount),
      ),
      //if (params.memo != null) MemoInstruction(signers: [source], memo: memo),
    ];

    final message = Message(
      instructions: instructions,
    );

    final compiledMessage = message.compile(
        recentBlockhash: params.recentBlockhash, feePayer: walletAddress);
    return inter.TransferOutput(
      message: base64Encode(compiledMessage.data.toList()),
    );
  }
}
