import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/bloc/wallet/wallet_provider/inapp_wallet.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/models/payment_provider.dart';
import 'package:goramp/services/wallets/crypto/index.dart';
import 'package:goramp/vendor/solana/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:solana/solana.dart';
import 'package:torus_firebase_jwt/torus_firebase_jwt.dart';
import 'package:goramp/services/index.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:universal_platform/universal_platform.dart';
import 'encrypt.dart';

enum WalletServiceExceptionCode {
  ZeroLamports,
  AccountNotFound,
  InsufficientFunds,
  MemoNotImplemented,
  UserNotFound,
  Unauthorized,
  ServiceUnavailableInRegion,
  Unknown, //unknown
}

class SignatureResponse {
  final String? address;
  final String? message;
  final List<String>? signatures;

  SignatureResponse({this.message, this.signatures, this.address});
}

class Fee {
  Fee(this.fee, this.blockhash);
  final int fee;
  final String blockhash;
}

class UserKeyPair {
  UserKeyPair(this.userId, this.keyPair);
  final String userId;
  final crypto.KeyPair keyPair;
}

class WalletServiceException implements Exception {
  final WalletServiceExceptionCode code;
  final String? message;
  WalletServiceException(this.code,
      {this.message = StringResources.UNKNOWN_ERROR});

  factory WalletServiceException.fromMap(Map<String, dynamic> map) {
    return WalletServiceException(
      mapToWalletException(map['code']),
      message: map['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
    };
  }

  static WalletServiceExceptionCode mapToWalletException(String? code) {
    switch (code) {
      case 'account_not_found':
        return WalletServiceExceptionCode.AccountNotFound;
      case 'zero_lamports':
        return WalletServiceExceptionCode.ZeroLamports;
      case 'memo_not_implemented':
        return WalletServiceExceptionCode.MemoNotImplemented;
      case 'user_not_found':
        return WalletServiceExceptionCode.UserNotFound;
      case 'user_not_found':
        return WalletServiceExceptionCode.UserNotFound;
      case 'unauthorized':
        return WalletServiceExceptionCode.Unauthorized;
      case 'service_unavailable_in_region':
        return WalletServiceExceptionCode.ServiceUnavailableInRegion;
      default:
        return WalletServiceExceptionCode.Unknown;
    }
  }

  static WalletServiceExceptionCode mapCodeToWalletException(int? code) {
    switch (code) {
      case -32002:
        return WalletServiceExceptionCode.InsufficientFunds;
      default:
        return WalletServiceExceptionCode.Unknown;
    }
  }

  String toString() {
    return '${toMap()}';
  }
}

class WalletServiceAvailability {
  final bool serviceAvailable;
  final List<String> serviceUnavailableRegions;
  final String? country;
  final String? region;
  final String? userIP;

  WalletServiceAvailability(
      {this.serviceAvailable = true,
      this.country,
      this.region,
      this.userIP,
      this.serviceUnavailableRegions = const []});

  factory WalletServiceAvailability.fromMap(Map<String, dynamic> map) {
    return WalletServiceAvailability(
        serviceAvailable: map['serviceAvailable'],
        country: map['country'],
        region: map['region'],
        userIP: map['userIP'],
        serviceUnavailableRegions:
            map['serviceUnavailableRegions'].cast<String>() ?? []);
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceAvailable': serviceAvailable,
      'country': country,
      'region': region,
      'userIP': userIP,
      'serviceUnavailableRegions': serviceUnavailableRegions,
    };
  }

  String toString() {
    return '${toMap()}';
  }
}

class WalletService {
  final AppConfig config;
  final WalletProvider wallet;
  final RPCClient client;
  final SolanaClientHelper clientHelper;
  bool configured = false;

  WalletService(
      {required this.config, required this.wallet, required this.client})
      : clientHelper = createSolanaClientHelper(config.solanaRPCUrl!,
            region: config.region!);

  Future<TransactionSignature> _signAndSendTransaction(
      String messageData, Blockhash blockhash,
      {bool sign = false,
      bool waitForSignature = true,
      List<String> signatures = const []}) async {
    final message = base64Decode(messageData);
    final Signature mySig = await wallet.signTransaction(message);
    final List<Signature> mappedSignatures = signatures
        .map((signature) => Signature.fromBytes(base64Decode(signature)))
        .toList();
    final List<Signature> sigs = [...mappedSignatures, mySig];
    final rawTransaction = SignedTx(
      signatures: sigs,
      messageBytes: message,
    );
    final signature = await client.sendTransaction(rawTransaction.encode());
    if (waitForSignature) {
      await client.waitForSignatureStatus(signature, TxStatus.confirmed);
    }
    //RawSignedTx()
    return signature;
  }

