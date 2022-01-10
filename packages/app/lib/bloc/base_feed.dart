import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:goramp/bloc/index.dart';
import 'package:bloc/bloc.dart';

const int _MAX_NUM_EVENTS = 15;

abstract class FeedEvent<Y> extends Equatable {
  List<Object> get props => [];
}

class FetchFeedItems<T> extends FeedEvent {
  final bool startAfterLast;
  FetchFeedItems({this.startAfterLast = true});
  List<Object> get props => [];
  @override
  String toString() => 'FetchFeedItems';
}

class SubscribeToFeed extends FeedEvent {
  SubscribeToFeed();
  String toString() => 'SubscribeToFeed';
}

class OnFeedItemsSnapshot<T> extends FeedEvent {
  final List<T> items;
  OnFeedItemsSnapshot(this.items);
  @override
  String toString() => 'OnFeedItemsSnapshot';
}

class OnFeedError extends FeedEvent {
  final Object? error;
  final StackTrace? stacktrace;
  OnFeedError({this.error, this.stacktrace});
  @override
  String toString() => 'OnFeedError';
}

abstract class FeedState<T> extends Equatable {}

class FeedUninitialized extends FeedState {
  List<Object> get props => [];
  @override
  String toString() => 'FeedUninitialized';
}

class FeedError extends FeedState {
  final Object? error;
  final StackTrace? stacktrace;
  FeedError({this.error, this.stacktrace});

  List<Object?> get props => [error, stacktrace];

  @override
  String toString() => 'FeedError';
}

class FeedLoaded<T> extends FeedState {
  final List<T> items;
  final bool hasReachedStartMax;
  final bool hasReachedMax;
  final bool isStartLoading;
  final bool isStartLoadingComplete;
  final bool isEndLoading;
  final bool isEndLoadingComplete;
  final bool isRefreshing;
  final Object? endError;
  final Object? startError;

  FeedLoaded(
      {this.items = const [],
      this.isStartLoading = false,
      this.isEndLoading = false,
      this.isRefreshing = false,
      this.isStartLoadingComplete = false,
      this.isEndLoadingComplete = false,
      this.hasReachedMax = false,
      this.hasReachedStartMax = false,
      this.endError,
      this.startError});

  List<Object?> get props => [
        items,
        hasReachedMax,
        isEndLoading,
        isStartLoading,
        isRefreshing,
        hasReachedStartMax,
        isEndLoadingComplete,
        isStartLoadingComplete,
        endError,
        startError
      ];

  FeedLoaded copyWith({
    List<T>? items,
    bool? hasReachedMax,
    bool? isStartLoading,
    bool? isEndLoading,
    bool? isRefreshing,
    bool? hasReachedStartMax,
    bool? isStartLoadingComplete,
    bool? isEndLoadingComplete,
    Object? startError,
    Object? endError,
  }) {
    return FeedLoaded(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isEndLoading: isEndLoading ?? this.isEndLoading,
      isStartLoading: isStartLoading ?? this.isStartLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasReachedStartMax: hasReachedStartMax ?? this.hasReachedStartMax,
      isStartLoadingComplete:
          isStartLoadingComplete ?? this.isStartLoadingComplete,
      isEndLoadingComplete: isEndLoadingComplete ?? this.isEndLoadingComplete,
      startError: startError ?? this.startError,
      endError: endError ?? this.endError,
    );
  }

  FeedLoaded copyWithStartError(Error? startError) {
    return FeedLoaded(
      items: this.items,
      hasReachedMax: this.hasReachedMax,
      isEndLoading: this.isEndLoading,
      isStartLoading: this.isStartLoading,
      isRefreshing: this.isRefreshing,
      hasReachedStartMax: this.hasReachedStartMax,
      isStartLoadingComplete: this.isStartLoadingComplete,
      isEndLoadingComplete: this.isEndLoadingComplete,
      startError: startError,
      endError: endError ?? this.endError,
    );
  }

  FeedLoaded copyWithEndError(Error? endError) {
    return FeedLoaded(
      items: this.items,
      hasReachedMax: this.hasReachedMax,
      isEndLoading: this.isEndLoading,
      isStartLoading: this.isStartLoading,
      isRefreshing: this.isRefreshing,
      hasReachedStartMax: this.hasReachedStartMax,
      isStartLoadingComplete: this.isStartLoadingComplete,
      isEndLoadingComplete: this.isEndLoadingComplete,
      startError: this.startError,
      endError: endError,
    );
  }

  bool get isPopulated => items.isNotEmpty;

  bool get isEmpty => items.isEmpty;

  @override
  String toString() => 'FeedLoaded { '
      'items: ${items.length}, '
      'hasReachedMax: $hasReachedMax, '
      'isStartLoading: $isEndLoading, '
      'isStartLoading: $isEndLoading, '
      'isRefreshing: $isRefreshing, '
      'hasReachedStartMax: $hasReachedStartMax, '
      'isStartLoadingComplete: $isStartLoadingComplete, '
      'startError: $startError, '
      'endError: $endError, '
      'isEndLoadingComplete: $isEndLoadingComplete}';
}

abstract class BaseFeedBloc<T> extends Bloc<FeedEvent, FeedState> {
  String? _userId;
  StreamSubscription? _subscription;
  StreamSubscription<AuthenticationState>? _authSubscription;
  bool useUsername;

