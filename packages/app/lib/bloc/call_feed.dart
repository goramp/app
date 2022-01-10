import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import '../models/index.dart';
import '../services/index.dart';
import '../utils/index.dart';

const int _MAX_NUM_EVENTS = 15;
const int _MAX_NUM_UPCOMING_EVENTS = 3;

abstract class CallFeedEvent extends Equatable {
  List<Object?> get props => [];
}

class FetchCallFeedItems extends CallFeedEvent {
  final bool startAfterLast;
  FetchCallFeedItems({this.startAfterLast = true});
  List<Object> get props => [];
  @override
  String toString() => 'FetchCallFeedItems';
}

class SubscribeCallFeed extends CallFeedEvent {
  final String? userId;
  SubscribeCallFeed(this.userId);
  List<Object?> get props => [userId];
  String toString() => 'SubscribeCallFeed';
}

class FilterCallFeed extends CallFeedEvent {
  final CallFeedBlocFilterType type;
  final String? userId;
  FilterCallFeed(this.userId, this.type);
  List<Object> get props => [type];
  String toString() => 'FilterCallFeed';
}

class OnUpcomingCallItemsSnapshot extends CallFeedEvent {
  final List<Call> items;
  final int? page;
  OnUpcomingCallItemsSnapshot(this.items, {this.page});
  List<Object?> get props => [items, page];
  @override
  String toString() => 'OnUpcomingCallItemsSnapshot';
}

class OnPastCallItemsSnapshot extends CallFeedEvent {
  final List<Call> items;
  final int page;
  OnPastCallItemsSnapshot(this.items, this.page);
  List<Object> get props => [items, page];
  @override
  String toString() => 'OnPastCallItemsSnapshot';
}

class OnCallFeedError extends CallFeedEvent {
  final Object? error;
  final StackTrace? stacktrace;
  OnCallFeedError({this.error, this.stacktrace});
  List<Object?> get props => [error, stacktrace];
  @override
  String toString() => 'OnCallFeedError';
}

abstract class CallFeedState extends Equatable {}

class CallFeedUninitialized extends CallFeedState {
  List<Object> get props => [];
  @override
  String toString() => 'CallFeedUninitialized';
}

class CallFeedError extends CallFeedState {
  final Object? error;
  final StackTrace? stacktrace;
  CallFeedError({this.error, this.stacktrace});

  List<Object?> get props => [error, stacktrace];

  @override
  String toString() => 'CallFeedError';
}

class CallFeedLoaded extends CallFeedState {
  final List<List<GroupedCallItem>> items;
  final bool hasReachedStartMax;
  final bool hasReachedMax;
  final bool isStartLoading;
  final bool isStartLoadingComplete;
  final bool isEndLoading;
  final bool isEndLoadingComplete;
  final bool isRefreshing;
  final bool isSearching;
  final Error? endError;
  final Error? startError;
  final String? query;

