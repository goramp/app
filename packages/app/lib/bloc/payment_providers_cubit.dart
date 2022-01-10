import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/payment_provider.dart';
import 'package:goramp/services/payment_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class PaymentProvidersState extends Equatable {
  final bool initialized;
  final bool loading;
  final Object? error;
  final List<PaymentProvider>? paymentProviders;

  @override
  List<Object?> get props => [loading, error, paymentProviders, initialized];
  PaymentProvidersState._(
      {this.loading = false,
      this.error,
      this.paymentProviders,
      this.initialized = false});
  PaymentProvidersState.uninitialized()
      : loading = false,
        error = null,
        paymentProviders = null,
        initialized = false;
  PaymentProvidersState copyWith(
      {bool? loading,
      Object? error,
      List<PaymentProvider>? paymentProviders,
      bool? initialized}) {
    return PaymentProvidersState._(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        paymentProviders: paymentProviders ?? this.paymentProviders,
        initialized: initialized ?? this.initialized);
  }
}

const _maxRefresh = 5000;
const _kMaxNumTrials = 10;

class PaymentProviderCubit extends Cubit<PaymentProvidersState> {
  StreamSubscription<AuthenticationState>? _authListener;
  StreamSubscription<List<PaymentProvider>>? _paymentProviders;
  String? _userId;
  final AppConfig config;
  Timer? _refreshTimer;

  PaymentProviderCubit(
    this.config,
    AuthenticationBloc authBloc,
  ) : super(PaymentProvidersState.uninitialized()) {
    _authListener = authBloc.stream.listen(this._handleAuth);
    _handleAuth(authBloc.state);
  }

  _handleAuth(AuthenticationState auth) async {
    if (auth is AuthAuthenticated) {
      _userId = auth.user!.id;
      _subscribeUser(auth.user!.id);
      emit(state.copyWith(initialized: true));
    }
    if (auth is AuthUnauthenticated) {
      _userId = null;
      _paymentProviders?.cancel();
      emit(PaymentProvidersState.uninitialized());
    }
  }

  _subscribeUser(String? uid) async {
    if (uid == null) return;
    await _paymentProviders?.cancel();
    emit(state.copyWith(loading: true, error: null));
    _paymentProviders = PaymentsService.getPaymentProvidersStream().listen(
        (List<PaymentProvider> paymentProviders) {
      emit(state.copyWith(
          loading: false, paymentProviders: paymentProviders, error: null));
    }, onError: (error, stack) {
      emit(state.copyWith(loading: false, error: error));
    });
  }

  fetchPaymentProviders() async {
    if (state.loading) return;
    await _subscribeUser(_userId);
  }

  _doFecthPaymentProvider({int numRetries = 0}) async {
    try {
      if (state.loading) return;
      state.copyWith(loading: true, error: null);
      final paymentProviders =
          await PaymentsService.getPaymentProviders(config);
      state.copyWith(
          loading: false, paymentProviders: paymentProviders, error: null);
    } catch (error, stack) {
      Sentry.captureException(error, stackTrace: stack);
      final errorCount = numRetries + 1;
      if (errorCount < _kMaxNumTrials) {
        var waitTime = _retryDelay(retryNumber: errorCount);
        waitTime = math.min(waitTime, _maxRefresh);
        _refreshTimer?.cancel();
        _refreshTimer = Timer(Duration(milliseconds: waitTime.toInt()),
            () => _doFecthPaymentProvider(numRetries: errorCount));
      } else {
        print('error: $error');
        print(stack);
        state.copyWith(loading: false, paymentProviders: [], error: error);
        throw error;
      }
    }
  }

  int _retryDelay({retryNumber = 1}) {
    final millis = math.pow(2, retryNumber - 1) * 1000;
    var rng = math.Random();
    return (millis + 1000 * rng.nextDouble()).toInt();
  }

  Future<void> close() async {
    super.close();
    _paymentProviders?.cancel();
    _authListener?.cancel();
    _refreshTimer?.cancel();
  }
}