  BaseFeedBloc({
    String? userId,
    AuthenticationBloc? authBloc,
    this.useUsername = true,
  })  : _userId = userId,
        super(FeedUninitialized()) {
    if (userId != null) {
      add(SubscribeToFeed());
    } else {
      _authSubscription = authBloc?.stream.listen(_handleUser);
      if (authBloc != null) {
        _handleUser(authBloc.state);
      }
    }
  }

  String? get userId => _userId;

  StreamSubscription? subscribeItems(String? userId, void onData(List<T> items),
      {void onError(error, StackTrace stackTrace)?, int? limit});

  Future<List<T>>? fetchItemsAfter(String? userId, {T? last, int? limit});

  Future<List<T>>? fetchItemsBefore(String? userId, {T? first, int? limit});

  Future<List<T>>? _fetchItemsAfter(T last, String? userId,
      {int limit = _MAX_NUM_EVENTS}) async {
    return fetchItemsAfter(userId, last: last, limit: limit)!;
  }

  Future<List<T>>? _fetchItemsBefore(T first, String? userId,
      {int limit = _MAX_NUM_EVENTS}) async {
    return fetchItemsBefore(userId, first: first, limit: limit)!;
  }

  void _subscribeItems({int limit = _MAX_NUM_EVENTS}) async {
    await _subscription?.cancel();
    _subscription =
        subscribeItems(userId, _onData, onError: _onError, limit: limit);
  }

  _onData(List<T> items) {
    add(OnFeedItemsSnapshot(items));
  }

  _onError(dynamic error, StackTrace stacktrace) {
    add(OnFeedError(error: error, stacktrace: stacktrace));
  }

  void _handleUser(AuthenticationState authState) {
    if (authState is AuthAuthenticated) {
      _userId = authState.user!.id;
      add(SubscribeToFeed());
    } else {
      _subscription?.cancel();
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _authSubscription?.cancel();
    return super.close();
  }

  bool _hasReachedMax(FeedState state) =>
      state is FeedLoaded<T> && state.hasReachedMax;

  bool _hasReachedStartMax(FeedState state) =>
      state is FeedLoaded<T> && state.hasReachedStartMax;

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is OnFeedItemsSnapshot) {
      yield FeedLoaded<T>(
          items: event.items as List<T>,
          hasReachedMax:
              event.items.isEmpty || event.items.length < _MAX_NUM_EVENTS);
      return;
    }
    if (event is SubscribeToFeed) {
      yield FeedUninitialized();
      _subscribeItems();
      return;
    }
    if (event is OnFeedError) {
      print('ERROR: ${event.error}');
      yield FeedError(error: event.error, stacktrace: event.stacktrace);
      return;
    }
    if (event is FetchFeedItems) {
      yield* _handleFetchEvent(event);
    }
  }

  Stream<FeedState> _handleFetchEvent(FetchFeedItems event) async* {
    try {
      if (event.startAfterLast) {
        if (!(state is FeedLoaded<T>) ||
            _hasReachedMax(state) ||
            (state as FeedLoaded<T>).isEndLoading) {
          return;
        }
        T last = (state as FeedLoaded).items.last as T;
        yield (state as FeedLoaded)
            .copyWith(isEndLoading: true, isEndLoadingComplete: false);
        List<T> items = await _fetchItemsAfter(last, _userId)!;
        if (items.isEmpty || items.length < _MAX_NUM_EVENTS) {
          yield (state as FeedLoaded).copyWith(
              hasReachedMax: true,
              isEndLoading: false,
              isEndLoadingComplete: true)
            ..copyWithEndError(null);
          return;
        }
        yield FeedLoaded<T>(
            items: (state as FeedLoaded).items.cast<T>() + items,
            hasReachedMax: false,
            isEndLoading: false,
            isEndLoadingComplete: true)
          ..copyWithEndError(null);
      } else {
        if (!(state is FeedLoaded) ||
            _hasReachedStartMax(state) ||
            (state as FeedLoaded).isStartLoading) {
          return;
        }
        T first = (state as FeedLoaded).items.first as T;
        yield (state as FeedLoaded)
            .copyWith(isStartLoading: true, isStartLoadingComplete: false);
        List<T> items = await _fetchItemsBefore(first, _userId)!;
        if (items.isEmpty || items.length < _MAX_NUM_EVENTS) {
          yield (state as FeedLoaded).copyWith(
              hasReachedStartMax: true,
              isStartLoading: false,
              isStartLoadingComplete: true)
            ..copyWithStartError(null);
          return;
        }
        yield FeedLoaded<T>(
            items: items + (state as FeedLoaded).items.cast<T>(),
            hasReachedStartMax: false,
            isStartLoadingComplete: true,
            isStartLoading: false)
          ..copyWithStartError(null);
      }
    } catch (error, stacktrace) {
      print("got error:$error, stacktrace: $stacktrace");
      if (state is FeedLoaded) {
        FeedLoaded loadedState = (state as FeedLoaded);
        if (loadedState.isStartLoading) {
          yield loadedState.copyWith(startError: error, isStartLoading: false);
        }
        if (loadedState.isEndLoading) {
          yield loadedState.copyWith(
            endError: error,
            isEndLoading: false,
          );
        }
        return;
      }
      print('ERROR: ${error}');
      yield FeedError(error: error, stacktrace: stacktrace);
    }
  }
}
