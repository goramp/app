import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/index.dart';

const _kClaimsLimit = 20;

class ClaimsCubitState extends Equatable {
  final bool initialized;
  final bool loading;
  final Object? error;
  final bool hasReachedMax;
  final List<RewardClaim>? claims;

  @override
  List<Object?> get props =>
      [loading, error, claims, initialized, hasReachedMax];
  ClaimsCubitState._(
      {this.loading = false,
      this.error,
      this.claims,
      this.initialized = false,
      this.hasReachedMax = false});
  ClaimsCubitState.uninitialized()
      : loading = false,
        error = null,
        claims = null,
        hasReachedMax = false,
        initialized = false;

  ClaimsCubitState onLoading({bool loading = true}) {
    return ClaimsCubitState._(
        loading: loading,
        error: null,
        claims: claims,
        hasReachedMax: hasReachedMax,
        initialized: this.initialized);
  }

  ClaimsCubitState onError({Object? error}) {
    return ClaimsCubitState._(
        loading: false,
        error: error,
        claims: null,
        initialized: this.initialized);
  }

  ClaimsCubitState onData({List<RewardClaim>? claims, bool? hasReachedMax}) {
    return ClaimsCubitState._(
        loading: false,
        error: null,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        claims: claims,
        initialized: this.initialized);
  }

  ClaimsCubitState copyWith(
      {bool? loading,
      Object? error,
      List<RewardClaim>? claims,
      bool? initialized}) {
    return ClaimsCubitState._(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        claims: claims ?? this.claims,
        initialized: initialized ?? this.initialized);
  }
}

class ClaimsCubit extends Cubit<ClaimsCubitState> {
  StreamSubscription<AuthenticationState>? _authListener;
  List<List<RewardClaim>>? _pages;
  RewardClaim? _lastItem;
  final Map<int, StreamSubscription> _pageSubscriptions = {};
  bool? _hasReachedMax;
  int _pageIndex = 0;
  
  ClaimsCubit(
    AuthenticationBloc authBloc,
  ) : super(ClaimsCubitState.uninitialized()) {
    _authListener = authBloc.stream.listen(this._handleAuth);
    _handleAuth(authBloc.state);
  }

  _handleAuth(AuthenticationState auth) async {
    if (auth is AuthAuthenticated) {
      _subscribeUser(auth.user!.id);
      emit(state.copyWith(initialized: true));
    }
    if (auth is AuthUnauthenticated) {
      _unsubscribe();
    }
  }

  _subscribeUser(String? uid) {
    emit(state.onLoading());
    _unsubscribe();
    final subscription = WalletService.getRewardClaims((event) {
      _handleDataLoaded(_pageIndex, event);
    }, limit: _kClaimsLimit);
    if (subscription != null) {
      _pageSubscriptions[_pageIndex] = subscription;
    }
  }

  void _unsubscribe() {
    _pageIndex = 0;
    _pageSubscriptions.forEach((key, value) {
      value.cancel();
    });
  }

  _handleDataLoaded(int page, List<RewardClaim> claims) {
    if (_pages == null) {
      _pages = [];
    }
    bool pageExists = page < _pages!.length;
    if (pageExists) {
      _pages![page] = claims;
    } else {
      _pages!.add(claims);
    }
    if (page == _pages!.length - 1) {
      if (_pages![page].isNotEmpty) {
        _lastItem = _pages![page].last;
      }
      _hasReachedMax = claims.isEmpty || claims.length < _kClaimsLimit;
    }
    _transformData();
  }

  void _transformData() {
    final all = _pages!.fold<List<RewardClaim>>(
        [], (previousValue, current) => previousValue..addAll(current));
    emit(state.onData(claims: all, hasReachedMax: _hasReachedMax));
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

    final subscription = WalletService.getRewardClaims((event) {
      _handleDataLoaded(_pageIndex, event);
    }, limit: _kClaimsLimit, last: _lastItem);
    if (subscription != null) {
      _pageSubscriptions[page] = subscription;
    }
  }

  Future<void> close() async {
    super.close();
    _unsubscribe();
    _authListener?.cancel();
  }
}
