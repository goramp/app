import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:goramp/app_config.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import '../models/index.dart';
import '../services/index.dart';
import '../utils/index.dart';
import 'autocomplete_search.dart';
import 'call_feed.dart';

const int _MAX_NUM_EVENTS = 15;
const _kSearchApiKey = 'schedules_search_key';
const _kSearchIndex = 'schedules';

abstract class SearchEvent extends Equatable {
  List<Object?> get props => [];
}

class SearchQuery extends SearchEvent {
  final String? query;
  final bool enforceMinQueryLenth;
  SearchQuery({this.query, this.enforceMinQueryLenth = true});
  List<Object?> get props => [query];
  @override
  String toString() => 'SearchScheduleFeedItems';
}

class _Query extends SearchEvent {
  final String? query;
  _Query(this.query);
  List<Object?> get props => [query];
  @override
  String toString() => '_Query';
}

class SearchOpen extends SearchEvent {
  final bool open;
  SearchOpen({this.open = false});
  List<Object> get props => [open];
  @override
  String toString() => 'SearchOpen';
}

class SearchResultHeight extends SearchEvent {
  final double resultHeight;
  SearchResultHeight({this.resultHeight = 0});
  List<Object> get props => [resultHeight];
  @override
  String toString() => 'SearchResultHeight';
}

class LoadMoreSearch extends SearchEvent {
  LoadMoreSearch();
  List<Object> get props => [];
  @override
  String toString() => 'LoadMoreSearchSchedules';
}

class SearchState extends Equatable {
  final List<GroupedCallItem> items;
  final bool hasReachedMax;
  final bool isSearching;
  final bool isOpen;
  final double resultHeight;
  final String? query;
  final Object? error;
  final StackTrace? stacktrace;

  SearchState({
    this.items = const [],
    this.isSearching = false,
    this.hasReachedMax = false,
    this.query,
    this.isOpen = false,
    this.resultHeight = 0,
    this.error,
    this.stacktrace,
  });

  SearchState.uninitialized() : this();

  bool get hasError => error != null;

  List<Object?> get props => [
        items,
        hasReachedMax,
        isSearching,
        query,
        isOpen,
        resultHeight,
        error,
        stacktrace,
      ];

  SearchState copyWith({
    List<GroupedCallItem>? items,
    bool? hasReachedMax,
    bool? isSearching,
    String? query,
    bool? isOpen,
    double? resultHeight,
    Object? error,
    StackTrace? stacktrace,
  }) {
    return SearchState(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isSearching: isSearching ?? this.isSearching,
      query: query ?? this.query,
      isOpen: isOpen ?? this.isOpen,
      resultHeight: resultHeight ?? this.resultHeight,
      error: error ?? this.error,
      stacktrace: stacktrace ?? this.stacktrace,
    );
  }

  SearchState copyWithQuery(String query) {
    return SearchState(
        items: this.items,
        hasReachedMax: this.hasReachedMax,
        isSearching: this.isSearching,
        query: this.query,
        isOpen: this.isOpen,
        resultHeight: this.resultHeight,
        error: this.error,
        stacktrace: this.stacktrace);
  }

  bool get isPopulated => items.isNotEmpty;

  bool get isEmpty => items.isEmpty;

  @override
  String toString() => 'SearchScheduleFeedLoaded { '
      'items: ${items.length}, '
      'hasReachedMax: $hasReachedMax, '
      'isSearching: $isSearching, '
      'query: $query, '
      'isOpen: $isOpen, '
      'resultHeight: $resultHeight, '
      'error: $error, '
      'stacktrace: $stacktrace, ';
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  bool _hasReachedMax = false;
  String? _query;
  final AppConfig? config;
  SearchService? _searchService;
  SearchResponse? _searchResponse;
  List<Call> _results = [];
  CallFeedBlocFilterType feedType;

  final PublishSubject<String?> _querySub = PublishSubject<String?>();
  StreamSubscription<String?>? _querySubscription;
  SearchBloc({this.config, this.feedType = CallFeedBlocFilterType.all})
      : super(SearchState.uninitialized()) {
    _querySubscription = _querySub
        .distinct()
        .debounce((_) => TimerStream(true, Duration(milliseconds: 250)))
        .listen((query) {
      add(_Query(query));
    });
  }

  String? get query => _query;
  bool get hasQuery => _query != null && _query!.isNotEmpty;
  bool get isOpen => state.isOpen;

  Future<SearchService?> get searchService async {
    if (_searchService == null) {
      _searchService = await initSearch(config!);
    }
    return _searchService;
  }

