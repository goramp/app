import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../models/index.dart';
import '../app_config.dart';
import '../services/search.dart';

class SearchResult extends Equatable {
  final List items;
  List get props => [items];
  SearchResult.empty({this.items = const []});

  SearchResult(this.items);

  bool get isPopulated => items.isNotEmpty;

  bool get isEmpty => items.isEmpty;
}

class SearchResultCache {
  final Map<String, SearchResponse> results = {};
  SearchResultCache();
}

class SearchState extends Equatable {
  List get props => [];
}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
  final Object error;
  SearchError(this.error);
  List get props => [error];
}

class SearchNoTerm extends SearchState {}

class SearchEmpty extends SearchState {}

class SearchPopulated extends SearchState {
  final SearchResult result;
  final bool? loading;
  List get props => [result];
  SearchPopulated(this.result, {this.loading});

  SearchPopulated copyWith({
    SearchResult? result,
    bool? loading,
  }) {
    return SearchPopulated(
      result ?? this.result,
      loading: loading ?? this.loading,
    );
  }
}

abstract class AutoCompleteSearchBloc {
  final AppConfig config;
  late ValueStream<SearchState> state;
  final PublishSubject<String> _query = PublishSubject<String>();

  AutoCompleteSearchBloc(this.config) {
    state = _query
        .distinct()
        .debounce((_) => TimerStream(true, Duration(milliseconds: 250)))
        .switchMap<SearchState>((String term) {
      return _search(term);
    }).shareValueSeeded(SearchNoTerm());
  }

  Future<SearchService?> get searchService;
  int get page;
  int get limit;
  String get filters;
  Future<SearchResult?> suggestion(String query);

  Sink<String> get onTextChanged => _query.sink;
  ValueStream<String> get query => _query.stream.shareValue();

  void dispose() {
    _query.close();
  }

  SearchResult transformResponse(SearchResponse response);

  Stream<SearchState> _search(String term) async* {
    if (term.isEmpty) {
      yield SearchNoTerm();
    } else {
      if (state.value is SearchPopulated) {
        yield (state.value as SearchPopulated).copyWith(loading: true);
      } else {
        yield SearchLoading();
      }
      try {
        SearchResult? result = await suggestion(term);
        if (result != null && result.isPopulated) {
          yield SearchPopulated(result, loading: true);
        }
        final service = await (searchService as FutureOr<SearchService>);
        final response = await service.search(term,
            limit: limit, page: page, filters: filters);
        result = transformResponse(response);
        if (result.isEmpty) {
          yield SearchEmpty();
        } else {
          yield SearchPopulated(result);
        }
      } catch (e, stack) {
        print(stack);
        print(e);
        yield SearchError(e);
      }
    }
  }
}
