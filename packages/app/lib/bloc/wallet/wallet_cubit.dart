import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/vendor/solana/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/solana.dart';

class WalletsState extends Equatable {
  final bool loading;
  final bool connecting;
  final bool connected;
  final Object? loadError;
  final Object? conenctionError;
  final String? userId;
  final WalletProvider? wallet;
  final WalletServiceAvailability? serviceAvailability;
  final List<TokenAccount>? tokenAccounts;

  @override
  List<Object?> get props => [
        loading,
        loadError,
        wallet,
        userId,
        serviceAvailability,
        tokenAccounts,
        connecting,
        connected,
        conenctionError,
      ];

  WalletsState(
      {this.loading = false,
      this.userId,
      this.loadError,
      this.conenctionError,
      this.wallet,
      this.serviceAvailability,
      this.tokenAccounts,
      this.connecting = false,
      this.connected = false});

  WalletsState onLoad() {
    return WalletsState(
        loading: true,
        loadError: null,
        conenctionError: conenctionError,
        connecting: connecting,
        connected: connected,
        wallet: wallet,
        userId: userId,
        serviceAvailability: serviceAvailability,
        tokenAccounts: tokenAccounts);
  }

  WalletsState onConnecting() {
    return WalletsState(
        connecting: true,
        connected: false,
        conenctionError: null,
        loading: loading,
        loadError: loadError,
        wallet: wallet,
        userId: userId,
        serviceAvailability: serviceAvailability,
        tokenAccounts: tokenAccounts);
  }

  WalletsState onConnected(WalletProvider wallet) {
    return WalletsState(
        connecting: false,
        connected: true,
        conenctionError: null,
        loading: loading,
        loadError: loadError,
        wallet: wallet,
        userId: userId,
        serviceAvailability: serviceAvailability,
        tokenAccounts: tokenAccounts);
  }

  WalletsState onConnectError(Object error) {
    return WalletsState(
      conenctionError: error,
      connecting: false,
      connected: false,
      wallet: null,
      loading: false,
      loadError: null,
      tokenAccounts: tokenAccounts,
      serviceAvailability: serviceAvailability,
      userId: userId,
    );
  }

  WalletsState onLoadError(Object error) {
    return WalletsState(
      loading: false,
      loadError: error,
      tokenAccounts: null,
      serviceAvailability: null,
      conenctionError: conenctionError,
      connecting: connecting,
      connected: connected,
      wallet: wallet,
      userId: userId,
    );
  }

  WalletsState loaded({
    List<TokenAccount>? tokenAccounts,
    WalletServiceAvailability? serviceAvailability,
  }) {
    return WalletsState(
      loading: false,
      loadError: null,
      tokenAccounts: tokenAccounts ?? this.tokenAccounts,
      serviceAvailability: serviceAvailability ?? this.serviceAvailability,
      userId: userId,
      connecting: connecting,
      connected: connected,
      conenctionError: conenctionError,
      wallet: wallet,
    );
  }

  WalletsState.uninitialized()
      : loading = false,
        loadError = null,
        wallet = null,
        connecting = false,
        connected = false,
        conenctionError = null,
        userId = null,
        serviceAvailability = null,
        tokenAccounts = null;

  WalletsState copyWith(
      {bool? loading,
      Object? loadError,
      WalletProvider? wallet,
      Object? conenctionError,
      bool? connecting,
      bool? connected,
      String? userId,
      WalletServiceAvailability? serviceAvailability,
      List<TokenAccount>? tokenAccounts}) {
    return WalletsState(
      loading: loading ?? this.loading,
      loadError: loadError ?? this.loadError,
      wallet: wallet ?? this.wallet,
      conenctionError: conenctionError ?? this.conenctionError,
      connecting: connecting ?? this.connecting,
      connected: connected ?? this.connected,
      userId: userId ?? this.userId,
      serviceAvailability: serviceAvailability ?? this.serviceAvailability,
      tokenAccounts: tokenAccounts ?? this.tokenAccounts,
    );
  }

  bool get hasLoadError => loadError != null;
  bool get hasConnectionError => conenctionError != null;
  bool get connectionPending => !connected || connecting;

