@JS()
library sollet;

import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:goramp/bloc/wallet/wallet_provider/index.dart';
import 'package:goramp/bloc/wallet/wallet_provider/utils.dart';
import 'package:goramp/utils/index.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart' as js_util;
import 'package:solana/solana.dart' as solana;
import 'interface.dart';
import '../utils/html.dart';
// ignore: avoid_web_libraries_in_flutter

typedef PostMessage = Future<void> Function(dynamic params);

@JS('window.sollet.postMessage')
external Future<void> postMessage(dynamic params);

class SolletWalletProvider extends WalletProvider {
  SolletWalletProvider({SolletWalletAdapterConfig? config}) {
    final provider = config?.provider ?? getProvider();
    _network = config?.network ?? 'mainnet';
    if (provider is PostMessage) {
      _injectedProvider = provider;
    } else if (provider is String) {
      _providerUrl = Uri.parse(
          '$provider#origin=${html.window.location.origin}&network=$_network');
    } else {
      throw Exception(
          'provider parameter must be an injected provider or a URL string.');
    }
    if (!ready)
      pollUntilReady(
          this, config?.pollInterval ?? 1000, config?.pollCount ?? 3);
  }

  String? _network;
  Uri? _providerUrl;
  PostMessage? _injectedProvider;
  bool _handlerAdded = false;
  Window? _popup;
  int _nextRequestId = 1;
  String? _publicKey;
  bool _autoApprove = false;

  bool _connecting = false;
  String? _errorDescription;

  bool get connecting => _connecting;
  bool get connected => _publicKey != null;
  bool get autoApprove => _autoApprove;
  String? get errorDescription => _errorDescription;
  String? get publicKey => _publicKey;
  dynamic get keypair => _publicKey;
  String get name =>
      _injectedProvider is PostMessage ? 'Sollet Extension' : 'Sollet';
  String get iconUrl => _injectedProvider is PostMessage
      ? WALLETS.solletExtension
      : WALLETS.sollet;

  final Map<int, Completer> _responsePromises = {};

  bool get ready => _providerUrl != null || hasInstalledProvider();

  VoidCallback? _willDisconnect;

  static bool hasInstalledProvider() {
    return js_util.hasProperty(html.window, 'sollet');
  }

  static PostMessage? getProvider() {
    try {
      return hasInstalledProvider() ? postMessage : null;
    } catch (error) {
      return null;
    }
  }

  _handleMessage(html.Event event) {
    final e = event as html.MessageEvent;
    final isPopup =
        e.origin == this._providerUrl?.origin && (e.source is html.WindowBase);
    final isProvider = (_injectedProvider != null && (e.source is html.Window));
    if (isProvider || isPopup) {
      final map = asStringKeyedMap(e.data) ?? {};
      final method = map['method'];
      final id = map['id'];
      final result = asStringKeyedMap(map['result']);
      final error = map['error'];
      if (method == 'connected') {
        final params = asStringKeyedMap(map['params']) ?? {};
        final newPublicKey = params['publicKey'];
        final autoApprove = params['autoApprove'];
        if (_publicKey == null || _publicKey != newPublicKey) {
          if (_publicKey != null && _publicKey != newPublicKey) {
            _handleDisconnect();
          }
          _publicKey = newPublicKey;
          _autoApprove = autoApprove;
          emit('connect', _publicKey);
        }
      } else if (method == 'disconnected') {
        _handleDisconnect();
      } else if (result != null || error != null) {
        final completer = _responsePromises[id];
        if (completer != null) {
          if (result != null) {
            completer.complete(result);
          } else if (error != null) {
            completer.completeError(error);
          }
        }
        _responsePromises.remove(id);
      }
    }
  }

  Future _handleConnect() async {
    if (!_handlerAdded) {
      _handlerAdded = true;
      html.window.addEventListener('message', _handleMessage);
      html.window.addEventListener('beforeunload', _beforeUnload);
    }
    if (_injectedProvider != null) {
      await _sendRequest('connect', {});
    } else {
      html.window.name = 'parent';
      _popup = openWindow(
        _providerUrl.toString(),
        '_kSollet',
        'location,resizable,width=460,height=675',
      );
      final completer = new Completer<String>();
      once('connect', (data) {
        print('received connect event: $data');
        completer.complete(data);
      });
      return completer.future;
    }
  }

  Future<void> _handleDisconnect({bool silent = false}) async {
    _willDisconnect?.call();
    if (_handlerAdded) {
      _handlerAdded = false;
      html.window.removeEventListener('message', _handleMessage);
      html.window.removeEventListener('beforeunload', _beforeUnload);
    }
    if (_publicKey != null) {
      _publicKey = null;
      _autoApprove = false;
      emit('disconnect');
    }
    if (silent) {
      _responsePromises.clear();
    } else {
      _responsePromises.forEach((key, value) {
        value.completeError(WalletProviderException(
            this, WalletProviderExceptionCode.DisconnectedError));
      });
      _responsePromises.clear();
    }
  }

  void _beforeUnload(evnt) {
    disconnect();
  }

