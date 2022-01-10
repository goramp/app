import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:goramp/widgets/custom/page_feed/call_feed_list_item.dart';
import 'package:goramp/widgets/index.dart';
import 'package:qr_utils/qr_utils.dart';
import 'package:universal_platform/universal_platform.dart';
import '../../../bloc/index.dart';
import '../../../models/index.dart';
import 'feed_search_button.dart';
import 'package:goramp/generated/l10n.dart';

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate({this.isScrolled = false});
  final bool isScrolled;
  @override
  double get minExtent => 26;

  @override
  double get maxExtent => 26;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      elevation:
          0, //isScrolled || (shrinkOffset > maxExtent - minExtent) ? 2.0 : 0,
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Container(
            width: double.infinity,
            child: CallListRow(
              parentWidth: constraints.biggest.width,
            ),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return true;
  }
}

class _AppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  final Size preferredSize;

  _AppBarBottom() : this.preferredSize = Size.fromHeight(26.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      // color: Colors.amber,
      child: LayoutBuilder(
        builder: (_, constraints) {
          return CallListRow(
            parentWidth: constraints.biggest.width,
          );
        },
      ),
    );
  }
}

class CallFeedList extends StatelessWidget {
  final CallFeedBloc bloc;
  final String title;
  final ScrollController? controller;
  final String emptyText;
  final FeedSearchDelegate? delegate;
  final ValueChanged<int>? onChanged;
  final Widget? scheduleFilter;
  final int? selection;

  CallFeedList(
    this.bloc,
    this.title, {
    this.controller,
    this.emptyText = '',
    Key? key,
    this.delegate,
    this.onChanged,
    this.selection,
    this.scheduleFilter,
  }) : super(key: key);

  Widget _buildEmptySliver(BuildContext context, CallFeedLoaded state) {
    return SliverToBoxAdapter(
      child: EmptyContent(
        title: AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          child: Text(
            emptyText,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
        ),
        icon: const EmptyIcons(),
        action: ElevatedButton.icon(
          style: context.raisedStyle,
          icon: Icon(Icons.add),
          label: Text(S.of(context).new_call_link),
          onPressed: () {
            PagenavigationHelper.newCallLink(context);
          },
        ),
      ),
    );
  }

  void _refresh(BuildContext context) {
    MyAppModel model = context.read();
    User? currentUser = model.currentUser;
    final userId = currentUser?.id;
    if (userId == null) return;
    bloc.add(SubscribeCallFeed(userId));
  }

  Widget _buildErrorSliver(CallFeedError state, BuildContext context) {
    return SliverToBoxAdapter(
      child: FeedErrorView(
        error: S.of(context).failed_to_fetch,
        onRefresh: () => _refresh(context),
      ),
    );
  }

  Widget _buildLoadingSliver() {
    return SliverFillViewport(
      delegate: SliverChildBuilderDelegate((BuildContext c, int index) {
        return Center(
          child: const FeedLoader(),
        );
      }, childCount: 1),
    );
  }

  List<Widget> _buildResultsSliver(
      BuildContext context, CallFeedLoaded state, BoxConstraints constraints) {
    final items = state.items;
    Call? schedule =
        context.select<MyAppModel, Call?>((model) => model.selectedCall);
    double width = constraints.biggest.width;
    bool isCompact = width <= 450;
    final isDesktop = isDisplayDesktop(context);
    return items.map((e) {
      return SliverStickyHeader.builder(
        sticky: false,
        builder: (context, state) {
          return Container(
            height: 30,
            color: Theme.of(context).colorScheme.background,
            child: CallFeedListItem(
              e.first,
              parentWidth: constraints.biggest.width,
            ),
          );
        },
        sliver: SliverFixedExtentList(
          itemExtent: isDesktop ? 56.0 : 80.0,
          delegate: SliverChildBuilderDelegate(
              (context, i) => CallFeedListItem(e[i + 1],
                  selectedCall: schedule,
                  parentWidth: constraints.biggest.width,
                  isLast: i == e.length - 2,
                  isCompact: isCompact),
              childCount: e.length - 1),
        ),
      );
    }).toList();
  }

  Widget _buildSectionTitle(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.headline4!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            if (scheduleFilter != null) scheduleFilter!
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreSliver(BuildContext context) {
    return SliverToBoxAdapter(child: BottomCallFeedLoader(bloc));
  }


  Widget _buildAllTab(BuildContext context) {
    // final RecordingService recordService =
    //     Provider.of<RecordingService>(context);
    return LayoutBuilder(builder: (_, constraints) {
      return BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, CallFeedState state) {
          final List<Widget> slivers = [
            _buildAppBar(context),
            //if (isDesktop) _buildAppBar(context),
            // SliverOverlapInjector(
            //   // This is the flip side of the SliverOverlapAbsorber above.
            //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
            //       context),
            // ),
            // _buildSectionTitle(context),
            //if (state is CallFeedLoaded && !state.isEmpty && !isDesktop)
            // _buildSearch(context),
          ];
          if (state is CallFeedUninitialized) {
            slivers.add(_buildLoadingSliver());
          } else if (state is CallFeedError) {
            slivers.add(_buildErrorSliver(state, context));
          } else if (state is CallFeedLoaded) {
            if (state.isEmpty) {
              slivers.add(_buildEmptySliver(context, state));
            } else {
              slivers.addAll(_buildResultsSliver(context, state, constraints));
            }
          } else {
            slivers.add(const SliverToBoxAdapter(
              child: SizedBox.shrink(),
            ));
          }
          if (state is CallFeedLoaded && !state.hasReachedMax) {
            slivers.add(
              SliverSafeArea(
                top: false,
                bottom: true,
                sliver: _buildLoadMoreSliver(context),
              ),
            );
          }
          return CustomScrollView(
              key: PageStorageKey("${bloc.feedType}_schedules"),
              //controller: isDesktop ? null : controller,
              controller: controller,
              slivers: slivers);
        },
      );
    });
  }



  bool get canShowQR =>
      (UniversalPlatform.isWeb && isQRScanningSupported()) ||
      (UniversalPlatform.isAndroid || UniversalPlatform.isIOS);

  Widget _buildAppBar(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    return SliverAppBar(
      leading: null,
      automaticallyImplyLeading: false,
      title: scheduleFilter,
      // bottom: isDesktop ? _AppBarBottom() : null,
      centerTitle: true,
      pinned: isDesktop,
      actions: [
        IconButton(
          icon: Icon(
            Icons.add_circle_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            PagenavigationHelper.newCallLink(context);
          },
        ),
      ],
      // backgroundColor: Theme.of(context).colorScheme.background,
      floating: true,
      snap: true,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAllTab(context);
  }
}
