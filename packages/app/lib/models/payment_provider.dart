import 'package:equatable/equatable.dart';

const STRIPE_PROVIDER_ID = 'stripe.com';
const SOLANA_PAYMENT_PROVIDER = 'solana_wallet';
const SOLANA_WALLET_PROVIDER = 'solana';
const NFT_PAYMENT_PROVIDER = 'solana_wallet_nft';
const CRYPTO_PAYMENT_PROVIDER_NAME = 'solana_wallet';
const NO_PAYMENT_PROVIDER_ID = 'free';

const KDefaultPaymentProvider = PaymentProvider(
  id: SOLANA_PAYMENT_PROVIDER,
  name: CRYPTO_PAYMENT_PROVIDER_NAME,
);

class PaymentProvider extends Equatable {
  final String? id;
  final String? name;
  final List<String>? countries;

  const PaymentProvider({
    this.name,
    this.id,
    this.countries,
  });

  List<Object?> get props => [name, id, countries];

  factory PaymentProvider.fromMap(Map<String, dynamic> map) {
    return PaymentProvider(
        id: map['id'],
        name: map['name'],
        countries: map['countries']?.cast<String>() ?? []);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'countries': countries,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
