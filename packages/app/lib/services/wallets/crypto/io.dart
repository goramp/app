import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:convert/convert.dart';

Future<KeyPair> newEcd25519From(String seed) {
  return compute<String, KeyPair>(_newEcd25519From, seed);
}

Future<KeyPair> _newEcd25519From(String seed) {
  final ed25519 = Ed25519();
  return ed25519.newKeyPairFromSeed(hex.decode(seed).sublist(0, 32));
}
