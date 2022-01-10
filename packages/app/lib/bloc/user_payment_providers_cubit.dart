import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/payment_service.dart';

class UserPaymentProvidersState extends Equatable {
  final bool initialized;
  final bool loading;
  final Object? error;
  final List<UserPaymentProvider>? paymentProviders;

  @override
  List<Object?> get props => [loading, error, paymentProviders, initialized];
  UserPaymentProvidersState._(
      {this.loading = false,
      this.error,
      this.paymentProviders,
      this.initialized = false});
  UserPaymentProvidersState.uninitialized()
      : loading = false,
        error = null,
        paymentProviders = null,
        initialized = false;
  UserPaymentProvidersState copyWith(
      {bool? loading,
      Object? error,
      List<UserPaymentProvider>? paymentProviders,
      bool? initialized}) {
    return UserPaymentProvidersState._(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        paymentProviders: paymentProviders ?? this.paymentProviders,
        initialized: initialized ?? this.initialized);
  }
}

class UserPaymentProviderCubit extends Cubit<UserPaymentProvidersState> {
  StreamSubscription<AuthenticationState>? _authListener;
  StreamSubscription<List<UserPaymentProvider>>? _paymentProviders;
  UserPaymentProviderCubit(
    AuthenticationBloc authBloc,
  ) : super(UserPaymentProvidersState.uninitialized()) {
    _authListener = authBloc.stream.listen(this._handleAuth);
    _handleAuth(authBloc.state);
  }

  _handleAuth(AuthenticationState auth) async {
    if (auth is AuthAuthenticated) {
      _subscribeUser(auth.user!.id!);
      emit(state.copyWith(initialized: true));
    }
    if (auth is AuthUnauthenticated) {
      _paymentProviders?.cancel();
      emit(UserPaymentProvidersState.uninitialized());
    }
  }

  _subscribeUser(String uid) {
    _paymentProviders?.cancel();
    _paymentProviders = PaymentsService.getUserPaymentProvidersStream(uid)
        .listen((List<UserPaymentProvider> paymentProviders) {
      emit(state.copyWith(
          loading: false, paymentProviders: paymentProviders, error: null));
    }, onError: (error, stack) {
      emit(state.copyWith(loading: false, error: error));
    });
  }

  Future<void> close() async {
    super.close();
    _paymentProviders?.cancel();
    _authListener?.cancel();
  }
}
