import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/payment_transactions_service.dart';

const _kTransactionsLimit = 20;

class PaymentTransactionsState extends Equatable {
  final bool initialized;
  final bool loading;
  final Object? error;
  final bool hasReachedMax;
  final List<PaymentTransaction>? transactions;

  @override
  List<Object?> get props =>
      [loading, error, transactions, initialized, hasReachedMax];
  PaymentTransactionsState._(
      {this.loading = false,
      this.error,
      this.transactions,
      this.initialized = false,
      this.hasReachedMax = false});
  PaymentTransactionsState.uninitialized()
      : loading = false,
        error = null,
        transactions = null,
        hasReachedMax = false,
        initialized = false;

  PaymentTransactionsState onLoading({bool loading = true}) {
    return PaymentTransactionsState._(
        loading: loading,
        error: null,
        transactions: transactions,
        hasReachedMax: hasReachedMax,
        initialized: this.initialized);
  }

  PaymentTransactionsState onError({Object? error}) {
    return PaymentTransactionsState._(
        loading: false,
        error: error,
        transactions: null,
        initialized: this.initialized);
  }

  PaymentTransactionsState onData(
      {List<PaymentTransaction>? transactions, bool? hasReachedMax}) {
    return PaymentTransactionsState._(
        loading: false,
        error: null,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        transactions: transactions,
        initialized: this.initialized);
  }

  PaymentTransactionsState copyWith(
      {bool? loading,
      Object? error,
      List<PaymentTransaction>? transactions,
      bool? initialized}) {
    return PaymentTransactionsState._(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        transactions: transactions ?? this.transactions,
        initialized: initialized ?? this.initialized);
  }
}

class PaymentTransactionsCubit extends Cubit<PaymentTransactionsState> {
  StreamSubscription<AuthenticationState>? _authListener;
  List<List<PaymentTransaction>>? _pages;
  PaymentTransaction? _lastItem;
  final Map<int, StreamSubscription> _pageSubscriptions = {};
  bool? _hasReachedMax;
  int _pageIndex = 0;
  String? _userId;
  PaymentTransactionsCubit(
    AuthenticationBloc authBloc,
  ) : super(PaymentTransactionsState.uninitialized()) {
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
      _unsubscribe();
    }
  }

  _subscribeUser(String? uid) {
    emit(state.onLoading());
    _unsubscribe();
    _pageSubscriptions[_pageIndex] =
        PaymentTransactionService.getPaymemtTransactionsSubscription(uid,
            (transactions) {
      _handleDataLoaded(_pageIndex, transactions);
    }, limit: _kTransactionsLimit);
  }

  void _unsubscribe() {
    _pageIndex = 0;
    _pageSubscriptions.forEach((key, value) {
      value.cancel();
    });
  }

  _handleDataLoaded(int page, List<PaymentTransaction> transactions) {
    if (_pages == null) {
      _pages = [];
    }
    bool pageExists = page < _pages!.length;
    if (pageExists) {
      _pages![page] = transactions;
    } else {
      _pages!.add(transactions);
    }
    if (page == _pages!.length - 1) {
      if (_pages![page].isNotEmpty) {
        _lastItem = _pages![page].last;
      }
      _hasReachedMax =
          transactions.isEmpty || transactions.length < _kTransactionsLimit;
    }
    _transformData();
  }

  void _transformData() {
    final all = _pages!.fold<List<PaymentTransaction>>(
        [], (previousValue, current) => previousValue..addAll(current));
    emit(state.onData(transactions: all, hasReachedMax: _hasReachedMax));
  }

  void loadMore() {
    if (state.hasReachedMax || state.loading) {
      return;
    }
    int page = _pages!.length;
    if (_pageSubscriptions[page] != null) {
      return;
    }
    emit(state.onLoading());
    _pageSubscriptions[page] =
        PaymentTransactionService.getPaymemtTransactionsSubscription(_userId,
            (List<PaymentTransaction> items) {
      _handleDataLoaded(page, items);
    }, limit: _kTransactionsLimit, last: _lastItem);
  }

  Future<void> close() async {
    super.close();
    _unsubscribe();
    _authListener?.cancel();
  }
}
