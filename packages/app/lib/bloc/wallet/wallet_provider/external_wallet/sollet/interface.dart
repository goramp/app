const kBaseSolletUrl = 'https://www.sollet.io/';

class SolletWalletAdapterConfig {
  SolletWalletAdapterConfig(
      {this.provider, this.network, this.pollCount, this.pollInterval});
  final dynamic provider;
  final String? network;
  final int? pollInterval;
  final int? pollCount;
}
