import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:goramp/utils/index.dart';
import 'package:solana/solana.dart';

const _kMarketAssetPath = 'assets/data/markets.json';
const _kSerumOrderBooks = 'https://serum-api.bonfida.com/orderbooks';
const Map<String, num> _kDefaultPrices = {
  'USDC': 1,
  'USDT': 1,
};

class Market extends Equatable {
  Market({this.publicKey, this.deprecated, this.name, this.programId});

  final String? publicKey;
  final bool? deprecated;
  final String? name;
  final String? programId;

  List get props => [publicKey, deprecated, name, programId];

  factory Market.fromMap(Map<String, dynamic> map) {
    return Market(
      publicKey: map['address'],
      deprecated: map['deprecated'],
      name: map['name'],
      programId: map['programId'],
    );
  }

  Market copyWith({
    String? publicKey,
    bool? deprecated,
    String? name,
    String? programId,
  }) {
    return Market(
      publicKey: publicKey ?? this.publicKey,
      deprecated: deprecated ?? this.deprecated,
      name: name ?? this.name,
      programId: programId ?? this.programId,
    );
  }
}

class MarketState extends Equatable {
  final bool loading;
  final Object? error;
  final Map<String?, num?> prices;
  final Map<String, Market>? markets;

  @override
  List<Object?> get props => [loading, error, prices, markets];

  MarketState._({
    this.loading = false,
    this.error,
    this.prices = _kDefaultPrices,
    this.markets,
  });

  MarketState.loading()
      : loading = true,
        error = null,
        prices = _kDefaultPrices,
        markets = null;

  MarketState.uninitialized()
      : loading = false,
        error = null,
        prices = _kDefaultPrices,
        markets = null;
  MarketState copyWith(
      {bool? loading,
      Object? error,
      Map<String?, num?>? prices,
      Map<String, Market>? markets}) {
    return MarketState._(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      prices: prices ?? this.prices,
      markets: markets ?? this.markets,
    );
  }

  bool get hasError => error != null;
}

class MarketCubit extends Cubit<MarketState> {
  RPCClient? client;

  MarketCubit() : super(MarketState.uninitialized()) {
    _initialize();
  }
  Timer? _timer;

  void _initialize() async {
    emit(state.copyWith(loading: true));
    final markets = await _loadMarket();
    emit(
      state.copyWith(markets: markets, loading: false),
    );
  }

  void addPrice(String key, num value) {}

  void fetchPrice(String? marketName) async {
    if (marketName == 'USDC' || marketName == 'USDC') {
      return;
    }
    if (state.prices[marketName] != null) {
      return;
    }
    final price = await _fetchPrices(marketName);
    final newState =
        state.copyWith(prices: {...state.prices, marketName: price});
    emit(newState);
  }

  refresh() async {
    if (state.loading) {
      return;
    }
    _timer?.cancel();
    _timer = null;
  }

  Future<num?> _fetchPrices(String? marketName) async {
    try {
      final response = await http.get(
        Uri.parse('$_kSerumOrderBooks/$marketName'),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final results = json.decode(response.body)['data'];
        final asks = (results['asks'] as List<dynamic>)
            .map((map) => asStringKeyedMap(map))
            .toList();
        final bids = (results['bids'] as List<dynamic>)
            .map((map) => asStringKeyedMap(map))
            .toList();
        if (asks.length == 0 && bids.length == 0) {
          return null;
        } else if (asks.length == 0) {
          return bids.isNotEmpty ? bids[0]!['price'] as num? : null;
        } else if (bids.length == 0) {
          return asks.isNotEmpty ? asks[0]!['price'] as num? : null;
        } else {
          final mid =
              ((asks[0]!['price'] as num) + (bids[0]!['price'] as num)) / 2.0;
          return mid;
        }
      } else {
        final Map<String, dynamic>? resData = json.decode(response.body);
        print('GOT response: ${resData}');
        return null;
      }
    } catch (error) {
      print('error ${error}');
      return null;
    }
  }

  Future<void> close() async {
    _timer?.cancel();
    _timer = null;
    super.close();
  }

  Future<Map<String, Market>> _loadMarket() async {
    final marketJson = await rootBundle
        .loadString(_kMarketAssetPath)
        .then((jsonStr) => jsonDecode(jsonStr));
    return (marketJson as List)
        .map((market) => Market.fromMap(asStringKeyedMap(market)!))
        .toList()
        .fold<Map<String, Market>>({}, (previousValue, market) {
      final coin = market.name!.split('/')[0];
      if (previousValue[coin] != null) {
        if (!market.deprecated!) {
          previousValue[coin] = previousValue[coin]!.copyWith(
            publicKey: market.publicKey,
            name: market.name!.split('/').join(''),
            deprecated: market.deprecated,
          );
        }
      } else {
        previousValue[coin] = market.copyWith(
          name: market.name!.split('/').join(''),
        );
      }
      return previousValue;
    });
  }
}
