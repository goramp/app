import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:goramp/models/index.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/services/wallets/index.dart';
import 'package:goramp/utils/index.dart';

const BASE_TAKER_FEE_BPS = 0.0022;
const FEE_MULTIPLIER = 1 - BASE_TAKER_FEE_BPS;
const DEFAULT_SLIPPAGE_PERCENT = 0.5;

const kDefaultSwappableTokens = [
  KUROMain,
  NATIVE_SOL,
  USDTMain,
  KINMain,
];

class Swap extends ChangeNotifier {
  Swap(
      {double? fromAmount,
      double? toAmount,
      Token? fromMint,
      Token? toMint,
      this.swappableTokens = kDefaultSwappableTokens}) {
    _fromMint = fromMint;
    _toMint = toMint;
    _fromAmount = fromAmount ?? 0.0;
    _toAmount = toAmount ?? 0.0;
    _subscribeMarkets();
  }

  StreamSubscription? _marketSub;
  Token? _fromMint;
  Token? _toMint;
  num _slippage = DEFAULT_SLIPPAGE_PERCENT;
  double _fromAmount = 0;
  double _toAmount = 0;
  double? _fair;
  Map<String, Market> _markets = {};
  bool _isClosingNewAccounts = true;
  bool _isStrict = false;
  num? _fairOverride;
  Token? get fromMint => _fromMint;
  num? get fair => _fair;
  final List<Token> swappableTokens;
  List<Market>? _routes;
  List<Market>? get routes => _routes;

  void swap() {
    final oldFrom = fromMint;
    final oldTo = toMint;
    final oldToAmount = toAmount;
    _fromMint = oldTo;
    _toMint = oldFrom;
    _fromAmount = oldToAmount;
    _fair = getFair();
    _setFromAmount(_fromAmount);
  }

  Future<void> _subscribeMarkets() async {
    await _marketSub?.cancel();
    _marketSub = CryptoPriceService.subscribeMarkets((markets) {
      _markets = markets;
      _setFair();
    });
  }

  double? getFair() {
    double? fair;
    _routes = _getRoute();
    if (_routes == null) {
      return fair;
    }
    final fromBBO = _routes![0].bbo;
    final fromMarket = _routes![0];
    final toBBO = _routes!.length > 1 ? _routes![1].bbo : null;
    if (_routes!.length == 1) {
      if (fromMarket.baseMintAddress == _fromMint?.mintAddress ||
          (fromMarket.baseMintAddress == WSOL.mintAddress &&
              _fromMint?.mintAddress == NATIVE_SOL.mintAddress)) {
        fair = fromBBO?.bestBid != null ? 1.0 / fromBBO!.bestBid! : null;
      } else {
        fair =
            fromBBO?.bestOffer != null ? fromBBO!.bestOffer!.toDouble() : null;
      }
    } else {
      if (toBBO == null ||
          fromBBO == null ||
          toBBO.bestOffer == null ||
          fromBBO.bestBid == null) {
        return null;
      }
      fair = toBBO.bestOffer! / fromBBO.bestBid!;
    }
    return fair;
  }

  void _setFair() {
    final fair = getFair();
    if (fair == _fair) return;
    _fair = fair;
    _setFromAmount(_fromAmount);
  }

  String? _wrappedMint(Token? token) =>
      token == NATIVE_SOL ? WSOL.mintAddress : token?.mintAddress;