  @override
  String toString() {
    return "$runtimeType[loading: $loading, loadError: $loadError, wallet: $wallet, conenctionError: $conenctionError, connecting: $connecting, connected: $connected, userId: $userId, serviceAvailability: $serviceAvailability, tokenAccounts: $tokenAccounts]";
  }
}

const _maxRefresh = 5000;
const _kMaxNumTrials = 10;

class WalletCubit extends Cubit<WalletsState> {
  MyAppModel? appModel;
  StreamSubscription<AuthenticationState>? _authListener;
  String? _userId;
  RPCClient _client;
  WalletProvider? _wallet;
  final WalletProvider defaultWalletProvider;
  
  WalletCubit(this.appModel, AuthenticationBloc authBloc,
      this.defaultWalletProvider,
      {RPCClient? client})
      : _client = client ?? RPCClient(appModel!.config.solanaRPCUrl!),
        super(WalletsState.uninitialized()) {
    _authListener = authBloc.stream.listen(this._handleAuth);
    _handleAuth(authBloc.state);
  }
  Timer? _timer;
  bool _disposed = false;
  List<int> _tokenAccountSubscriptions = [];

  bool _isPolling = true;
  int _pollErrorCount = 0;

  _handleAuth(AuthenticationState auth) async {
    if (auth is AuthAuthenticated) {
      if (_userId == auth.user!.id) {
        return;
      }
      _reset();
      _userId = auth.user!.id;
      // if (WalletProvider.getExternalWalletProviders(
      //         network: appModel?.config.solanaCluster)
      //     .isEmpty) {
      //   connect(defaultWalletProvider);
      // }
      //connect(defaultWalletProvider);
    }
    if (auth is AuthUnauthenticated) {
      _reset();
    }
  }

  _onConnect(address) {
    if (address != _wallet?.publicKey) {
      return;
    }
    emit(state.onConnected(_wallet!));
    _loadWallet();
    _wallet?.on('disconnect', _onDisconnect);
  }

  _onError(dynamic error) {
    if (!(error is WalletProviderException) || error.provider != _wallet) {
      return;
    }
    _wallet!.off('error', _onError);
    _wallet!.off('connect', _onConnect);
    _wallet = null;
    emit(state.onConnectError(error));
  }

  _onDisconnect(data) {
    _reset();
  }

  _unSubscribeTokenAccounts() async {
    _tokenAccountSubscriptions.map((e) {});
  }

  Future<void> connect(WalletProvider provider) async {
    try {
      if (_wallet == provider && (state.connected || state.connecting)) {
        return;
      }
      if (state.connected || state.connecting) {
        await disconnect();
      }
      emit(state.onConnecting());
      _wallet = provider;
      provider.on('connect', _onConnect);
      provider.on('error', _onError);
      await provider.connect();
    } catch (error) {
      provider.off('connect', _onConnect);
      provider.off('error', _onError);
      _wallet = null;
      emit(state.onConnectError(error));
    }
  }

  disconnect() async {
    try {
      if ((!state.connected)) {
        return;
      }
      await _wallet?.disconnect();
      _reset();
    } catch (error) {
      emit(state.onConnectError(error));
    }
  }

  refresh({bool force = false}) async {
    if (!state.connected) return;
    if (!force && state.loading) {
      return;
    }
    await _loadWallet();
  }

  Future<void> _loadWallet({int numRetries = 0}) async {
    try {
      _timer?.cancel();
      _timer = null;
      if (_disposed) {
        return;
      }
      if (!state.connected) {
        return;
      }
      final address = _wallet!.publicKey!;
      final tokens = await _fetchTokenAccounts(address);
      if (!state.connected || address != _wallet!.publicKey) {
        return;
      }
      emit(state.loaded(tokenAccounts: tokens));
      _scheduleRefreshTokens();
    } catch (error, stack) {
      Sentry.captureException(error, stackTrace: stack);
      final errorCount = numRetries + 1;
      if (errorCount < _kMaxNumTrials) {
        var waitTime = _retryDelay(retryNumber: errorCount);
        waitTime = math.min(waitTime, _maxRefresh);
        await Future.delayed(Duration(milliseconds: waitTime.toInt()), () => _loadWallet(numRetries: errorCount));
      } else {
        print(stack);
        emit(state.onLoadError(error));
        rethrow;
      }
    }
  }

