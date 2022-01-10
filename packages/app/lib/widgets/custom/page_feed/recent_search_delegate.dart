import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/widgets/custom/page_feed/call_feed_list_item.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:provider/provider.dart';
import '../../custom/index.dart';
import '../../helpers/index.dart';
import '../../../bloc/index.dart';
import '../../../models/index.dart';

//LoadMoreSearchCalls
Widget _buildLoadingSliver(
  BuildContext context,
) {
  return SliverPadding(
    padding: EdgeInsets.all(24.0),
    sliver: SliverToBoxAdapter(
      child: FeedLoader(),
    ),
  );
}

Widget _buildLoadMore(
  BuildContext context,
) {
  return SliverToBoxAdapter(
    child: Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: SizedBox(
          width: 36,
          height: 36,
          child: PlatformCircularProgressIndicator(
              Theme.of(context).colorScheme.secondary),
        ),
      ),
    ),
  );
}

Widget _buildErrorSliver(BuildContext context, VoidCallback onRefresh) {
  return SliverFillViewport(
    delegate: SliverChildBuilderDelegate((BuildContext c, int index) {
      return Center(
        child: FeedErrorView(
          error: S.of(context).search_failed,
          onRefresh: onRefresh,
        ),
      );
    }, childCount: 1),
  );
}

Widget _buildNoResultSliver(BuildContext context) {
  return SliverFillViewport(
    delegate: SliverChildBuilderDelegate((BuildContext c, int index) {
      return Center(
        child: Text(
          S.of(context).no_result_found,
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Theme.of(context).textTheme.caption!.color),
          textAlign: TextAlign.center,
        ),
      );
    }, childCount: 1),
  );
}

class _InitialSuggestions extends StatefulWidget {
  const _InitialSuggestions();
  @override
  State<StatefulWidget> createState() {
    return _InitialSuggestionsState();
  }
}

class _InitialSuggestionsState extends State<_InitialSuggestions> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_onScroll);
  }

  @override
  dispose() {
    controller.removeListener(_onScroll);
    controller.dispose();
    super.dispose();
  }

  _onScroll() {
    if (!controller.hasClients) {
      return;
    }
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;
    CallFeedState state = BlocProvider.of<CallFeedBloc>(context).state;
    if (state is CallFeedLoaded) {
      bool hasReachedMax = state.hasReachedMax;
      if (hasReachedMax) return;
    }
    // print("on scroll check: ${maxScroll - currentScroll} vs $kFeedScrollThreshold");
    if (maxScroll - currentScroll <= kFeedScrollThreshold) {
      BlocProvider.of<CallFeedBloc>(context).add(FetchCallFeedItems());
    }
  }

  Widget _buildInitialSuggestion(BuildContext context) {
    final fill = const SliverToBoxAdapter(
      child: SizedBox.shrink(),
    );
    return BlocBuilder(
      bloc: BlocProvider.of<CallFeedBloc>(context),
      builder: (BuildContext context, CallFeedState state) {
        Widget body;
        if (state is CallFeedUninitialized) {
          body = _buildLoadingSliver(context);
        } else if (state is CallFeedError) {
          body = _buildErrorSliver(context, () {
            MyAppModel model = Provider.of<MyAppModel>(context);
            User? user = model.currentUser;
            if (user == null) return;
            BlocProvider.of<CallFeedBloc>(context)
                .add(SubscribeCallFeed(user.id));
          });
        } else if (state is CallFeedLoaded) {
          if (state.isEmpty) {
            body = _buildNoResultSliver(context);
          } else {
            body = SliverList(
              //itemExtent: 116,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container();
                  //CallFeedListItem(state.items[index]);
                },
                childCount: state.items.length,
              ),
            );
          }
        } else {
          body = fill;
        }
        return CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            body,
            if (state is CallFeedLoaded && !state.hasReachedMax)
              _buildLoadMore(context)
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildInitialSuggestion(context);
  }
}

class _Result extends StatefulWidget {
  final String query;
  const _Result(this.query);
  @override
  State<StatefulWidget> createState() {
    return _ResultState();
  }
}

class _ResultState extends State<_Result> {
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.addListener(_onScroll);
  }

  @override
  dispose() {
    controller.removeListener(_onScroll);
    controller.dispose();
    super.dispose();
  }

  _onScroll() {
    if (!controller.hasClients) {
      return;
    }
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;
    SearchState state = Provider.of<SearchBloc>(context).state;
    bool hasReachedMax = state.hasReachedMax;
    if (hasReachedMax) return;
    // print("on scroll check: ${maxScroll - currentScroll} vs $kFeedScrollThreshold");
    if (maxScroll - currentScroll <= kFeedScrollThreshold) {
      Provider.of<SearchBloc>(context).add(LoadMoreSearch());
    }
  }

  Widget _buildResultStream(BuildContext context) {
    return BlocBuilder(
      bloc: Provider.of<SearchBloc>(context),
      builder: (BuildContext context, SearchState state) {
        Widget body;
        if (state.hasError) {
          body = _buildErrorSliver(context, () {
            Provider.of<SearchBloc>(context).add(
              SearchQuery(query: widget.query, enforceMinQueryLenth: false),
            );
          });
        } else if (!state.isSearching && state.isEmpty) {
          body = _buildNoResultSliver(context);
        } else {
          body = SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return CallFeedListItem(state.items[index]);
              },
              childCount: state.items.length,
            ),
          );
        }
        return CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            body,
            if (state.isPopulated && !state.hasReachedMax)
              _buildLoadMore(context)
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildResultStream(context);
  }
}

class RecentCallDelegate extends FeedSearchDelegate<Call> {
  final SearchBloc? searchBloc;

  RecentCallDelegate(
    this.searchBloc, {
    String hintText = "Search",
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: ThemeHelper.backgroudColor(context),
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Theme.of(context).brightness,
      primaryTextTheme: theme.textTheme,
    );
  }

  void showResults(BuildContext context) {
    super.showResults(context);
    searchBloc!.add(SearchQuery(query: query, enforceMinQueryLenth: false));
  }

  @override
  Widget buildLeading(BuildContext context) => BackButton(
        key: const ValueKey('SearchExit'),
        onPressed: () {
          Provider.of<MyAppModel>(
            context,
            listen: false,
          ).onSearchPage = false;
        },
      );

  Widget _loader() {
    return const FeedLoader(
      size: 18,
      strokeWidth: 2.0,
    );
  }

  Widget _buildLoader(BuildContext context) {
    final emptyEl = const SizedBox.shrink();
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: StreamBuilder<SearchState>(
          stream: searchBloc!.stream,
          builder: (BuildContext context, AsyncSnapshot<SearchState> snapshot) {
            final state = snapshot.data;
            Widget body;
            if (state != null && state.isSearching) {
              body = _loader();
            } else {
              body = emptyEl;
            }
            return body;
          }),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Container(
        width: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildLoader(context),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: query.isNotEmpty
                  ? () {
                      query = '';
                      showSuggestions(context);
                    }
                  : null,
            ),
          ],
        ),
      )
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      searchBloc!.add(SearchQuery(query: query));
    }
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: query.isEmpty ? const _InitialSuggestions() : _Result(query),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: query.isEmpty ? const _InitialSuggestions() : _Result(query),
    );
  }
}
