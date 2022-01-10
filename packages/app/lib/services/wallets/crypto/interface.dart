class KeyResult {
  final String? privateKey;
  final String? publicKey;
  KeyResult({this.privateKey, this.publicKey});
}

class CryptoWorkerException implements Exception {
  final String? message;
  CryptoWorkerException({this.message});
}
