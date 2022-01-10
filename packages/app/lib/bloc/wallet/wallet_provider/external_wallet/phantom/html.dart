@JS()
library sollet;

import 'dart:async';
import 'dart:html' as html;
import 'package:goramp/bloc/wallet/wallet_provider/index.dart';
import 'package:goramp/bloc/wallet/wallet_provider/utils.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/vendor/solana/html.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart' as js_util;
import 'package:solana/solana.dart' as solana;
import 'interface.dart';
import '../utils/html.dart';
// ignore: avoid_web_libraries_in_flutter

@JS('window.solana')
external PhantomWalletWindow get phantom;
@JS('window.open')
external Window openWindow(String url, String name, [String? options]);
@JS('JSON.stringify')
external String stringify(Object obj);

typedef EventCallback = void Function(dynamic);

@JS()
@anonymous
class PhantomWalletWindow {
  external bool get isPhantom;
  external bool get isConnected;
  external PublicKey? get publicKey;
  external Future<void> postMessage(dynamic params);
  external dynamic request(dynamic params);
  external dynamic connect();
  external dynamic disconnect();
  external void once(String event, EventCallback callback);
  external void on(String event, EventCallback callback);
  external void off(String event, EventCallback callback);
}

@JS()
@anonymous
class ConnectResponse {
  external PublicKey get publicKey;
}

class PhantomWalletProvider extends WalletProvider {
  PhantomWalletProvider({PhantomWalletAdapterConfig? config}) {
    _network = config?.network ?? 'mainnet';
    _disconnectCallback = allowInterop(_handleDisconnect);
    if (!ready)
      pollUntilReady(
          this, config?.pollInterval ?? 1000, config?.pollCount ?? 3);
  }

  String? _network;
  PhantomWalletWindow? _provider;
  String? _publicKey;
  bool _autoApprove = false;

  bool _connecting = false;
  String? _errorDescription;

  bool get connecting => _connecting;
  bool get connected => _provider != null && _provider!.isConnected;
  bool get autoApprove => _autoApprove;
  String? get errorDescription => _errorDescription;
  String? get publicKey => _publicKey;
  dynamic get keypair => _publicKey;
  String get name => 'Phantom';
  String get iconUrl => WALLETS.phantom;

  late EventCallback _disconnectCallback;

  static bool hasInstalledProvider() {
    var isPhantom = false;
    var hasSolana = js_util.hasProperty(html.window, 'solana');
    if (hasSolana) {
      isPhantom = js_util.getProperty(phantom, 'isPhantom') == true;
    }
    final hasPhantom = hasSolana && isPhantom;
    return hasPhantom;
  }

  static PhantomWalletWindow? getProvider() {
    try {
      final phantomWallet = hasInstalledProvider() ? phantom : null;
      return phantomWallet;
    } catch (error) {
      print('error: $error');
      return null;
    }
  }

  Future<void> _handleDisconnect(event) async {
    final provider = _provider;
    if (provider != null) {
      provider.off('disconnect', _disconnectCallback);
      _publicKey = null;
      _autoApprove = false;
      emit(
          'error',
          WalletProviderException(this,
              WalletProviderExceptionCode.DisconnectedError));
      emit('disconnect');
    }
  }

  @override
  Future<void> connect() async {
    try {
      if (connected || connecting) return;
      _connecting = true;
      final provider = getProvider();
      if (provider == null) {
        throw WalletProviderException(this,
            WalletProviderExceptionCode.NotFoundError);
      }
      emit('connecting');
      final handleDisconnect =
          js_util.getProperty(provider, '_handleDisconnect');
      if (!provider.isConnected) {
        try {
          final connectCompleter = new Completer();
          final onConnect = allowInterop((data) {
            if (connectCompleter.isCompleted) {
              return;
            }
            connectCompleter.complete(data);
          });
          final disconnect = (List<dynamic> args) {
            provider.off('connect', onConnect);
            if (connectCompleter.isCompleted) {
              return;
            }
            connectCompleter.completeError(WalletProviderException(this,
                WalletProviderExceptionCode.WindowClosedError));
            return js_util
                .callMethod(handleDisconnect, 'apply', [provider, ...args]);
          };
          js_util.setProperty(
              provider, '_handleDisconnect', allowInterop(disconnect));
          provider.once('connect', onConnect);
          js_util.promiseToFuture(provider.connect()).catchError((error) {
            provider.off('connect', onConnect);
            connectCompleter.completeError(error);
          });
          await connectCompleter.future;
        } finally {
          js_util.setProperty(provider, '_handleDisconnect', handleDisconnect);
        }
      }
      if (provider.publicKey == null)
        throw WalletProviderException(this,
          WalletProviderExceptionCode.ConnectionError,
        );
      provider.on('disconnect', _disconnectCallback);
      _provider = provider;
      _publicKey = _provider!.publicKey.toString();
      emit('connect', _publicKey);
    } catch (error, stack) {
      print('error: $error');
      print('stack: $stack');
      final connectionError = WalletProviderException(this,
          WalletProviderExceptionCode.ConnectionError,
          message: error.toString());
      emit('error', connectionError);
      throw connectionError;
    } finally {
      _connecting = false;
    }
  }

  @override
  Future<void> disconnect() async {
    final provider = _provider;
    if (provider != null) {
      provider.off('disconnect', _disconnectCallback);
      _publicKey = null;
      _provider = null;
      try {
        await js_util.promiseToFuture(provider.disconnect());
      } catch (error) {
        final disConnectionError = WalletProviderException(this,
            WalletProviderExceptionCode.DisconnectedError,
            message: error.toString());
        emit('error', disConnectionError);
      }
    }
    emit('disconnect');
  }

  @override
  Future<solana.Signature> sign(List<int> message, {String? display}) async {
    final result = await _sendRequest<SignaturePubkeyString>(
        'sign', {'message': solana.base58encode(message), 'display': display});
    return solana.Signature.fromBytes(solana.base58decode(result.signature));
  }

  @override
  Future<solana.Signature> signTransaction(List<int> message) async {
    final signedTransaction =
        await _sendRequest<SignaturePubkeyString>('signTransaction', {
      'message': solana.base58encode(message),
    });
    return solana.Signature.fromBytes(
        solana.base58decode(signedTransaction.signature));
  }

  @override
  Future<List<solana.Signature>> signAllTransactions(
      List<List<int>> messages) async {
    final result =
        await _sendRequest<List<SignaturePubkeyString>>('signAllTransactions', {
      'message': messages.map((msg) => solana.base58encode(msg)),
    });
    return result
        .map((sig) =>
            solana.Signature.fromBytes(solana.base58decode(sig.signature)))
        .toList();
  }

  Future<T> _sendRequest<T>(String method, Map<String, dynamic> params) async {
    if (method != 'connect' && !connected) {
      throw new Exception('Wallet not connected');
    }
    final map = <String, dynamic>{
      'method': method,
      'params': {
        '_network': _network,
        ...params,
      },
    };
    return js_util.promiseToFuture<T>(_provider!.request(js_util.jsify(map)));
  }

  @override
  bool get ready => hasInstalledProvider();
}
