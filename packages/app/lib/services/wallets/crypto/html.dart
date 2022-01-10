@JS()
library crypto_worker;

import 'dart:async';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:goramp/services/wallets/crypto/interface.dart';
import 'package:goramp/utils/index.dart';
import 'dart:html' as html;

import 'package:js/js.dart';

class WorkerKeyPairData {
  final String? privateKey;
  final String? publicKey;
  WorkerKeyPairData({this.privateKey, this.publicKey});

  factory WorkerKeyPairData.fromMap(Map<String, dynamic> map) =>
      WorkerKeyPairData(
          privateKey: map['privateKey'] as String?, publicKey: map['publicKey']);
}

class WorkerResult {
  final String? status;
  final String? message;
  final WorkerKeyPairData? data;
  WorkerResult({this.status, this.message, this.data});

  factory WorkerResult.fromMap(Map<String, dynamic> map) => WorkerResult(
      status: map['status'],
      message: map['message'],
      data: map['data'] != null
          ? WorkerKeyPairData.fromMap(asStringKeyedMap(map['data'])!)
          : null);
}

Future<KeyPair> newEcd25519From(String seed) {
  var myWorker = new html.Worker('crypto_worker.js');
  Completer<KeyPair> completer = Completer();
  myWorker.onMessage.listen((e) {
    final WorkerResult result = WorkerResult.fromMap(asStringKeyedMap(e.data)!);
    if (result.status == 'success') {
      final priaveKeyHex = hex.decode(result.data!.privateKey!);
      final publicKeyHex = hex.decode(result.data!.publicKey!);
      final simplePublicKey =
          SimplePublicKey(publicKeyHex, type: KeyPairType.ed25519);
      final keyPair = SimpleKeyPairData(
        priaveKeyHex.sublist(0, 32),
        type: KeyPairType.ed25519,
        publicKey: simplePublicKey,
      );
      completer.complete(keyPair);
    } else {
      completer.completeError(CryptoWorkerException(message: result.message));
    }
  });
  myWorker.postMessage([0, seed]);
  return completer.future;
}
