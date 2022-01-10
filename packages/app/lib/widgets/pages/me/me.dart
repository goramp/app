import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/me/tabs.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:provider/provider.dart';
import '../../../bloc/index.dart';
import '../../../models/index.dart';

class Me extends StatefulWidget {
  final int index;
  const Me({Key? key, this.index = 0}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MeState();
  }
}

class _MeState extends State<Me> with TickerProviderStateMixin {
  final List<String> listItems = [];
  late TabController _tabController;
  late MyAppModel _appModel;
  late MyCallLinksBloc _myLikedCallLinkBloc;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _appModel = context.read();
    _tabController = TabController(
        vsync: this,
        initialIndex: widget.index, //_appModel.mySubPath.index,
        length: MY_TABS.length);
    _myLikedCallLinkBloc = MyCallLinksBloc(
      authBloc: BlocProvider.of<AuthenticationBloc>(context),
      fetchFilter: MyCallLinksFetchFilter.LIKED_EVENTS,
      useUsername: false,
      userId: _appModel.currentUser!.id,
    );
  }

  dispose() {
    _tabController.dispose();
    _myLikedCallLinkBloc.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController.index = widget.index;
  }

  List<Widget> _buildHeaderSlivers(
      BuildContext context, bool innerBoxIsScrolled) {
    final profile =
        context.select<MyAppModel, UserProfile?>((model) => model.profile);
    return <Widget>[
      SliverToBoxAdapter(
        child: Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          //height: _kUserDetailHeight,
          child: MyUserDetail(profile: profile),
        ),
      ),
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverPersistentHeader(
          pinned: true,
          delegate: MyProfileTabBarDelegate(
              controller: _tabController, isScrolled: innerBoxIsScrolled),
        ),
      ),
    ];
  }

  Widget _buildTitle(BuildContext context, UserProfile? profile) {
    return Container(
      //margin: EdgeInsets.only(bottom: 8.0),
      // color: Colors.amber,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          MyAppModel model = context.read();
          if (model.profile == null) {
            return;
          }
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            profile?.username ?? "",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
    );
  }

  Widget _tab(String tab, UserProfile? profile) {
    switch (tab) {
      case 'call_links':
        return const CallLinksTab(
          key: PageStorageKey('my_call_links'),
        );
      case 'likes':
        return Provider.value(
          value: _myLikedCallLinkBloc,
          child: MyFavoriteTab(
            key: PageStorageKey('favorites'),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile =
        context.select<MyAppModel, UserProfile?>((model) => model.profile);
    final isDesktop = isDisplayDesktop(context);
    final tabs = MY_TABS.map((e) => _tab(e, profile)).toList();
    Widget tab = isDesktop
        ? TabBarSwitcher(
            controller: _tabController,
            // These are the contents of the tab views, below the tabs.
            children: tabs)
        : TabBarView(
            controller: _tabController,
            // These are the contents of the tab views, below the tabs.
            children: tabs);
    tab = SafeArea(
        top: false, bottom: false, left: true, right: true, child: tab);
    return Provider.value(
      value: profile,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: _buildTitle(context, profile),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
              ),
              onPressed: () {
                PagenavigationHelper.newCallLink(context);
              },
            ),
            if (!isDesktop)
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  PagenavigationHelper.settings(context);
                },
              )
          ],
        ),
        body: NestedScrollView(
            headerSliverBuilder: _buildHeaderSlivers,
            body: tab,
            controller: _controller),
      ),
    );
  }
}