  @override
  Future<void> connect() async {
    Timer? _connectTimer;
    try {
      if (connected || connecting) return;
      _connecting = true;
      emit('connecting');
      try {
        final connectCompleter = new Completer();
        final onConnect = (data) {
          _connectTimer?.cancel();
          if (connectCompleter.isCompleted) {
            return;
          }
          connectCompleter.complete(data);
        };
        _willDisconnect = () {
          off('connect', onConnect);
          _connectTimer?.cancel();
          if (connectCompleter.isCompleted) {
            return;
          }
          connectCompleter.completeError(WalletProviderException(
              this, WalletProviderExceptionCode.WindowClosedError));
        };
        on('connect', onConnect);
        _doConnect().catchError((error) {
          off('connect', onConnect);
          connectCompleter.completeError(error);
        });
        if (_injectedProvider != null) {
          _connectTimer = Timer(
            Duration(seconds: 10),
            () {
              connectCompleter.completeError(WalletProviderException(
                  this, WalletProviderExceptionCode.TimeoutError));
            },
          );
        } else {
          var count = 0;
          _connectTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
            if (_popup != null) {
              if (_popup!.closed)
                connectCompleter.completeError(WalletProviderException(
                    this, WalletProviderExceptionCode.WindowClosedError));
            } else {
              if (count > 50)
                connectCompleter.completeError(WalletProviderException(
                    this, WalletProviderExceptionCode.WindowBlockedError));
            }
            count++;
          });
        }
        await connectCompleter.future;
      } finally {
        _connectTimer?.cancel();
        _connectTimer = null;
        _willDisconnect = null;
      }
    } catch (error, stack) {
      print('error: $error');
      print('stack: $stack');
      final connectionError = WalletProviderException(
          this, WalletProviderExceptionCode.ConnectionError,
          message: error.toString());
      emit('error', connectionError);
      throw connectionError;
    } finally {
      _connecting = false;
    }
  }

  Future<void> _doConnect() async {
    if (_popup != null) {
      _popup!.close();
    }
    await _handleConnect();
  }

  @override
  Future<void> disconnect() async {
    final disconnectCompleter = Completer();

    final disconnectTimer = Timer(Duration(milliseconds: 250), () {
      if (!disconnectCompleter.isCompleted) {
        return disconnectCompleter.complete();
      }
    });
    try {
      _doDisconnect().then((value) {
        disconnectTimer.cancel();
        disconnectCompleter.complete();
      }).catchError((error) {
        disconnectTimer.cancel();
        if (error is WalletProviderException &&
            error.code == WalletProviderExceptionCode.DisconnectedError) {
          disconnectCompleter.complete();
        } else {
          disconnectCompleter.completeError(error);
        }
      });
      await disconnectCompleter.future;
    } catch (error) {
      final disConnectionError = WalletProviderException(
          this, WalletProviderExceptionCode.DisconnectedError,
          message: error.toString());
      throw disConnectionError;
    } finally {
      disconnectTimer.cancel();
    }
  }

  Future<void> _doDisconnect() async {
    if (_injectedProvider != null) {
      await _sendRequest('disconnect', {});
    }
    if (_popup != null) {
      _popup!.close();
    }
    await _handleDisconnect(silent: true);
  }

  @override
  Future<solana.Signature> sign(List<int> message, {String? display}) async {
    final result = await _sendRequest(
        'sign', {'message': solana.base58encode(message), 'display': display});
    final signature = result!['signature'];
    return solana.Signature.fromBytes(solana.base58decode(signature));
  }

  @override
  Future<solana.Signature> signTransaction(List<int> message) async {
    final result = await _sendRequest('signTransaction', {
      'message': solana.base58encode(message),
    });
    final signature = result!['signature'];
    return solana.Signature.fromBytes(solana.base58decode(signature));
  }

  @override
  Future<List<solana.Signature>> signAllTransactions(
      List<List<int>> messages) async {
    final result = await _sendRequest('signAllTransactions', {
      'messages': messages.map((msg) => solana.base58encode(msg)),
    });
    final signatures = result!['signatures'] as List<String>;
    return signatures
        .map((sig) => solana.Signature.fromBytes(solana.base58decode(sig)))
        .toList();
  }

  Future<Map<String, dynamic>?> _sendRequest(
      String method, Map<String, dynamic> params) async {
    if (method != 'connect' && !connected) {
      throw new Exception('Wallet not connected');
    }
    final requestId = _nextRequestId;
    ++_nextRequestId;
    Completer<Map<String, dynamic>?> completer = new Completer();
    _responsePromises[requestId] = completer;
    if (_injectedProvider != null) {
      final map = <String, dynamic>{
        'jsonrpc': '2.0',
        'id': requestId,
        'method': method,
        'params': {
          '_network': _network,
          ...params,
        },
      };
      _injectedProvider!(js_util.jsify(map));
    } else {
      final map = <String, dynamic>{
        'jsonrpc': '2.0',
        'id': requestId,
        'method': method,
        'params': params
      };
      _popup?.postMessage(
        js_util.jsify(map),
        _providerUrl?.origin ?? '',
      );
      if (!autoApprove && _popup != null) {
        _popup!.focus();
      }
    }
    return completer.future;
  }
}