  CallFeedLoaded(
      {this.items = const [],
      this.isStartLoading = false,
      this.isEndLoading = false,
      this.isRefreshing = false,
      this.isSearching = false,
      this.isStartLoadingComplete = false,
      this.isEndLoadingComplete = false,
      this.hasReachedMax = false,
      this.hasReachedStartMax = false,
      this.endError,
      this.startError,
      this.query});

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
        startError,
        isSearching,
        query,
      ];

  CallFeedLoaded copyWith({
    List<GroupedCallItem>? items,
    bool? hasReachedMax,
    bool? isStartLoading,
    bool? isEndLoading,
    bool? isRefreshing,
    bool? hasReachedStartMax,
    bool? isStartLoadingComplete,
    bool? isEndLoadingComplete,
    Error? startError,
    Error? endError,
    bool? isSearching,
    String? query,
  }) {
    return CallFeedLoaded(
      items: items as List<List<GroupedCallItem>>? ?? this.items,
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
      isSearching: isSearching ?? this.isSearching,
      query: query ?? this.query,
    );
  }

  CallFeedLoaded copyWithStartError(Error startError) {
    return CallFeedLoaded(
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
      isSearching: this.isSearching,
      query: query ?? this.query,
    );
  }

  CallFeedLoaded copyWithEndError(Error endError) {
    return CallFeedLoaded(
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
      isSearching: this.isSearching,
      query: this.query,
    );
  }

  CallFeedLoaded copyWithQuery(String query) {
    return CallFeedLoaded(
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
      isSearching: this.isSearching,
      query: this.query,
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
      'isSearching: $isSearching, '
      'query: $query, '
      'isEndLoadingComplete: $isEndLoadingComplete}';
}

enum CallFeedBlocFilterType {
  all,
  buy,
  sell,
}

class CallFeedBloc extends Bloc<CallFeedEvent, CallFeedState> {
  StreamSubscription? _upcomingSubscription;
  StreamSubscription<AuthenticationState>? _userSubscription;
  final Call? initialItem;
  Call? _lastItem;
  List<Call>? _upcoming;
  List<List<Call>>? _pages;
  bool _hasReachedMax = false;
  final Map<int, StreamSubscription> _pageSubscriptions = {};
  CallFeedBlocFilterType _feedType;
  final AppConfig? config;
  User? _user;
  CallFeedBlocFilterType get feedType => _feedType;
  User? get user => _user;

  CallFeedBloc(AuthenticationBloc authState,
      {this.initialItem,
      CallFeedBlocFilterType feedType = CallFeedBlocFilterType.buy,
      this.config})
      : _feedType = feedType,
        super(CallFeedUninitialized()) {
    _userSubscription = authState.stream.listen(_handleUser);
    _handleUser(authState.state);
    // _recordChangeSubscription =
    //     recordingService.recordChangeStream.listen(_onRecordingChanged);
  }

  List<Call> get buy {
    return _upcoming ?? [];
  }

  List<List<Call>> get pastPages {
    return _pages ?? [];
  }

  void _subscribeItems(String? userId) async {
    _upcoming = null;
    _pages = null;
    if (_feedType == CallFeedBlocFilterType.all) {
      await _subscribeUpcoming(userId);
      await _subscribePast(userId);
    } else if (_feedType == CallFeedBlocFilterType.buy) {
      await _subscribeUpcoming(userId);
    } else {
      await _subscribePast(userId);
    }
  }

  Future<void> _subscribeUpcoming(
    String? userId,
  ) async {
    if (_feedType == CallFeedBlocFilterType.buy) {
      await Future.wait(
          _pageSubscriptions.values.map((value) => value.cancel()));
      _pageSubscriptions.clear();
      int pageIndex = 0;
      _pageSubscriptions[pageIndex] = CallService.getUpcomingCallsSubscription(
          userId,
          (List<Call> items) =>
              add(OnUpcomingCallItemsSnapshot(items, page: pageIndex)),
          onError: _onError,
          limit: _MAX_NUM_EVENTS);
    } else {
      await _upcomingSubscription?.cancel();
      _upcomingSubscription =
          CallService.getUpcomingCallsSubscription(userId, (List<Call> items) {
        add(OnUpcomingCallItemsSnapshot(items));
      }, onError: _onError, limit: _MAX_NUM_UPCOMING_EVENTS);
    }
  }

  Future<void> _subscribePast(
    String? userId,
  ) async {
    await Future.wait(_pageSubscriptions.values.map((value) => value.cancel()));
    _pageSubscriptions.clear();
    int pageIndex = 0;
    _pageSubscriptions[pageIndex] = CallService.getPastCallsSubscription(userId,
        (List<Call> items) => add(OnPastCallItemsSnapshot(items, pageIndex)),
        onError: _onError, limit: _MAX_NUM_EVENTS);
  }

  _onError(dynamic error, StackTrace stacktrace) {
    print("Error: $error");
    print("stacktrace: $stacktrace");
    ErrorHandler.report(error, stacktrace);
    add(OnCallFeedError(error: error, stacktrace: stacktrace));
  }

  void _handleUser(AuthenticationState state) {
    if (state is AuthAuthenticated) {
      _user = state.user;
      add(SubscribeCallFeed(_user!.id));
    } else {
      _user = null;
      _unsubscribeFeeds();
    }
  }

  Future<void> _unsubscribeFeeds() async {
    await _upcomingSubscription?.cancel();
    await Future.wait(_pageSubscriptions.values.map((value) => value.cancel()));
    _pageSubscriptions.clear();
  }

  @override
  Future<void> close() async {
    await _unsubscribeFeeds();
    await _userSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<CallFeedState> mapEventToState(CallFeedEvent event) async* {
    if (event is OnUpcomingCallItemsSnapshot) {
      yield* _handleUpcomingItemSnapshot(event);
    }
    if (event is OnPastCallItemsSnapshot) {
      yield* _handlePastItemSnapshot(event);
    }
    if (event is FilterCallFeed) {
      _feedType = event.type;
      yield CallFeedUninitialized();
      _subscribeItems(event.userId);
    }
    if (event is SubscribeCallFeed) {
      yield CallFeedUninitialized();
      _subscribeItems(event.userId);
    }
    if (event is OnCallFeedError) {
      yield* _handleError(event);
      return;
    }
    if (event is FetchCallFeedItems) {
      yield* _handleFetchEvent(event);
    }
  }

  Stream<CallFeedState> _handleError(OnCallFeedError error) async* {
    if (state is CallFeedLoaded) {
      CallFeedLoaded loadedState = state as CallFeedLoaded;
      if (loadedState.isStartLoading) {
        yield loadedState.copyWith(
            startError: error.error as Error?, isStartLoading: false);
      }
      if (loadedState.isEndLoading) {
        yield loadedState.copyWith(
          endError: error.error as Error?,
          isEndLoading: false,
        );
      }
    }
    print("got error:${error.error}, stacktrace: ${error.stacktrace}");
    yield CallFeedError(error: error.error, stacktrace: error.stacktrace);
  }

  // Future<List<Call>> _encrichWithRecordings(List<Call> schedules) async {
  //   try {
  //     final List<String> scheduleIds =
  //         schedules.map<String>((e) => e.id).toList();
  //     final Map<String, bool> recordings =
  //         await recordingService.listCallIdsWithRecordings(scheduleIds);
  //     final items = schedules
  //         .map((e) => e.copyWith(
  //             hasRecording: recordings[e.id] != null && recordings[e.id]))
  //         .toList();
  //     return items;
  //   } catch (error, stack) {
  //     print('Error: $error');
  //     print('stack: $stack');
  //     return [];
  //   }
  // }

  Stream<CallFeedState> _handleUpcomingItemSnapshot(
      OnUpcomingCallItemsSnapshot event) async* {
    //final items = await _encrichWithRecordings(event.items);
    yield* _handlePage(event.page!, event.items);
  }

  Stream<CallFeedState> _handlePage(int page, List<Call> items) async* {
    if (_pages == null) {
      _pages = [];
    }
    bool pageExists = page < _pages!.length;
    if (pageExists) {
      _pages![page] = items;
    } else {
      _pages!.add(items);
    }
    if (page == _pages!.length - 1) {
      if (_pages![page].isNotEmpty) {
        _lastItem = _pages![page].last;
      }
      _hasReachedMax = items.isEmpty || items.length < _MAX_NUM_EVENTS;
    }
    yield* _transformData();
  }

  Stream<CallFeedState> _handlePastItemSnapshot(
      OnPastCallItemsSnapshot event) async* {
    //final items = await _encrichWithRecordings(event.items);
    yield* _handlePage(event.page, event.items);
  }

  Stream<CallFeedState> _transformData() async* {
    List<List<GroupedCallItem>> all = [];
    if (_pages == null) {
      return;
    }
    var allPastPages = _pages!.fold<List<Call>>(
        [], (initialValue, pageItems) => initialValue..addAll(pageItems));
    if (allPastPages.isNotEmpty) {
      all = _group(allPastPages, false);
      // all.add(GroupedScheduleDividerItem());
    }
    yield CallFeedLoaded(
        items: all,
        hasReachedMax: _hasReachedMax,
        isEndLoading: false,
        isEndLoadingComplete: true);
  }

  List<List<GroupedCallItem>> _group(List<Call> schedules, bool active,
      {bool borderBottom = true}) {
    List<List<GroupedCallItem>> sections = [];
    Map<DateTime, List<Call>> groupedTransactions = groupBy<Call, DateTime>(
        schedules,
        (obj) => DateTime(obj.scheduledAt!.year, obj.scheduledAt!.month,
            obj.scheduledAt!.day));

    groupedTransactions.entries.forEach((MapEntry<DateTime, List<Call>> entry) {
      List<GroupedCallItem> grouped = [];
      bool isFirst = true;
      grouped.add(GroupedCallHeaderItem(
          dateTime: entry.key,
          schedules: entry.value,
          active: active,
          borderBottom: borderBottom,
          borderTop: !isFirst));
      isFirst = false;
      //grouped.add(GroupedScheduleDividerItem());
      grouped.addAll(
        entry.value.map(
          (Call schedule) =>
              GroupedCallListItem(schedule, schedules: entry.value),
        ),
      );
      // grouped.add(GroupedScheduleDividerItem());
      sections.add(grouped);
      // grouped.add(GroupedScheduleDividerItem());
    });
    return sections;
  }

  Stream<CallFeedState> _handleFetchEvent(FetchCallFeedItems event) async* {
    if (!(state is CallFeedLoaded) ||
        _hasReachedMax ||
        (state as CallFeedLoaded).isEndLoading) {
      return;
    }
    int page = _pages!.length;
    if (_pageSubscriptions[page] != null) {
      return;
    }
    yield (state as CallFeedLoaded)
        .copyWith(isEndLoading: true, isEndLoadingComplete: false);
    if (_feedType == CallFeedBlocFilterType.buy) {
      _pageSubscriptions[page] = CallService.getUpcomingCallsSubscription(
          user!.id, (List<Call> items) {
        add(OnUpcomingCallItemsSnapshot(items, page: page));
      }, onError: _onError, limit: _MAX_NUM_EVENTS, last: _lastItem);
    } else {
      _pageSubscriptions[page] =
          CallService.getPastCallsSubscription(user!.id, (List<Call> items) {
        add(OnPastCallItemsSnapshot(items, page));
      }, onError: _onError, limit: _MAX_NUM_EVENTS, last: _lastItem);
    }
  }
}