  dynamic get keyOrAddress {
    if (wallet is InAppWalletProvider) {
      final signer = wallet.keypair as Ed25519HDKeyPair;
      return UniversalPlatform.isWeb ? signer.address : signer;
    }
    return wallet.publicKey;
  }

  Future<String?> createAssociatedToken(
    String tokenMintAddress,
  ) async {
    try {
      final recentBlockhash = await client.getRecentBlockhash();
      final result = await clientHelper.createAssociatedToken(
          CreateAssociatedTokenInput(
              walletAddress: keyOrAddress,
              tokenMintAddress: tokenMintAddress,
              recentBlockhash: recentBlockhash.blockhash));
      final address = result.address;
      final signature =
          await _signAndSendTransaction(result.message, recentBlockhash);
      await client.waitForSignatureStatus(signature, TxStatus.finalized);
      return address;
    } on FirebaseFunctionsException catch (error) {
      throw mapToWalletException(error);
    } catch (error) {
      print('ERROR: $error');
      throw WalletServiceException(WalletServiceExceptionCode.Unknown,
          message: error.toString());
    }
  }

  // Future<String?> getAssociatedToken(
  //   List<String> tokenMintAddresses,
  // ) async {
  //   try {
  //     HttpsCallable callable =
  //         FirebaseFunctions.instanceFor(region: config.region)
  //             .httpsCallable('solGetAssociatedTokenAddresses');
  //     final result = await callable.call({
  //       'walletAddress': wallet.publicKey,
  //       'tokenMintAddresses': tokenMintAddresses,
  //     });
  //     final response = asStringKeyedMap(result.data)!;
  //     final addresses = response['addresses'];
  //     final signature = await _signAndSendTransaction(response);
  //     await client.waitForSignatureStatus(signature, TxStatus.finalized);
  //     return address;
  //   } on FirebaseFunctionsException catch (error) {
  //     throw mapToWalletException(error);
  //   } catch (error) {
  //     print('ERROR: $error');
  //     throw WalletServiceException(WalletServiceExceptionCode.Unknown,
  //         message: error.toString());
  //   }
  // }

  Future<Fee> getTransferNetworkFees(String mint) async {
    try {
      var requiredNoOfSigs = 1;
      var rent = 0;
      final recentBlockhash = await client.getRecentBlockhash();
      final fee = (recentBlockhash.feeCalculator.lamportsPerSignature *
              requiredNoOfSigs) +
          rent;
      return Fee(fee, recentBlockhash.blockhash);
    } catch (error, stack) {
      print('Stack: $stack');
      print('ERROR: $error');
      throw WalletServiceException(WalletServiceExceptionCode.Unknown,
          message: error.toString());
    }
  }

  Future<TransactionSignature> transferTokens(String sourcePublicKey,
      String destinationPublicKey, BigInt amount, String mint,
      {String? memo}) async {
    try {
      if (mint == NATIVE_SOL.mintAddress) {
        if (memo != null) {
          throw new WalletServiceException(
              WalletServiceExceptionCode.MemoNotImplemented);
        }
        TransactionSignature signature =
            await transferSol(destinationPublicKey, amount);
        await client.waitForSignatureStatus(signature, TxStatus.finalized);
        return signature;
      }
      final account = await client.getAccountInfo(destinationPublicKey);
      // if (account?.lamports == 0) {
      //   throw WalletServiceException(WalletServiceExceptionCode.ZeroLamports);
      // }
      final tokenInfo = account?.data?.mapOrNull(
        splToken: (token) {
          final tokenAccountInfo = token.parsed;
          if (tokenAccountInfo.info.mint == mint) {
            return tokenAccountInfo.info;
          }
          return null;
        },
      );
      if (tokenInfo != null) {
        TransactionSignature signature = await transferBetweenSplTokenAccounts(
            sourcePublicKey, destinationPublicKey, amount, mint,
            memo: memo);
        await client.waitForSignatureStatus(signature, TxStatus.finalized);
        return signature;
      }
      final accounts = await client.getTokenAccountsByOwner(
        owner: destinationPublicKey,
        programId: TokenProgram.programId,
      );
      final myTokens = accounts
          .where((item) =>
              item.account.data?.maybeMap(
                  splToken: (token) {
                    return token.parsed.info.mint == mint;
                  },
                  orElse: () => false) ??
              false)
          .toList();
      myTokens.sort((a, b) {
        final aAmount = a.account.data!.mapOrNull(splToken: (token) {
              return BigInt.parse(token.parsed.info.tokenAmount.amount);
            }) ??
            BigInt.zero;

        final bAmount = b.account.data!.mapOrNull(splToken: (token) {
              return BigInt.parse(token.parsed.info.tokenAmount.amount);
            }) ??
            BigInt.zero;
        return (aAmount - bAmount).toInt();
      });
      TransactionSignature signature;
      if (myTokens.isNotEmpty) {
        signature = await transferBetweenSplTokenAccounts(
            sourcePublicKey, myTokens.first.address, amount, mint,
            memo: memo);
      } else {
        signature = await createAndTransferToAccount(
            sourcePublicKey, destinationPublicKey, amount, mint,
            memo: memo);
      }
      await client.waitForSignatureStatus(signature, TxStatus.finalized);
      return signature;
    } on FirebaseFunctionsException catch (error, stack) {
      print('ERROR: $error');
      print('Stack: $stack');
      throw mapToWalletException(error);
    } on JsonRpcException catch (error) {
      print('ERROR CODE: ${error.code}');
      print('ERROR MESSAGE: ${error.message}');
      print('ERROR DATA: ${error.data}');
      throw WalletServiceException(
          WalletServiceException.mapCodeToWalletException(error.code),
          message: error.toString());
    } catch (error, stack) {
      print('Stack: $stack');
      print('ERROR: $error');
      throw WalletServiceException(
          WalletServiceException.mapToWalletException(error.toString()),
          message: error.toString());
    }
  }