  static Future<SearchService> initSearch(AppConfig config) async {
    String? apiKey = await StorageService.read(
        key: _kSearchApiKey, iosAppGroupId: config.iosAppGroupId);
    if (apiKey == null || apiKey.isEmpty) {
      apiKey = await CallService.getSearchApiKey(config.baseApiUrl);
      await StorageService.write(
          key: _kSearchApiKey,
          value: apiKey,
          iosAppGroupId: config.iosAppGroupId);
    }
    final env = AppConfig.flavorToString(config.flavor);
    return SearchService(
        config: config, apiKey: apiKey, index: '${_kSearchIndex}_$env');
  }

  @override
  Future<void> close() {
    _querySub.close();
    _querySubscription?.cancel();
    return super.close();
  }

  // @override
  // Stream<Transition<SearchEvent, SearchState>> transformEvents(
  //     myEvents, transitionFn) {
  //   return super.transformEvents(
  //       myEvents.debounceTime(Duration(milliseconds: 250)), transitionFn);
  // }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchQuery) {
      _querySub.add(event.query);
    }
    if (event is _Query) {
      yield* _handleInitialSearch(event.query);
    }
    if (event is SearchOpen) {
      yield state.copyWith(isOpen: event.open);
    }
    if (event is SearchResultHeight) {
      yield state.copyWith(resultHeight: event.resultHeight);
    }
    if (event is LoadMoreSearch) {
      yield* _handleLoadMoreSearch(event);
    }
  }

  Stream<SearchState> _handleInitialSearch(String? query) async* {
    _query = query;
    _searchResponse = null;
    _results = [];
    _hasReachedMax = false;
    if (_query!.isEmpty) {
      yield SearchState.uninitialized();
      return;
    }
    yield state.copyWith(isSearching: true);
    yield* _search(_query);
  }

  Stream<SearchState> _handleLoadMoreSearch(LoadMoreSearch event) async* {
    if (_query == null || _query!.isEmpty) {
      return;
    }
    if (_hasReachedMax) {
      return;
    }
    if (state.isSearching) {
      return;
    }
    yield state.copyWith(isSearching: true);
    _search(_query);
  }

  static String filterForFeedType(CallFeedBlocFilterType feedType) {
    switch (feedType) {
      case CallFeedBlocFilterType.buy:
        return 'status = 1';
      case CallFeedBlocFilterType.sell:
        return 'status = 2';
      default:
        return '';
    }
  }

  Stream<SearchState> _search(String? query) async* {
    try {
      final service = await searchService;
      if (service == null) {
        return;
      }
      SearchResponse response;
      if (_searchResponse == null) {
        response = await service.search(query,
            limit: _MAX_NUM_EVENTS,
            page: 0,
            filters: filterForFeedType(feedType));
      } else {
        response = await service.search(query,
            limit: _MAX_NUM_EVENTS,
            page: _searchResponse!.page! + 1,
            filters: filterForFeedType(feedType));
      }
      if (_query != query) {
        return;
      }
      _searchResponse = response;
      _results = [
        ..._results,
        if (_searchResponse != null && _searchResponse!.hits != null)
          ..._searchResponse!.hits!.map((schedule) {
            return Call.fromMap(asStringKeyedMap(schedule)!);
          }).toList()
      ];
      final map = groupByStatus(_results);
      final buy = map[kSectionKeyUpcoming] ?? [];
      final sell = map[kSectionKeyPast] ?? [];
      _hasReachedMax = _searchResponse!.page! + 1 == _searchResponse!.nbPages;
      yield* _transformData(buy, sell, feedType);
    } on SearchException catch (e, stack) {
      print('error: $e');
      yield state.copyWith(error: e, stacktrace: stack, isSearching: false);
    } catch (e, stack) {
      print('stack: $stack');
      print('error: $e');
      yield state.copyWith(error: e, stacktrace: stack, isSearching: false);
    }
  }

  Stream<SearchState> _transformData(List<Call> buy, List<Call> sell,
      CallFeedBlocFilterType feedType) async* {
    final filteredUpcomigItems = applyQueryFilter(_query, buy);
    final filteredPastItems = applyQueryFilter(_query, sell);
    yield SearchState(
      items: getAllItems(filteredUpcomigItems, filteredPastItems, feedType),
      hasReachedMax: _hasReachedMax,
      isSearching: false,
    );
  }

  static List<GroupedCallItem> getAllItems(
      List<Call> buy, List<Call> sell, CallFeedBlocFilterType feedType) {
    List<GroupedCallItem> all = [];
    if (feedType == CallFeedBlocFilterType.all) {
      if (buy.isNotEmpty) {
        all.add(GroupedCallSectionHeaderItem(
            key: kSectionKeyUpcoming,
            description: kSectionKeyUpcoming,
            showSeeAll: false));
        all.addAll(group(buy, true));
      }
      if (sell.isNotEmpty) {
        all.add(GroupedCallSectionHeaderItem(
            key: kSectionKeyPast,
            description: kSectionKeyPast,
            showSeeAll: false));
        all.addAll(group(sell, false));
      }
    } else if (feedType == CallFeedBlocFilterType.buy) {
      if (buy.isNotEmpty) {
        all.addAll(group(buy, true));
      }
    } else if (feedType == CallFeedBlocFilterType.sell) {
      if (sell.isNotEmpty) {
        all.addAll(group(sell, false));
      }
    }
    if (all.length > 0) all.add(GroupedScheduleDividerItem());
    return all;
  }

  static List<Call> applyQueryFilter(String? query, List<Call> schedules) {
    if (query == null) {
      return schedules;
    }
    final term = query.toLowerCase();

    return schedules
        .where((schedule) =>
            schedule.title!.toLowerCase().contains(term) ||
            schedule.hostUsername!.contains(term) ||
            (schedule.guestUsername != null &&
                schedule.guestUsername!.contains(term)))
        .toList();
  }

  static Map<String, List<Call>> groupByStatus(List<Call> schedules) {
    return groupBy<Call, String>(schedules, (schedule) {
      final status = Call.stringFromCallStatus(schedule.status);
      if (status == CallStatus.pending) {
        return kSectionKeyUpcoming;
      } else {
        return kSectionKeyPast;
      }
    });
  }

  static group(List<Call> schedules, bool active,
      {bool borderBottom = true, bool borderTop = true}) {
    List<GroupedCallItem> grouped = [];
    Map<DateTime, List<Call>> groupedTransactions = groupBy<Call, DateTime>(
        schedules,
        (obj) => DateTime(obj.scheduledAt!.year, obj.scheduledAt!.month,
            obj.scheduledAt!.day));
    bool isFirst = true;

    groupedTransactions.entries.forEach((MapEntry<DateTime, List<Call>> entry) {
      grouped.add(GroupedCallHeaderItem(
          dateTime: entry.key,
          schedules: entry.value,
          active: active,
          borderBottom: borderBottom,
          borderTop: isFirst ? false : borderTop));
      isFirst = false;
      //grouped.add(GroupedScheduleDividerItem());
      grouped.addAll(
        entry.value.map(
          (Call schedule) =>
              GroupedCallListItem(schedule, schedules: entry.value),
        ),
      );
      // grouped.add(GroupedScheduleDividerItem());
    });
    return grouped;
  }
}