  Future<void> _scheduleRefreshTokens() async {
    if (!_isPolling) return;
    var waitTime = _maxRefresh;
    if (_pollErrorCount > 0) {
      waitTime =
          math.min(_retryDelay(retryNumber: _pollErrorCount), _maxRefresh);
    }
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: waitTime.toInt()), _refreshTokens);
  }

  Future<void> _refreshTokens() async {
    try {
      _timer?.cancel();
      _timer = null;
      if (!_isPolling) {
        return;
      }
      if (_disposed) {
        return;
      }
      if (_userId == null || state == WalletsState.uninitialized()) {
        return;
      }
      if (!state.connected || state.wallet == null) {
        return;
      }
      final address = _wallet!.publicKey!;
      final tokens = await _fetchTokenAccounts(address);
      if (_userId == null ||
          state == WalletsState.uninitialized() ||
          address != _wallet!.publicKey) {
        return;
      }
      _pollErrorCount = 0;
      emit(state.loaded(tokenAccounts: tokens));
    } catch (error, stack) {
      Sentry.captureException(error, stackTrace: stack);
      print(stack);
      if (_isPolling) {
        _pollErrorCount++;
      }
    } finally {
      if (_timer == null) {
        _scheduleRefreshTokens();
      }
    }
  }

  Future<List<TokenAccount>> _fetchTokenAccounts(
      String walletAddress) async {
    Account? myNativeAccount = await _client.getAccountInfo(walletAddress);
    TokenAccount nativeToken = TokenAccount(
      walletAddress: walletAddress,
      address: walletAddress,
      owner: myNativeAccount?.owner,
      amount: BigInt.from(myNativeAccount?.lamports ?? 0),
      decimals: NATIVE_SOL.decimals,
      token: NATIVE_SOL,
    );
    final tokens = KURO_TOKENS[appModel!.config.solanaCluster!];
    final myTokens = (await _client.getTokenAccountsByOwner(
        owner: walletAddress, programId: TokenProgram.programId));
    List<TokenAccount> splTokens = (await Future.wait(
      tokens!.map<Future<TokenAccount?>>(
        (token) async {
          if (token == NATIVE_SOL) {
            return nativeToken;
          }
          final associatedAccount = myTokens.firstWhereOrNull((item) =>
              item.account.data?.maybeMap(
                  splToken: (splToken) {
                    return splToken.parsed.info.mint == token.mintAddress;
                  },
                  orElse: () => false) ??
              false);
          var address = associatedAccount?.address;
          if (associatedAccount == null) {
            if (token.deprecated) return null;
            final address = await findAssociatedTokenAddress(
                walletAddress, token.mintAddress!);
            return TokenAccount(
              walletAddress: walletAddress,
              address: address,
              owner: TokenProgram.programId,
              decimals: token.decimals,
              amount: BigInt.zero,
              token: token,
            );
          } else {
            //if (token.deprecated) return null;
            final tokenInfo = SPLTokenAccountInfo.fromSplTokenAccountData(
                associatedAccount.account);

            return TokenAccount(
              walletAddress: walletAddress,
              address: address!,
              token: token,
              owner: tokenInfo.owner,
              amount: tokenInfo.amount,
              decimals: tokenInfo.decimals,
            );
          }
        },
      ),
    ))
        .where((toten) => toten != null)
        .toList()
        .cast<TokenAccount>();
    return splTokens; //..add(nativeToken);
  }

  int _retryDelay({retryNumber = 1}) {
    final millis = math.pow(2, retryNumber - 1) * 1000;
    var rng = math.Random();
    return (millis + 1000 * rng.nextDouble()).toInt();
  }

  void _reset() {
    _unSubscribeTokenAccounts();
    _timer?.cancel();
    _timer = null;
    _userId = null;
    _wallet?.off('disconnect', _onDisconnect);
    _wallet?.off('connect', _onConnect);
    _wallet = null;
    emit(WalletsState.uninitialized());
  }

  Future<void> close() async {
    _reset();
    await _authListener?.cancel();
    _disposed = true;
    super.close();
  }
}
