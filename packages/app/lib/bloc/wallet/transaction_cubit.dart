import 'dart:async';
import 'dart:math' as math;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goramp/models/token.dart';
import 'package:solana/solana.dart';

class TransactionsState extends Equatable {
  final bool loading;
  final Object? error;
  final List<ConfirmedSignature>? transactions;

  @override
  List<Object?> get props => [loading, error, transactions];
  TransactionsState._({
    this.loading = false,
    this.error,
    this.transactions,
  });

  TransactionsState.loading()
      : loading = true,
        error = null,
        transactions = null;

  TransactionsState.error(
    Object error,
  )   : loading = false,
        error = error,
        transactions = null;

  TransactionsState.loaded(
    List<ConfirmedSignature>? transactions,
  )   : loading = false,
        error = null,
        transactions = transactions;

  TransactionsState.uninitialized()
      : loading = false,
        error = null,
        transactions = null;
  TransactionsState copyWith(
      {bool? loading, Object? error, List<ConfirmedSignature>? transactions}) {
    return TransactionsState._(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      transactions: transactions ?? this.transactions,
    );
  }

  bool get hasError => error != null;
}

const _maxRefresh = 10000;

class TransactionsCubit extends Cubit<TransactionsState> {
  TokenAccount? tokenAccount;
  RPCClient client;
  TransactionsCubit(this.tokenAccount, this.client)
      : super(TransactionsState.uninitialized());
  Timer? _timer;
  int _errorCount = 0;
  static Map<String?, List<ConfirmedSignature>> transactionsCache = {};
  bool _disposed = false;

  loadTransactions() async {
    if (transactionsCache[tokenAccount!.address] != null) {
      emit(TransactionsState.loaded(transactionsCache[tokenAccount!.address]));
      _fetchTransactions();
      return;
    }
    if (state.loading) {
      return;
    }
    _timer?.cancel();
    _timer = null;
    emit(
      TransactionsState.loading(),
    );
    _fetchTransactions();
  }

  refresh() async {
    if (state.loading) {
      return;
    }
    _timer?.cancel();
    _timer = null;
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      _timer?.cancel();
      _timer = null;
      if (_disposed) {
        return;
      }
      final transactions = (await client
              .getConfirmedSignaturesForAddress2(tokenAccount!.address))
          .toList();
      transactionsCache[tokenAccount!.address] = transactions;
      _errorCount = 0;
      emit(TransactionsState.loaded(transactions));
      _scheduleRefreshTokens();
    } catch (error, stack) {
      _errorCount++;
      print('ERROR: $error');
      print(stack);
    } finally {
      _scheduleRefreshTokens();
    }
  }

  Future<void> _scheduleRefreshTokens() async {
    var waitTime = _maxRefresh;
    if (_errorCount > 0) {
      waitTime = math.min(_retryDelay(retryNumber: _errorCount), _maxRefresh);
    }
    _timer?.cancel();
    _timer =
        Timer(Duration(milliseconds: waitTime.toInt()), _fetchTransactions);
  }

  int _retryDelay({retryNumber = 1}) {
    final millis = math.pow(2, retryNumber - 1) * 1000;
    var rng = math.Random();
    return (millis + 1000 * rng.nextDouble()).toInt();
  }

  Future<void> close() async {
    _timer?.cancel();
    _timer = null;
    _disposed = true;
    super.close();
  }
}
