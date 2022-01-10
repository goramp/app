class PhantomWalletAdapterConfig {
  PhantomWalletAdapterConfig(
      {this.provider, this.network, this.pollCount, this.pollInterval});
  final dynamic provider;
  final String? network;
  final int? pollInterval;
  final int? pollCount;
}
