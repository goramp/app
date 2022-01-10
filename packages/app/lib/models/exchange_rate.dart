import 'package:equatable/equatable.dart';
import 'package:goramp/utils/index.dart';

class BBO extends Equatable {
  BBO({
    required this.bestBid,
    required this.bestOffer,
    required this.mid,
  });

  final num? bestBid;
  final num? bestOffer;
  final num? mid;

  List<Object?> get props => [bestBid, bestOffer, mid];

  factory BBO.fromMap(Map<String, dynamic> map) {
    return BBO(
      bestBid: map['bestBid'],
      bestOffer: map['bestOffer'],
      mid: map['mid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bestBid': bestBid,
      'bestOffer': bestOffer,
      'mid': mid,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

class Market extends Equatable {
  Market({
    required this.id,
    required this.baseMintAddress,
    required this.name,
    required this.bbo,
    required this.programId,
    required this.publicKey,
    required this.quoteMintAddress,
  });

  final String id;
  final String baseMintAddress;
  final String programId;
  final String name;
  final BBO? bbo;
  final String publicKey;
  final String quoteMintAddress;

  List<Object?> get props =>
      [id, baseMintAddress, name, programId, bbo, publicKey, quoteMintAddress];

  factory Market.fromMap(Map<String, dynamic> map) {
    return Market(
        id: map['id'],
        baseMintAddress: map['baseMintAddress'],
        name: map['name'],
        bbo: map['bbo'] == null
            ? null
            : BBO.fromMap(
                asStringKeyedMap(map['bbo'])!,
              ),
        programId: map['programId'],
        publicKey: map['publicKey'],
        quoteMintAddress: map['quoteMintAddress']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'baseMintAddress': baseMintAddress,
      'name': name,
      'bbo': bbo?.toMap(),
      'programId': programId,
      'publicKey': publicKey,
      'quoteMintAddress': quoteMintAddress,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

class Quote extends Equatable {
  Quote({
    required this.price,
    required this.fullyDilutedMarketCap,
    required this.percentChange1h,
    required this.percentChange24h,
    required this.percentChange30d,
    required this.percentChange60d,
    required this.percentChange7d,
    required this.percentChange90d,
    required this.volume24h,
    required this.volumeChange24h,
    required this.lastUpdated,
    required this.marketCapDominance,
  });

  final double price;
  final String fullyDilutedMarketCap;
  final String lastUpdated;
  final double marketCapDominance;
  final double percentChange1h;
  final double percentChange24h;
  final double percentChange30d;
  final double percentChange60d;
  final double percentChange7d;
  final double percentChange90d;
  final double volume24h;
  final double volumeChange24h;

  List<Object?> get props => [
        price,
        fullyDilutedMarketCap,
        percentChange1h,
        percentChange24h,
        percentChange30d,
        percentChange60d,
        percentChange7d,
        percentChange90d,
        volume24h,
        volumeChange24h,
        lastUpdated,
        marketCapDominance
      ];

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      price: map['price'],
      fullyDilutedMarketCap: map['fully_diluted_market_cap'],
      percentChange1h: map['percent_change_1h'],
      percentChange24h: map['percent_change_24h'],
      percentChange30d: map['percent_change_30d'],
      percentChange60d: map['percent_change_60d'],
      percentChange7d: map['percent_change_7d'],
      percentChange90d: map['percent_change_90d'],
      volume24h: map['volume_24h'],
      volumeChange24h: map['volume_change_24h'],
      lastUpdated: map['last_updated'],
      marketCapDominance: map['market_cap_dominance'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'fully_diluted_market_cap': fullyDilutedMarketCap,
      'percent_change_1h': percentChange1h,
      'percent_change_24h': percentChange24h,
      'percent_change_30d': percentChange30d,
      'percent_change_60d': percentChange60d,
      'percent_change_7d': percentChange7d,
      'percent_change_90d': percentChange90d,
      'volume_24h': volume24h,
      'volumeChange24h': volume24h,
      'last_updated': lastUpdated,
      'market_cap_dominance': marketCapDominance,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

class ExchangeRate extends Equatable {
  ExchangeRate({
    required this.coin,
    required this.rate,
    this.quote,
  });

  final String coin;
  final double rate;
  final Quote? quote;

  List<Object?> get props => [coin, rate, quote];

  factory ExchangeRate.fromMap(Map<String, dynamic> map) {
    return ExchangeRate(
      coin: map['coin'],
      rate: (map['rate'] as num).toDouble(),
      quote: map['quote'] != null ? Quote.fromMap(map['quote']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {'coin': coin, 'rate': rate, 'quote': quote?.toMap()};
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
