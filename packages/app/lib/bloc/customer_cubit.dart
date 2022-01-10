import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/customer.dart';
import 'package:goramp/services/payment_service.dart';

class MyCustomerState extends Equatable {
  final bool initialized;
  final bool loading;
  final Object? error;
  final Customer? customer;

  @override
  List<Object?> get props => [loading, error, customer, initialized];
  MyCustomerState._(
      {this.loading = false,
      this.error,
      this.customer,
      this.initialized = false});
  MyCustomerState.uninitialized()
      : loading = false,
        error = null,
        customer = null,
        initialized = false;
  MyCustomerState copyWith(
      {bool? loading, Object? error, Customer? customer, bool? initialized}) {
    return MyCustomerState._(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        customer: customer ?? this.customer,
        initialized: initialized ?? this.initialized);
  }
}

class MyCustomerCubit extends Cubit<MyCustomerState> {
  StreamSubscription<AuthenticationState>? _authListener;
  StreamSubscription<Customer?>? _customer;
  MyCustomerCubit(
    AuthenticationBloc authBloc,
  ) : super(MyCustomerState.uninitialized()) {
    _authListener = authBloc.stream.listen(this._handleAuth);
    _handleAuth(authBloc.state);
  }

  _handleAuth(AuthenticationState auth) async {
    if (auth is AuthAuthenticated) {
      _subscribeUser(auth.user!.id);
      emit(state.copyWith(initialized: true));
    }
    if (auth is AuthUnauthenticated) {
      _customer?.cancel();
      emit(MyCustomerState.uninitialized());
    }
  }

  _subscribeUser(String? uid) {
    _customer?.cancel();
    _customer =
        PaymentsService.getCustomerStream(uid).listen((Customer? customer) {
      emit(state.copyWith(loading: false, customer: customer, error: null));
    }, onError: (error, stack) {
      emit(state.copyWith(loading: false, error: error));
    });
  }

  Future<void> close() async {
    super.close();
    _customer?.cancel();
    _authListener?.cancel();
  }
}
