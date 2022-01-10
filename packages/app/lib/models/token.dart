import 'package:equatable/equatable.dart';
import 'package:goramp/utils/index.dart';
import 'package:solana/solana.dart';

class SPLTokenAccountInfo extends Equatable {
  SPLTokenAccountInfo(
      {required this.mint,
      required this.owner,
      required this.amount,
      required this.decimals});
  final String? mint;
  final String? owner;
  final BigInt? amount;
  final int? decimals;

  List get props => [mint, owner, amount, decimals];

  factory SPLTokenAccountInfo.fromSplTokenAccountData(Account account) {
    return account.data!.mapOrNull(splToken: (data) {
      final info = data.parsed.info;
      return SPLTokenAccountInfo(
        mint: info.mint,
        owner: info.owner,
        amount: BigInt.tryParse(info.tokenAmount.amount),
        decimals: info.tokenAmount.decimals,
      );
    })!;
  }

  factory SPLTokenAccountInfo.fromMap(Map<String, dynamic> map) {
    final parsed = asStringKeyedMap(map['parsed'])!;
    final info = asStringKeyedMap(parsed['info'])!;
    final amount = info['tokenAmount']['amount'];
    final decimals = info['tokenAmount']['decimals'];
    return SPLTokenAccountInfo(
      mint: info['mint'] as String?,
      owner: info['owner'] as String?,
      amount: BigInt.tryParse(amount),
      decimals: decimals is String ? int.tryParse(decimals) : decimals,
    );
  }
}

class Token extends Equatable {
  final String? mintAddress;
  final String? tokenName;
  final String? tokenSymbol;
  final String chainId;
  final String? icon;
  final int? decimals;
  final bool isNative;
  final bool deprecated;
  final bool canSwap;
  final bool canBuy;

  const Token(
      {this.mintAddress,
      this.tokenName,
      this.tokenSymbol,
      this.icon,
      this.decimals,
      this.canSwap = false,
      this.isNative = false,
      this.canBuy = false,
      this.deprecated = false,
      required this.chainId });

  List get props => [
        mintAddress,
        tokenName,
        tokenSymbol,
        icon,
        isNative,
        decimals,
        deprecated,
        canSwap,
        canBuy,
        chainId
      ];

  String? get friendlySymbol =>
      tokenSymbol == 'USDC' ? 'SPL-USDC' : tokenSymbol;
}

class TokenAccount extends Equatable {
  final Token? token;
  final String walletAddress;
  final String address;
  final String? owner;
  final BigInt? amount;
  final int? decimals;

  TokenAccount({
    required this.walletAddress,
    required this.address,
    this.token,
    this.owner,
    this.amount,
    this.decimals,
  });

  List get props => [walletAddress, address, token, owner, amount, decimals];

  TokenAccount copyWith(
      {String? walletAddress,
      Token? token,
      String? address,
      String? owner,
      BigInt? amount,
      int? decimals}) {
    return TokenAccount(
      walletAddress: walletAddress ?? this.walletAddress,
      address: address ?? this.address,
      token: token ?? this.token,
      owner: owner ?? this.owner,
      amount: amount ?? this.amount,
      decimals: decimals ?? this.decimals,
    );
  }
}
