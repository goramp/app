import 'package:flutter/material.dart';
import 'package:animations/animations.dart' as anim;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:goramp/services/call_link_service.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:universal_platform/universal_platform.dart';
import '../../../bloc/index.dart';
import '../../../models/index.dart';

class MyProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  MyProfileTabBarDelegate({this.controller, this.isScrolled = false});

  final TabController? controller;
  final bool isScrolled;
  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  String _textForTab(String tab, BuildContext context) {
    switch (tab) {
      case 'call_links':
        return S.of(context).call_links;
      case 'likes':
        return S.of(context).likes;
      default:
        return '';
    }
  }

  // Widget _iconsForTab(String tab, BuildContext context) {
  //   switch (tab) {
  //     case 'call_links':
  //       return const Icon(
  //         Icons.calendar_today,
  //       );
  //     case 'likes':
  //       return const Icon(
  //         Icons.favorite,
  //       );
  //     default:
  //       return const SizedBox.shrink();
  //   }
  // }

  void _tap(BuildContext context, int index) {
    final appModel = context.read<MyAppModel>();
    final me = appModel.profile?.username ?? 'me';
    if (index == 0) {
      context.go('/$me');
    } else {
      context.go('/$me/${MY_TABS[index]}');
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isDesktop = isDisplayDesktop(context);
    Widget tab = TabBar(
      controller: controller,
      key: PageStorageKey<Type>(TabBar),
      indicatorColor: Theme.of(context).colorScheme.primary,
      onTap: (index) => _tap(context, index),
      tabs: MY_TABS
          .map(
            (e) => Tab(
              text: _textForTab(e, context),
            ),
          )
          .toList(),
    );
    return Material(
      color: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      // elevation: isScrolled || (shrinkOffset > maxExtent - minExtent) ? 4.0 : 0,
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (isDesktop || orientation == Orientation.landscape) {
            tab = CenteredWidget(
              tab,
              maxWidth: 500,
            );
          }
          return tab;
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant MyProfileTabBarDelegate oldDelegate) {
    return oldDelegate.controller != controller;
  }
}

class MyFavoriteTab extends StatefulWidget {
  final Widget? emptyContent;
  const MyFavoriteTab({Key? key, this.emptyContent}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _FavoriteCallLinksTabState();
  }
}

class _FavoriteCallLinksTabState
    extends BaseCallLinksTabState<MyFavoriteTab, CallLink> {
  BaseFeedBloc<CallLink> getBloc() {
    return BlocProvider.of<MyCallLinksBloc>(context);
  }

  @override
  Widget? buildEmpty(FeedLoaded state) {
    if (widget.emptyContent == null) {
      return super.buildEmpty(state);
    }
    return widget.emptyContent;
  }

  @override
  Widget buildItem(BuildContext context, CallLink event, int index) {
    final MyAppModel model = context.read();
    if (model.currentUser == null) return SizedBox.shrink();
    return ProxyChangeCallLinkGridTile(
      event: event,
      user: model.currentUser,
      onChanged: (before, after) => CallLinkService.updateFavoriteCallLink(
          model.currentUser?.id, before, after),
      onTap: () => _onCallLinkTap(event),
    );
  }

  void _onCallLinkTap(CallLink event) {
    UserProfile? profile = context.read();
    PagenavigationHelper.browseUserCallLinks(
        context, event.id!, profile!,
        callLink: event,
        bloc: UniversalPlatform.isWeb ? null : getBloc(),
        tab: 'likes');
  }
}

class CallLinksTab extends StatefulWidget {
  const CallLinksTab({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CallLinksTabState();
  }
}

class _CallLinksTabState extends BaseCallLinksTabState<CallLinksTab, CallLink> {
  @override
  BaseFeedBloc<CallLink> getBloc() {
    return BlocProvider.of<MyCallLinksBloc>(context);
  }

  @override
  Widget buildItem(BuildContext context, CallLink event, int index) {
    final MyAppModel model = context.read();
    // if (model.currentUser == null) return SizedBox.shrink();
    return SimpleCallLinkGridTile(
      event: event,
      user: model.currentUser,
      onTap: () => _onCallLinkTap(event, index),
    );
  }

  void _onCallLinkTap(CallLink event, int index) {
    UserProfile? profile = context.read();
    PagenavigationHelper.browseUserCallLinks(
      context,
      event.id!,
      profile!,
      callLink: event,
      bloc: getBloc(),
    );
  }
}

class PublicCallLinksTab extends StatefulWidget {
  const PublicCallLinksTab({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PublicCallLinksTabState();
  }
}

class _PublicCallLinksTabState
    extends BaseCallLinksTabState<PublicCallLinksTab, CallLink> {
  @override
  BaseFeedBloc<CallLink> getBloc() {
    return BlocProvider.of<PublicCallLinksBloc>(context);
  }

  @override
  Widget buildItem(BuildContext context, CallLink event, int index) {
    final MyAppModel model = context.read();
    // if (model.currentUser == null) return SizedBox.shrink();
    return SimpleCallLinkGridTile(
      event: event,
      user: model.currentUser,
      onTap: () => _onCallLinkTap(event, index),
    );
  }

  void _onCallLinkTap(CallLink event, int index) {
    UserProfile? profile = context.read();
    PagenavigationHelper.browseUserCallLinks(
      context,
      event.id!,
      profile!,
      callLink: event,
      bloc: getBloc(),
    );
  }
}

class TabBarSwitcher extends StatefulWidget {
  /// Creates a page view with one child per tab.
  ///
  /// The length of [children] must be the same as the [controller]'s length.
  const TabBarSwitcher({
    Key? key,
    required this.children,
    this.controller,
  })  :
        super(key: key);

  /// This widget's selection and animation state.
  ///
  /// If [TabController] is not provided, then the value of [DefaultTabController.of]
  /// will be used.
  final TabController? controller;

  /// One widget per tab.
  ///
  /// Its length must match the length of the [TabBar.tabs]
  /// list, as well as the [controller]'s [TabController.length].
  final List<Widget> children;

  @override
  _TabBarSwitcherViewState createState() => _TabBarSwitcherViewState();
}

class _TabBarSwitcherViewState extends State<TabBarSwitcher> {
  TabController? _controller;
  late List<Widget> _childrenWithKey;
  int? _currentIndex;

  // If the TabBarView is rebuilt with a new tab controller, the caller should
  // dispose the old one. In that case the old controller's animation will be
  // null and should not be accessed.
  bool get _controllerIsValid => _controller?.animation != null;

  void _updateTabController() {
    final TabController? newController =
        widget.controller ?? DefaultTabController.of(context);
    assert(() {
      if (newController == null) {
        throw FlutterError('No TabController for ${widget.runtimeType}.\n'
            'When creating a ${widget.runtimeType}, you must either provide an explicit '
            'TabController using the "controller" property, or you must ensure that there '
            'is a DefaultTabController above the ${widget.runtimeType}.\n'
            'In this case, there was neither an explicit controller nor a default controller.');
      }
      return true;
    }());

    if (newController == _controller) return;

    if (_controllerIsValid)
      _controller!.removeListener(_handleTabControllerAnimationTick);
    _controller = newController;
    if (_controller != null)
      _controller!.addListener(_handleTabControllerAnimationTick);
  }

  @override
  void initState() {
    super.initState();
    _updateChildren();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTabController();
    _currentIndex = _controller?.index;
  }

  @override
  void didUpdateWidget(TabBarSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) _updateTabController();
    if (widget.children != oldWidget.children) _updateChildren();
  }

  @override
  void dispose() {
    if (_controllerIsValid)
      _controller!.removeListener(_handleTabControllerAnimationTick);
    _controller = null;
    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  void _updateChildren() {
    _childrenWithKey = KeyedSubtree.ensureUniqueKeysForList(widget.children);
  }

  void _handleTabControllerAnimationTick() {
    if (_controller!.index != _currentIndex) {
      setState(() {
        _currentIndex = _controller!.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      if (_controller!.length != widget.children.length) {
        throw FlutterError(
            "Controller's length property (${_controller!.length}) does not match the "
            "number of tabs (${widget.children.length}) present in TabBar's tabs property.");
      }
      return true;
    }());
    return anim.PageTransitionSwitcher(
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return anim.FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
          fillColor: Theme.of(context).colorScheme.background,
        );
      },
      child: _childrenWithKey[_currentIndex!],
    );
  }
}
