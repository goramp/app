import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:cryptography/cryptography.dart' as crypto;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/bloc/wallet/wallet_provider/index.dart' as inter;
import 'package:goramp/models/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/solana.dart';
import 'package:universal_platform/universal_platform.dart';

const _maxRefresh = 5000;
const _kMaxNumTrials = 3;

class InAppWalletProvider extends inter.WalletProvider {
  final AppConfig config;
  Ed25519HDKeyPair? _signer;

  bool _connecting = false;
  final bool autoApprove = true;
  bool _connected = false;
  String? _errorDescription;

  bool get connecting => _connecting;
  bool get connected => _connected;
  String? get errorDescription => _errorDescription;
  String? get publicKey => _signer?.address;
  dynamic get keypair => _signer;
  String get name => 'Kurobi';
  String get iconUrl => WALLETS.kurobi;

  bool get linked => _walletProvider?.address == _signer?.address;

  UserWallet? _walletProvider;

  StreamSubscription<AuthenticationState>? _authListener;

  StreamSubscription<UserWallet?>? _walletProviderSub;
  String? _userId;
  String get _key => '${_userId}_kurobi_wallet';

  InAppWalletProvider(this.config, AuthenticationBloc authBloc,
      {RPCClient? client}) {
    _authListener = authBloc.stream.listen(this._handleAuth);
    _handleAuth(authBloc.state);
  }

  _handleAuth(AuthenticationState auth) async {
    if (auth is AuthAuthenticated) {
      if (_userId == auth.user!.id) {
        return;
      }
      _userId = auth.user!.id;
      _subscribePaymentProvider();
    }
    if (auth is AuthUnauthenticated) {
      _walletProviderSub?.cancel();
      _walletProviderSub = null;
      _signer = null;
      _userId = null;
    }
  }

  _subscribePaymentProvider() async {
    await _walletProviderSub?.cancel();
    _walletProviderSub = WalletService.getUserWallet().listen((event) {
      _walletProvider = event;
      _mayBeRegisterWallet();
    });
  }

  Future<void> linkWallet() async {
    await _mayBeRegisterWallet();
  }

  Future<void> _saveWallet(
    String uid,
    String publicKey,
    List<int> privateKey,
  ) async {
    if (UniversalPlatform.isWeb) {
      return;
    }
    final FlutterSecureStorage storage = FlutterSecureStorage();
    final wallet = <String, String>{
      'publicKey': publicKey,
      'privateKey': base58encode(privateKey),
      'uid': uid
    };
    final data = jsonEncode(wallet);
    return storage.write(key: _key, value: data);
  }

  Future<Map<String, String>?> _loadWallet() async {
    try {
      if (UniversalPlatform.isWeb) {
        return null;
      }
      final FlutterSecureStorage storage = FlutterSecureStorage();
      final data = await storage.read(key: _key);
      if (data == null || data == '') {
        return null;
      }
      final map = jsonDecode(data);
      return map;
    } catch (erro) {
      return null;
    }
  }

  Future<void> _mayBeRegisterWallet() async {
    UserKeyPair? userKeyPair;
    if (_signer == null) {
      final map = await _loadWallet();
      if (map == null) {
        userKeyPair = await WalletService.fetchUserKeyPair(config);
        final publicKey = await userKeyPair.keyPair.extractPublicKey();
        if (publicKey is crypto.SimplePublicKey) {
          final keydata =
              await userKeyPair.keyPair.extract() as crypto.SimpleKeyPairData;
          _signer = await Ed25519HDKeyPair.fromPrivateKeyBytes(
              privateKey: keydata.bytes);
          final uid = FirebaseAuth.instance.currentUser?.uid;
          await _saveWallet(uid!, _signer!.address, keydata.bytes);
          if (_walletProvider?.address != _signer!.address) {
            await WalletService.linkWallet(uid, _signer!.address, config);
          }
        } else {
          throw Exception('could not build a key pair');
        }
      } else {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null && map['uid']! == uid) {
          final privateKeyBytes = base58decode(map['privateKey']!);
          _signer = await Ed25519HDKeyPair.fromPrivateKeyBytes(
              privateKey: privateKeyBytes);
          if (_walletProvider?.address != _signer!.address) {
            await WalletService.linkWallet(uid, _signer!.address, config);
          }
        }
      }
    }
  }

  @override
  Future<void> connect() async {
    if (connected) {
      throw Exception('Wallet connected');
    }
    await _connect();
  }

  Future<void> _connect({int numRetries = 0}) async {
    try {
      _connecting = true;
      emit('connecting');
      await _mayBeRegisterWallet();
      emit('connect', _signer!.address);
    } catch (error, stack) {
      Sentry.captureException(error, stackTrace: stack);
      final errorCount = numRetries + 1;
      if (errorCount < _kMaxNumTrials) {
        var waitTime = _retryDelay(retryNumber: errorCount);
        waitTime = math.min(waitTime, _maxRefresh);
        await Future.delayed(Duration(milliseconds: waitTime.toInt()),
            () => _connect(numRetries: errorCount));
      } else {
        print('failed to connect wallet: $error');
        print(stack);
        _errorDescription = error.toString();
        _connecting = false;
        _connected = false;
        emit(
          'error',
          WalletProviderException(
            this,
            WalletProviderExceptionCode.ConnectionError,
            message: error.toString(),
          ),
        );
        rethrow;
      }
    }
  }

  @override
  Future<void> disconnect() async {
    _connecting = false;
    _connected = false;
    _errorDescription = null;
    emit('disconnect');
  }

  @override
  Future<Signature> sign(message, {String? display}) async {
    return Signature.fromBytes((await _signer!.sign(message)).toList());
  }

  @override
  Future<Signature> signTransaction(List<int> message) async {
    return await _signer!.sign(message);
  }

  @override
  Future<List<Signature>> signAllTransactions(List<List<int>> messages) async {
    return await Future.wait(
        messages.map((msg) async => await _signer!.sign(msg)));
  }

  int _retryDelay({retryNumber = 1}) {
    final millis = math.pow(2, retryNumber - 1) * 1000;
    var rng = math.Random();
    return (millis + 1000 * rng.nextDouble()).toInt();
  }

  @override
  bool get ready => true;

  Future<void> dispose() async {
    await _authListener?.cancel();
    await _walletProviderSub?.cancel();
    _signer = null;
  }
}
