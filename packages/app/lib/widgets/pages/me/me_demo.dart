import 'package:flutter/material.dart';
import 'package:goramp/generated/l10n.dart';

class _TabContent extends StatefulWidget {
  const _TabContent({
    Key? key,
    required this.index,
  })  : assert(index != null),
        super(key: key);

  final int index;

  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<_TabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomScrollView(
        key: PageStorageKey<String>('tab-${widget.index}'),
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverFillViewport(
            delegate: SliverChildBuilderDelegate((BuildContext c, int index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 60,
                      ),
                      Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          //  color: Colors.black12,
                        ),
                        child: Icon(
                          Icons.calendar_view_day,
                          size: 96.0,
                          color: isDark ? Colors.white38 : Colors.grey[300],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        S.of(context).you_have_no_event,
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: 1),
          )
        ]);
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate({this.controller, this.isScrolled = false});

  final TabController? controller;
  final bool isScrolled;
  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Theme.of(context).appBarTheme.color,
      elevation: 0,
      // elevation: isScrolled || (shrinkOffset > maxExtent - minExtent) ? 4.0 : 0,
      child: TabBar(
        controller: controller,
        indicatorColor: Theme.of(context).colorScheme.primary,
        tabs: <Widget>[
          Tab(
            icon: Icon(
              Icons.calendar_today,
            ),
          ),
          Tab(
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return oldDelegate.controller != controller;
  }
}

class Me extends StatefulWidget {
  const Me({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MeState();
  }
}

class _MeState extends State<Me> with TickerProviderStateMixin {
  final List<String> listItems = [];

  final ScrollController _scrollController = ScrollController();

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  List<Widget> _buildHeaderSlivers(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.all(16.0).copyWith(bottom: 0),
          color: Theme.of(context).appBarTheme.color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100.0,
                height: 100.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(
                        Icons.person_outline,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 64.0,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 24.0,
                        width: 24.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Icon(
                          Icons.add_circle,
                          size: 24.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                'John Doe',
                style: Theme.of(context).textTheme.headline5,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // _buildUsername(context),
              const SizedBox(
                height: 8.0,
              ),
              OutlineButton(
                textColor: Theme.of(context).colorScheme.primary,
                highlightedBorderColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  S.of(context).edit_profile,
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
      SliverOverlapAbsorber(
        // This widget takes the overlapping behavior of the SliverAppBar,
        // and redirects it to the SliverOverlapInjector below. If it is
        // missing, then it is possible for the nested "inner" scroll view
        // below to end up under the SliverAppBar even when the inner
        // scroll view thinks it has not been scrolled.
        // This is not necessary if the "headerSliverBuilder" only builds
        // widgets that do not overlap the next sliver.
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverPersistentHeader(
          pinned: true,
          delegate: _TabBarDelegate(
              controller: _tabController, isScrolled: innerBoxIsScrolled),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {},
            ),
            centerTitle: true,
            title: Text(
              S.of(context).me,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            // backgroundColor: Theme.of(context).canvasColor,
            brightness: Theme.of(context).brightness,
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {},
              )
            ],
          ),
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: _buildHeaderSlivers,
              controller: _scrollController,
              body: TabBarView(controller: _tabController, children: [
                _TabContent(
                  key: PageStorageKey('tab0'),
                  index: 0,
                ),
                _TabContent(
                  key: PageStorageKey('tab1'),
                  index: 1,
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