class ScheduleAutocompletSearchBloc extends AutoCompleteSearchBloc {
  SearchService? _searchService;
  CallFeedBlocFilterType feedType;

  ScheduleAutocompletSearchBloc(AppConfig config,
      {this.feedType = CallFeedBlocFilterType.all})
      : super(config);

  int get page => 0;
  int get limit => _MAX_NUM_EVENTS;

  String get cachePrefix => _kSearchIndex;
  String get filters => SearchBloc.filterForFeedType(feedType);

  Future<SearchService?> get searchService async {
    if (_searchService == null) {
      _searchService = await SearchBloc.initSearch(config);
    }
    return _searchService;
  }

  Future<SearchResult?> suggestion(String query) async {
    // final sell = pastPages?.fold<List<Call>>(List<Call>(),
    //         (initialValue, pageItems) => initialValue..addAll(pageItems)) ??
    //     [];
    // final items = SearchBloc.getAllItems(
    //     SearchBloc.applyQueryFilter(query, upcomingItems),
    //     SearchBloc.applyQueryFilter(query, sell));
    // return SearchResult(items);
    return null;
  }

  SearchResult transformResponse(SearchResponse response) {
    final map = SearchBloc.groupByStatus(response.hits!.map((schedule) {
      return Call.fromMap(asStringKeyedMap(schedule)!);
    }).toList());
    final buy = map[kSectionKeyUpcoming] ?? [];
    final sell = map[kSectionKeyPast] ?? [];
    final items = SearchBloc.getAllItems(buy, sell, feedType);
    return SearchResult(items);
  }
}
