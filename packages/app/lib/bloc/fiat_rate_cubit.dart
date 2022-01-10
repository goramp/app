import 'dart:async';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/fiat_rate_service.dart';
import 'package:goramp/services/wallets/index.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class FiatRatesState extends Equatable {
  final bool loading;
  final Object? error;
  final Map<String, double> rates;

  @override
  List<Object?> get props => [loading, error, rates];

  FiatRatesState._({
    this.loading = false,
    this.error,
    this.rates = const {},
  });

  FiatRatesState.loading()
      : loading = true,
        error = null,
        rates = const {};

  FiatRatesState.uninitialized()
      : loading = false,
        error = null,
        rates = const {};

  FiatRatesState copyWith({
    bool? loading,
    Object? error,
    Map<String, double>? rates,
  }) {
    return FiatRatesState._(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      rates: rates ?? this.rates,
    );
  }

  bool get hasError => error != null;
}

class FiatRatesCubit extends Cubit<FiatRatesState> {
  StreamSubscription? _sub;
  String? _userId;
  StreamSubscription<AuthenticationState>? _authListener;

  FiatRatesCubit(
    AuthenticationBloc authBloc,
  ) : super(FiatRatesState.uninitialized()) {
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
      emit(FiatRatesState.uninitialized());
    }
  }

  void fetchPrices() async {
    emit(state.copyWith(loading: true, error: null));
    _subscribePrices();
  }

  Future<num?> _subscribePrices() async {
    await _sub?.cancel();
    _sub = FiatRatesService.subscribeRates((rates) {
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
