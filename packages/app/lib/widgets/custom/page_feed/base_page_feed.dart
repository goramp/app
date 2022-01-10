import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../../../bloc/preview.dart';
import '../../../bloc/index.dart';
import '../../../models/index.dart';
import '../../utils/index.dart';
import '../platform_circular_progress_indicator.dart';

typedef OnEventSelected = void Function(CallLink event);
typedef FeedItemBuilder = Widget Function(
    BuildContext context, FeedLoaded state, int index, int page);

typedef BaseFeedItemBuilder<T> = Widget Function(
    BuildContext context, T item, int index);

class EmptyPageFeed extends StatelessWidget {
  final String message;
  EmptyPageFeed(this.message);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.caption!.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}

class BottomPageFeedLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: TILE_ITEM_WIDTH,
      child: Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      ),
    );
  }
}

class HorizontalFeedScroller extends StatefulWidget {
  final BaseFeedBloc? bloc;
  final FeedLoaded feed;
  final FeedItemBuilder? feedItemBuilder;
  final double? itemExtent;
  final ValueNotifier<int> page;
  final EdgeInsets padding;
  HorizontalFeedScroller(
      {Key? key,
      this.bloc,
      required this.feed,
      ValueNotifier<int>? page,
      this.feedItemBuilder,
      this.itemExtent,
      this.padding = kHorizontalListPadding})
      : this.page = page ?? ValueNotifier<int>(0),
        super(key: key);

  @override
  _HorizontalFeedScroller createState() {
    return _HorizontalFeedScroller();
  }
}

class _HorizontalFeedScroller extends State<HorizontalFeedScroller> {
  final _scrollThreshold = 200.0;
  ScrollController? _scrollController;

  initState() {
    super.initState();
    int offset = widget.page.value;
    _scrollController =
        ScrollController(initialScrollOffset: offset * widget.itemExtent!);
    _scrollController!.addListener(_onScroll);
    widget.page.addListener(_handlePageChange);
  }

  @override
  void didUpdateWidget(HorizontalFeedScroller oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page != widget.page) {
      oldWidget.page.removeListener(_handlePageChange);
      widget.page.addListener(_handlePageChange);
    }
  }

  _handlePageChange() {
    SchedulerBinding.instance!.addPostFrameCallback((Duration duration) {
      if (!_scrollController!.hasClients) return;
      _scrollController!.animateTo(widget.page.value * widget.itemExtent!,
          duration: kThemeAnimationDuration, curve: Curves.fastOutSlowIn);
    });
  }

  void _onRefresh() async {
    FeedState state = widget.bloc!.state;
    if (state is FeedLoaded && state.hasReachedStartMax) {
      // _refreshController.refreshCompleted();
      return;
    }
    widget.bloc!.add(FetchFeedItems(startAfterLast: false));
  }

  void _onLoading() async {
    FeedState state = widget.bloc!.state;
    if (state is FeedLoaded && state.hasReachedMax) {
      // _refreshController.loadComplete();
      return;
    }
    widget.bloc!.add(FetchFeedItems());
  }

  void _onScroll() {
    if (!_scrollController!.hasClients) return;
    final maxScroll = _scrollController!.position.maxScrollExtent;
    final currentScroll = _scrollController!.position.pixels;
    FeedState state = widget.bloc!.state;
    if (state is FeedLoaded && state.hasReachedMax) {
      return;
    }
    if (maxScroll - currentScroll <= _scrollThreshold) {
      widget.bloc!.add(FetchFeedItems());
    }
  }

  Widget _buildLoader() {
    ThemeData theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      width: 50,
      child: Center(
        child: SizedBox(
            width: 33,
            height: 33,
            child:
                PlatformCircularProgressIndicator(theme.colorScheme.secondary)),
      ),
    );
  }

  void _blocListener(BuildContext context, FeedState state) {
    if (state is FeedLoaded) {
      if (state.startError != null) {}
      if (state.isStartLoadingComplete) {}
      if (state.endError != null) {}
      if (state.isEndLoadingComplete) {}
      return;
    }
  }

  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.bloc,
      listener: _blocListener,
      child: Container(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          itemExtent: widget.itemExtent,
          padding: widget.padding,
          itemCount: widget.feed.items.length,
          itemBuilder: (BuildContext context, int index) {
            return ValueListenableBuilder(
              valueListenable: widget.page,
              builder: (BuildContext context, int page, Widget? child) {
                return widget.feedItemBuilder!(
                    context, widget.feed, index, page);
              },
            );
          },
        ),
      ),
    );
  }
}