  Future<TransactionSignature> transferSol(
      String destinationPublicKey, BigInt? amount) async {
    final recentBlockhash = await client.getRecentBlockhash();
    final result = await clientHelper.createNativeTransfer(NativeTransferInput(
        walletAddress: keyOrAddress,
        destinationPublicKey: destinationPublicKey,
        amount: amount.toString(),
        recentBlockhash: recentBlockhash.blockhash));
    return _signAndSendTransaction(result.message, recentBlockhash, sign: true);
  }

  Future<bool> getWalletServiceAvailability() async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: config.region)
            .httpsCallable('walletServiceAvailability');
    final result = await callable.call();
    return result.data["serviceAvailable"] as bool;
  }

  Future<List<TransactionSignature>> swapTransaction(
      String fromWalletAddress,
      String toWalletAddress,
      String fromMintAddress,
      String toMintAddress,
      String quoteMintAddress,
      String fromMarketAddress,
      BigInt minExpectedSwapAmount,
      BigInt amount,
      int fromDecimals,
      int quoteDecimals,
      {String? memo,
      String? quoteWalletAddress,
      String? toMarketAddress,
      bool strict = true}) async {
    final recentBlockhash = await client.getRecentBlockhash();
    // HttpsCallable callable =
    //     FirebaseFunctions.instanceFor(region: config.region)
    //         .httpsCallable('solSwapTx');
    // final data = {
    //   'walletAddress': wallet.publicKey,
    //   'fromWalletAddress': fromWalletAddress,
    //   'toWalletAddress': toWalletAddress,
    //   'quoteWalletAddress': quoteWalletAddress,
    //   'fromMintAddress': fromMintAddress,
    //   'toMintAddress': toMintAddress,
    //   'quoteMintAddress': quoteMintAddress,
    //   'fromMarketAddress': fromMarketAddress,
    //   'toMarketAddress': toMarketAddress,
    //   'minExpectedSwapAmount': minExpectedSwapAmount.toString(),
    //   'minExchangeRate': {
    //     'quoteMintAddress': quoteMintAddress,
    //     'fromDecimals': fromDecimals,
    //     'quoteDecimals': quoteDecimals,
    //     'rate': minExpectedSwapAmount.toString(),
    //     'strict': strict,
    //   },
    //   'amount': amount.toString(),
    //   'recentBlockhash': recentBlockhash.blockhash,
    //   'memo': memo,
    // };
    final result = await clientHelper.initializeSwapTransaction(
      SwapTxInput(
          walletAddress: keyOrAddress,
          fromWalletAddress: fromWalletAddress,
          toWalletAddress: toWalletAddress,
          fromMintAddress: fromMintAddress,
          toMintAddress: toMintAddress,
          quoteMintAddress: quoteMintAddress,
          fromMarketAddress: fromMarketAddress,
          minExpectedSwapAmount: minExpectedSwapAmount.toString(),
          quoteWalletAddress: quoteWalletAddress,
          minExchangeRate: SwapExchangeRate(
              rate: minExpectedSwapAmount.toString(),
              quoteDecimals: quoteDecimals,
              fromDecimals: fromDecimals,
              strict: strict),
          amount: amount.toString(),
          recentBlockhash: recentBlockhash.blockhash,
          memo: memo),
    );
    //var result = await callable.call(data);
    final transactions = await Future.wait(
      (result).map(
        (data) async {
          final message = base64Decode(data.message);
          final List<Signature> signatures = data.signatures
              .map((signature) => Signature.fromBytes(base64Decode(signature)))
              .toList();
          final signature = await wallet.signTransaction(message);
          final rawTransaction = SignedTx(
            signatures: [signature, ...signatures],
            messageBytes: message,
          );
          return rawTransaction.encode();
        },
      ),
    );
    // final txS = await client.sendTransaction(transactions[1]);
    // await client.waitForSignatureStatus(txS, TxStatus.confirmed);
    // final transactionSignatures = [txS];
    final transactionSignatures = await Future.wait(
      transactions.map((tx) async {
        final txS = await client.sendTransaction(tx);
        await client.waitForSignatureStatus(txS, TxStatus.confirmed);
        return txS;
      }),
    );
    // print('sending signatures: $sigs');
    // callable = FirebaseFunctions.instanceFor(region: config.region)
    //     .httpsCallable('solSendSwapTx');
    // final transactionSignatures =
    //     ((await callable.call<List>(transactions)) as List<dynamic>)
    //         .cast<String>();

    //await client.waitForSignatureStatus(signature, TxStatus.confirmed);
    return transactionSignatures;
  }

  Future<TransactionSignature> createAndTransferToAccount(
      String sourcePublicKey,
      String destinationPublicKey,
      BigInt amount,
      String mint,
      {String? memo}) async {
    final recentBlockhash = await client.getRecentBlockhash();
    final result = await clientHelper.createAndTransferToAccount(
        CreateAndTransferToAccountInput(
            walletAddress: keyOrAddress,
            tokenMintAddress: mint,
            sourcePublicKey: sourcePublicKey,
            destinationPublicKey: destinationPublicKey,
            amount: amount.toString(),
            recentBlockhash: recentBlockhash.blockhash));
    return _signAndSendTransaction(result.message, recentBlockhash, sign: true);
  }

  Future<TransactionSignature> transferBetweenSplTokenAccounts(
      String sourcePublicKey,
      String destinationPublicKey,
      BigInt amount,
      String mint,
      {String? memo}) async {
    final recentBlockhash = await client.getRecentBlockhash();
    final result = await clientHelper.createTransferBetweenSplTokenAccounts(
        CreateAndTransferToAccountInput(
            walletAddress: keyOrAddress,
            tokenMintAddress: mint,
            sourcePublicKey: sourcePublicKey,
            destinationPublicKey: destinationPublicKey,
            amount: amount.toString(),
            recentBlockhash: recentBlockhash.blockhash));
    return _signAndSendTransaction(result.message, recentBlockhash, sign: true);
  }

  static WalletServiceException mapToWalletException(Exception exception) {
    if (exception is FirebaseFunctionsException) {
      if (exception.details != null) {
        return WalletServiceException.fromMap(
            asStringKeyedMap(exception.details)!);
      }
      return WalletServiceException(WalletServiceExceptionCode.Unknown);
    } else {
      return WalletServiceException(WalletServiceExceptionCode.Unknown);
    }
  }

  static Stream<UserWallet?> getUserWallet() {
    final uid = fb.FirebaseAuth.instance.currentUser?.uid;
    return fs.FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('wallets')
        .doc(SOLANA_WALLET_PROVIDER)
        .snapshots()
        .map<UserWallet?>((snapshot) {
      if (snapshot.exists) {
        return UserWallet.fromMap(asStringKeyedMap(snapshot.data())!);
      }
      return null;
    });
  }

  static Future<void> linkWallet(String userId, String address, AppConfig config) async {
    try {
      final uid = fb.FirebaseAuth.instance.currentUser?.uid;
      final tokenDoc = await fs.FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('wallets')
          .doc(SOLANA_WALLET_PROVIDER)
          .get();
      if (tokenDoc.exists) {
        return;
      }
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('solLinkWallet');
      final Map<String, String> connectionReq = {
        'userId': userId,
        'address': address,
      };
      await callable.call(connectionReq);
    } on FirebaseFunctionsException catch (error) {
      print('FirebaseFunctionsException: $error');
      throw mapToWalletException(error);
    } catch (error) {
      print('ERROR: $error');
      throw WalletServiceException(WalletServiceExceptionCode.Unknown,
          message: error.toString());
    }
  }

  static Future<void> updateWalletProvider(
      String? userId, String? address, AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('solUpdatePaymentProvider');
      final Map<String, String?> connectionReq = {
        'address': address,
      };
      await callable.call(connectionReq);
    } on FirebaseFunctionsException catch (error) {
      print('ERROR: $error');
      throw mapToWalletException(error);
    } catch (error) {
      print('ERROR: $error');
      throw WalletServiceException(WalletServiceExceptionCode.Unknown,
          message: error.toString());
    }
  }

  static unlockWalletWithKey(String password) async {
    try {
      final encryptedData = await StorageService.read(key: 'fb-torus');
      if (encryptedData != null) {
        final encryptionOutput = json.decode(encryptedData);
        if (encryptionOutput != null) {
          final payload = EncryptionOutput.fromMap(
            asStringKeyedMap(encryptionOutput)!,
          );
          final mnemonic = await decryptMnemonicWithPassword(payload, password);
          return mnemonic.mnemonic;
        }
      }
    } catch (error) {
      print('Error unlocking signer: ${error}');
      return null;
    }
  }

  static lockWalletWithKey(String key, String password) async {
    final output = await encryptMnemonicWithPassword(
        MnemonicInput(mnemonic: key), password);
    await StorageService.write(
        key: 'fb-torus', value: json.encode(output.toMap()));
  }

  static Future<UserKeyPair> fetchUserKeyPair(AppConfig config) async {
    final fb.User? user = fb.FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw WalletServiceException(WalletServiceExceptionCode.UserNotFound);
    }
    if (!user.emailVerified) {
      await LoginService.updateLogin(config);
    }
    final token =
        (await fb.FirebaseAuth.instance.currentUser?.getIdToken(true));
    if (token == null) {
      throw WalletServiceException(WalletServiceExceptionCode.Unauthorized);
    }
    final keyPair = await directSDK().getTorusKey(
      KeyOptions(
          verifier: config.torusVerifier!,
          verifierId: user.uid,
          verifierParams: VerifierParams(verifierId: user.uid),
          idToken: token),
    );
    return UserKeyPair(user.uid, await newEcd25519From(keyPair!.privateKey));
  }

  static Future<WalletServiceAvailability> fetchWalletAvailability(
      AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('walletServiceAvailability');
      final result = await callable.call();
      return WalletServiceAvailability.fromMap(asStringKeyedMap(result.data)!);
    } on FirebaseFunctionsException catch (error) {
      print('error: $error');
      // throw mapToWalletException(error);
      return WalletServiceAvailability();
    } catch (error) {
      print('error: $error');
      return WalletServiceAvailability();
    }
  }

  static Stream<Contribution?> getContributionStream() {
    return fs.FirebaseFirestore.instance
        .collection('contributions')
        .doc('latest')
        .snapshots()
        .map<Contribution?>((fs.DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      final contribution = Contribution.fromMap(map as Map<String, dynamic>);
      return contribution;
    });
  }

  static Stream<UserContribution?> getWalletLinkStream(String contributionId) {
    final uid = fb.FirebaseAuth.instance.currentUser?.uid;
    return fs.FirebaseFirestore.instance
        .collection('user_contributions')
        .doc(uid)
        .collection('contributions')
        .doc(contributionId)
        .snapshots()
        .map<UserContribution?>((fs.DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return UserContribution.fromMap(map as Map<String, dynamic>);
    });
  }

  static Stream<UserContribution?> getUserContributionStream(
      String contributionId) {
    final uid = fb.FirebaseAuth.instance.currentUser?.uid;
    return fs.FirebaseFirestore.instance
        .collection('user_contributions')
        .doc(uid)
        .collection('contributions')
        .doc(contributionId)
        .snapshots()
        .map<UserContribution?>((fs.DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return UserContribution.fromMap(map as Map<String, dynamic>);
    });
  }

  static StreamSubscription? getRewardClaims(
      void onData(List<RewardClaim> claims),
      {RewardClaim? last,
      required int limit,
      void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError}) {
    final email = fb.FirebaseAuth.instance.currentUser?.email;
    if (email == null) {
      return null;
    }
    fs.Query query = fs.FirebaseFirestore.instance
        .collection('reward_claims')
        .where("email", isEqualTo: email)
        .orderBy("createdAt", descending: true)
        .limit(limit);
    if (last != null) {
      query = query.startAfter([last.createdAt]);
    }
    return query.snapshots().listen((fs.QuerySnapshot querySnapshot) {
      List claims = querySnapshot.docs.map((fs.DocumentSnapshot snapshot) {
        final map =
            asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
        map['id'] = snapshot.id;
        return RewardClaim.fromMap(map);
      }).toList();
      onData(claims as List<RewardClaim>);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}
