import 'dart:async';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/wallets/index.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class CryptoPriceState extends Equatable {
  final bool loading;
  final Object? error;
  final Map<String, ExchangeRate> rates;

  @override
  List<Object?> get props => [loading, error, rates];

  CryptoPriceState._({
    this.loading = false,
    this.error,
    this.rates = const {},
  });

  CryptoPriceState.loading()
      : loading = true,
        error = null,
        rates = const {};

  CryptoPriceState.uninitialized()
      : loading = false,
        error = null,
        rates = const {};

  CryptoPriceState copyWith({
    bool? loading,
    Object? error,
    Map<String, ExchangeRate>? rates,
  }) {
    return CryptoPriceState._(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      rates: rates ?? this.rates,
    );
  }

  bool get hasError => error != null;
}

class CryptoPriceCubit extends Cubit<CryptoPriceState> {
  StreamSubscription? _sub;
  String? _userId;
  StreamSubscription<AuthenticationState>? _authListener;

  CryptoPriceCubit(
    AuthenticationBloc authBloc,
  ) : super(CryptoPriceState.uninitialized()) {
    _authListener = authBloc.stream.listen(this._handleAuth);
    _handleAuth(authBloc.state);
  }

  _handleAuth(AuthenticationState auth) async {
    if (auth is AuthAuthenticated) {
      if (_userId == auth.user!.id) {
        return;
      }
      _userId = auth.user!.id;
      _subscribePrices();
    }
    if (auth is AuthUnauthenticated) {
      _sub?.cancel();
      emit(CryptoPriceState.uninitialized());
    }
  }

  void fetchPrices() async {
    emit(state.copyWith(loading: true, error: null));
    _subscribePrices();
  }

  Future<num?> _subscribePrices() async {
    await _sub?.cancel();
    _sub = CryptoPriceService.subscribeRates((rates) {
      emit(
        state.copyWith(rates: rates, loading: false, error: null),
      );
    }, onError: (error, stack) {
      emit(
        state.copyWith(loading: false, error: error),
      );
    });
  }

  Future<void> close() async {
    _authListener?.cancel();
    _sub?.cancel();
    super.close();
  }
}