abstract class BaseFeedWidget extends StatefulWidget {
  final ValueNotifier<int> page;
  final ValueChanged<int>? onSelected;
  final double itemExtent;
  final EdgeInsets padding;
  BaseFeedWidget({
    ValueNotifier<int>? page,
    this.onSelected,
    this.padding = kHorizontalListPadding,
    this.itemExtent = TILE_ITEM_WIDTH,
    Key? key,
  })  : this.page = page ?? ValueNotifier<int>(0),
        super(key: key);
}

abstract class BasePageFeedState<T extends BaseFeedWidget, Y> extends State<T> {
  BaseFeedBloc<Y> getBloc();

  int compare(Y a, Y b);

  int? _findPage() {
    BaseFeedBloc bloc = getBloc();
    FeedState state = bloc.state;
    Y? selection = _getItemForPageController();
    if (state is FeedLoaded && selection != null) {
      return binarySearch<Y>(state.items as List<Y>, selection,
          compare: compare);
    }
    return null;
  }

  Y? _getItemForPageController() {
    int currentPage = widget.page.value;
    BaseFeedBloc bloc = getBloc();
    FeedState state = bloc.state;
    if (state is FeedLoaded && currentPage < state.items.length) {
      return state.items[currentPage];
    }
    return null;
  }

  _maybeSwitchPreviewPage() {
    int? index = _findPage();
    if (index != null && index >= 0) {
      _changePage(index);
    }
  }

  Widget buildItem(BuildContext context, FeedLoaded state, int index,
      bool isSelected, double width);

  bool hasState(PageControllerPreviewState state);

  bool equal(Y a, Y b);

  int get currentPage {
    return widget.page.value;
  }

  Widget _buildItem(
      BuildContext context, FeedLoaded state, int index, int page) {
    bool isSelected = (page == index);
    return buildItem(context, state, index, isSelected, widget.itemExtent);
  }

  onSelected(FeedLoaded state, int index) {
    _changePage(index);
  }

  Widget buildLoader(FeedUninitialized state);

  Widget buildError(FeedError state);

  Widget buildEmpty(FeedLoaded state);

  void _changePage(int index) {
    if (widget.onSelected != null) {
      widget.onSelected!(index);
    }
  }

  void refresh() {
    final bloc = getBloc();
    MyAppModel model = context.read();
    User? currentUser = model.currentUser;
    final userId = currentUser?.id;
    if (userId == null) return;
    bloc.add(SubscribeToFeed());
  }

  @override
  Widget build(BuildContext context) {
    BaseFeedBloc<Y> bloc = getBloc();
    return BlocListener(
      bloc: bloc,
      listener: (BuildContext context, FeedState state) {
        if (state is FeedLoaded) {
          _maybeSwitchPreviewPage();
        }
      },
      child: BlocBuilder(
          bloc: bloc,
          builder: (BuildContext context, FeedState state) {
            Widget body;
            if (state is FeedUninitialized) {
              body = KeyedSubtree(
                key: ValueKey<FeedState>(state),
                child: buildLoader(state),
              );
            } else if (state is FeedError) {
              body = KeyedSubtree(
                key: ValueKey<FeedState>(state),
                child: buildError(state),
              );
            } else if (state is FeedLoaded) {
              if (state.items.isEmpty) {
                body = KeyedSubtree(
                  key: ValueKey<FeedState>(state),
                  child: buildEmpty(state),
                );
              } else {
                body = KeyedSubtree(
                  key: ValueKey<FeedState>(state),
                  child: HorizontalFeedScroller(
                      bloc: getBloc(),
                      padding: widget.padding,
                      feed: state,
                      page: widget.page,
                      feedItemBuilder: _buildItem,
                      itemExtent: widget.itemExtent),
                );
              }
            } else {
              return Container();
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: body,
            );
          }),
    );
  }
}
