import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:solana/src/base58/decode.dart';
import 'package:solana/src/base58/encode.dart';

class MnemonicInput {
  const MnemonicInput({required this.mnemonic, this.account});

  factory MnemonicInput.fromMap(Map<String, dynamic> map) => MnemonicInput(
      mnemonic: map['mnemonic'] as String,
      account: map['account'] != null ? map['account'] as int : null);

  final String mnemonic;
  final int? account;

  @override
  bool operator ==(Object other) =>
      other is MnemonicInput &&
      other.mnemonic == mnemonic &&
      other.account == account;

  @override
  int get hashCode => mnemonic.hashCode ^ account.hashCode;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'mnemonic': mnemonic,
        'account': account,
      };
}

class EncryptionOutput {
  const EncryptionOutput(
      {required this.encrypted,
      required this.nonce,
      required this.kdf,
      required this.salt,
      required this.iterations,
      required this.mac,
      required this.digest});

  factory EncryptionOutput.fromMap(Map<String, dynamic> map) =>
      EncryptionOutput(
          encrypted: map['encrypted'] as String,
          nonce: map['nonce'] as String,
          kdf: map['kdf'] as String,
          salt: map['salt'] as String,
          iterations: map['iterations'] as int,
          mac: map['mac'] as String,
          digest: map['digest'] as String);

  final String encrypted;
  final String nonce;
  final String kdf;
  final String salt;
  final int iterations;
  final String mac;
  final String digest;

  @override
  bool operator ==(Object other) =>
      other is EncryptionOutput &&
      other.encrypted == encrypted &&
      other.nonce == nonce &&
      other.kdf == kdf &&
      other.salt == salt &&
      other.iterations == iterations &&
      other.mac == mac &&
      other.digest == digest;

  @override
  int get hashCode =>
      encrypted.hashCode ^
      nonce.hashCode ^
      kdf.hashCode ^
      salt.hashCode ^
      iterations.hashCode ^
      mac.hashCode ^
      digest.hashCode;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'encrypted': encrypted,
        'nonce': nonce,
        'kdf': kdf,
        'salt': salt,
        'iterations': iterations,
        'mac': mac,
        'digest': digest,
      };
}

/// Encrypts the mnemonic and seed
/// returns JSON payload which can be saved to local storage
Future<EncryptionOutput> encryptMnemonicWithPassword(
  MnemonicInput input,
  String password,
) async {
  final plainText = json.encode(input.toMap());
  const kdf = 'pbkdf2';
  const iterations = 100000;
  final salt = Uint8List(16);
  const digest = 'sha256';
  fillBytesWithSecureRandom(salt);
  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: 128,
  );
  final secretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)), nonce: salt);
  final algorithm = AesCtr.with128bits(
    macAlgorithm: Hmac.sha256(),
  );
  final nonce = algorithm.newNonce();
  final secretBox = await algorithm.encrypt(utf8.encode(plainText),
      secretKey: secretKey, nonce: nonce);

  return EncryptionOutput(
      encrypted: base58encode(secretBox.cipherText),
      nonce: base58encode(nonce),
      kdf: kdf,
      salt: base58encode(salt),
      iterations: iterations,
      mac: base58encode(secretBox.mac.bytes),
      digest: digest);
}

/// returns the mnemonic by decrypting [payload] with [payload]
Future<MnemonicInput> decryptMnemonicWithPassword(
  EncryptionOutput payload,
  String password,
) async {
  final encrypted = base58decode(payload.encrypted);
  final nonce = base58decode(payload.nonce);
  final salt = base58decode(payload.salt);
  final mac = base58decode(payload.mac);
  final iterations = payload.iterations;
  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: 128,
  );
  final secretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)), nonce: salt);
  final algorithm = AesCtr.with128bits(
    macAlgorithm: Hmac.sha256(),
  );
  final plainText = await algorithm.decrypt(
      SecretBox(encrypted, nonce: nonce, mac: Mac(mac)),
      secretKey: secretKey);
  final decodedPlaintext =
      json.decode(utf8.decode(plainText)) as Map<String, dynamic>;
  return MnemonicInput.fromMap(decodedPlaintext);
}