  List<Market>? _getRoute() {
    if (_fromMint?.mintAddress == USDCMain.mintAddress) {
      final market = _wrappedMint(_toMint) != null
          ? _markets.values.firstWhereOrNull((market) =>
              market.baseMintAddress == _wrappedMint(_toMint) &&
              market.quoteMintAddress == USDCMain.mintAddress)
          : null;
      if (market != null) {
        return [market];
      }
      // } else if (_wrappedMint(_fromMint) == WSOL.mintAddress) {
      //   final market = _wrappedMint(_toMint) != null
      //       ? _markets.values.firstWhereOrNull((market) =>
      //           market.baseMintAddress == _wrappedMint(_toMint) &&
      //           market.quoteMintAddress == WSOL.mintAddress)
      //       : null;
      //   if (market != null) {
      //     return [market];
      //   }
    } else if (_toMint?.mintAddress == USDCMain.mintAddress) {
      final market = _wrappedMint(_fromMint) != null
          ? _markets.values.firstWhereOrNull(
              (market) => market.baseMintAddress == _wrappedMint(_fromMint))
          : null;
      if (market != null) {
        return [market];
      }
      // } else if (_wrappedMint(_toMint) == WSOL.mintAddress) {
      //   final market = _wrappedMint(_fromMint) != null
      //       ? _markets.values.firstWhereOrNull((market) =>
      //           market.baseMintAddress == _wrappedMint(_fromMint) &&
      //           market.quoteMintAddress == WSOL.mintAddress)
      //       : null;
      //   if (market != null) {
      //     return [market];
      //   }
    } else {
      final fromMarket = _wrappedMint(_fromMint) != null
          ? _markets.values.firstWhereOrNull(
              (market) => market.baseMintAddress == _wrappedMint(_fromMint))
          : null;
      final toMarket = _wrappedMint(_toMint) != null
          ? _markets.values.firstWhereOrNull(
              (market) => market.baseMintAddress == _wrappedMint(_toMint))
          : null;
      if (fromMarket == null || toMarket == null) {
        return null;
      }
      return [fromMarket, toMarket];
    }
    return null;
  }

  set fromMint(Token? fromMint) {
    if (fromMint == _fromMint) {
      return;
    }
    _fromMint = fromMint;
    _setFair();
    notifyListeners();
  }

  Token? get toMint => _toMint;
  set toMint(Token? toMint) {
    if (toMint == _toMint) {
      return;
    }
    _toMint = toMint;
    _setFair();
    notifyListeners();
  }

  double get fromAmount => _fromAmount;
  set fromAmount(double fromAmount) {
    if (fromAmount == _fromAmount) {
      return;
    }
    _setFromAmount(fromAmount);
  }

  void _setFromAmount(double fromAmount) {
    if (fair == null) {
      _fromAmount = 0.0;
      _toAmount = 0.0;
      notifyListeners();
      return;
    }
    _fromAmount = fromAmount;
    _toAmount = FEE_MULTIPLIER * (fromAmount / fair!);
    notifyListeners();
  }

  double get toAmount => _toAmount;
  set toAmount(double toAmount) {
    if (toAmount == _toAmount) {
      return;
    }
    if (fair == null) {
      _fromAmount = 0.0;
      _toAmount = 0.0;
      notifyListeners();
      return;
    }
    _toAmount = toAmount;
    _fromAmount = (toAmount * fair!) / FEE_MULTIPLIER;
    notifyListeners();
  }

  num get slippage => _slippage;
  set slippage(num slippage) {
    if (slippage == _slippage) {
      return;
    }
    _slippage = slippage;
    notifyListeners();
  }

  bool get isClosingNewAccounts => _isClosingNewAccounts;
  set isClosingNewAccounts(bool isClosingNewAccounts) {
    if (isClosingNewAccounts == _isClosingNewAccounts) {
      return;
    }
    _isClosingNewAccounts = isClosingNewAccounts;
    notifyListeners();
  }

  bool get isStrict => _isStrict;
  set isStrict(bool isStrict) {
    if (isStrict == _isStrict) {
      return;
    }
    _isStrict = isStrict;
    notifyListeners();
  }

  num? get fairOverride => _fairOverride;
  set fairOverride(num? fairOverride) {
    if (fairOverride == _fairOverride) {
      return;
    }
    _fairOverride = fairOverride;
    notifyListeners();
  }

  bool get canSwap {
    return fair != null &&
        fair! > 0 &&
        fromMint != toMint &&
        fromAmount > 0 &&
        toAmount > 0 &&
        _routes != null;
  }

  @override
  void dispose() {
    _marketSub?.cancel();
    super.dispose();
  }
}
