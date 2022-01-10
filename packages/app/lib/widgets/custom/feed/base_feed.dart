import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/widgets/index.dart';
import 'package:sized_context/sized_context.dart';
import 'package:goramp/generated/l10n.dart';
import '../../../bloc/index.dart';

const kFeedScrollThreshold = 200.0;
const kGridSpacing = 1.0;

abstract class BaseFeedState<T extends StatefulWidget, Y> extends State<T> {
  BaseFeedBloc<Y> getBloc();

  Widget buildError(FeedError state);

  Widget? buildEmpty(FeedLoaded state);

  Widget buildResultSliver(FeedLoaded state);

  //List<Widget> buildHeaderSlivers();

  Widget buildLoadMoreSliver();

  bool onScroll(ScrollNotification notification) {
    final maxScroll = notification.metrics.maxScrollExtent;
    final currentScroll = notification.metrics.pixels;
    final bloc = getBloc();
    final FeedState<dynamic> state = bloc.state;

    if (state is FeedLoaded) {
      final hasReachedMax = state.hasReachedMax;
      if (hasReachedMax) return true;
    }
    // print("on scroll check: ${maxScroll - currentScroll} vs $kFeedScrollThreshold");
    if (maxScroll - currentScroll <= kFeedScrollThreshold) {
      bloc.add(FetchFeedItems());
    }
    return true;
  }

  void refresh() {
    final bloc = getBloc();
    bloc.add(SubscribeToFeed());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = getBloc();
    //List<Widget> header = buildHeaderSlivers();
    final loadMore = buildLoadMoreSliver();
    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, FeedState state) {
        Widget? body;
        if (state is FeedUninitialized) {
          body = const FeedLoader();
        } else if (state is FeedError) {
          body = buildError(state);
        } else if (state is FeedLoaded) {
          if (state.items.isEmpty) {
            body = buildEmpty(state);
          } else {
            body = CenteredWidget(
              CustomScrollView(
                //physics: ClampingScrollPhysics(),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    // This is the flip side of the SliverOverlapAbsorber above.
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  buildResultSliver(state),
                  SliverSafeArea(
                    top: false,
                    bottom: true,
                    sliver: loadMore,
                  ),
                ],
              ),
            );
          }
        } else {
          return Container();
        }
        return NotificationListener<ScrollNotification>(
          onNotification: onScroll,
          child: AnimatedSwitcher(
            duration: kThemeAnimationDuration,
            child: body,
          ),
        );
      },
    );
  }
}

abstract class BaseCallLinksTabState<T extends StatefulWidget, Y>
    extends BaseFeedState<T, Y> {
  Widget buildItem(BuildContext context, Y item, int index);

  @override
  Widget? buildEmpty(FeedLoaded state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return EmptyContent(
      title: Text(
        S.of(context).nothing_here,
        style: Theme.of(context).textTheme.caption,
        textAlign: TextAlign.center,
      ),
      icon: Icon(
        Icons.event_note_outlined,
        size: 96.0,
        color: isDark ? Colors.white38 : Colors.grey[300],
      ),
      action: ElevatedButton.icon(
        style: context.raisedStyle,
        icon: Icon(Icons.add),
        label: Text(S.of(context).new_call_link),
        onPressed: () {
          PagenavigationHelper.newCallLink(context);
        },
      ),
    );
  }

  int get gridCount {
    int count = 2;
    if (context.widthPx > PageBreaks.LargePhone) count = 3;
    if (context.widthPx > PageBreaks.TabletLandscape) count = 4;
    return count;
  }

  @override
  Widget buildResultSliver(FeedLoaded state) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        vertical: kGridSpacing,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridCount,
          mainAxisSpacing: kGridSpacing,
          crossAxisSpacing: kGridSpacing,
          childAspectRatio: 33 / 44,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final Y event = state.items[index];
            return buildItem(context, event, index);
          },
          childCount: state.items.length,
        ),
      ),
    );
  }

  @override
  Widget buildLoadMoreSliver() {
    return SliverToBoxAdapter(
      child: BottomFeedLoader(getBloc()),
    );
  }

  @override
  Widget buildError(FeedError state) {
    return FeedErrorView(
      error: S.of(context).fail_fetch_call_link,
      onRefresh: super.refresh,
    );
  }
}
