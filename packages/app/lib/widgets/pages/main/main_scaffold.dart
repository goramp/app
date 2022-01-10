import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/utils/error_capture.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/main/main_scaffold_view.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';
import '../../../models/index.dart';
import '../../../bloc/index.dart';

const kSnackInset = EdgeInsets.fromLTRB(0, 0.0, 0, kToolbarHeight);

enum MainDrawer {
  none,
  show_call,
}

class MainDrawerParams extends Equatable {
  final MainDrawer drawer;
  final Object? params;

  const MainDrawerParams({this.drawer = MainDrawer.none, this.params});

  List get props => [drawer, params];
}

class MainScaffold extends StatefulWidget {
  final String page;
  final int? profileIndex;
  final int? walletIndex;
  final int eventIndex;

  MainScaffold(
    this.page, {
    Key? key,
    this.profileIndex = 0,
    this.walletIndex = 0,
    this.eventIndex = 0,
  }) : super(key: key);
  MainScaffoldState createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold>
    with TickerProviderStateMixin {
  StreamSubscription<NotificationValue?>? _notifSub;
  StreamSubscription<Link>? _linkSub;
  final ValueNotifier<int> _orderType = ValueNotifier<int>(0);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //final GlobalKey<SearchBarState> searchBarKey = GlobalKey();
  // final GlobalKey<CallPanelState> sidePanelKey = GlobalKey();

  List<Key>? _destinationKeys;
  AnimationController? _hideController;
  bool _hideNav = false;
  List<Key>? get destinationKeys => _destinationKeys;
  AnimationController? get hideBottomNavigationController => _hideController;
  ValueNotifier<int> get orderType => _orderType;

  late MyAppModel appModel;
  bool skipScaffoldAnims = false;

  ValueNotifier<MainDrawerParams> drawerMode =
      ValueNotifier<MainDrawerParams>(MainDrawerParams());

  void _handleCallFilter() {
    int val = orderType.value;
    CallFeedBloc bloc = context.read();
    MyAppModel model = context.read();
    final user = model.currentUser;
    if (user == null) {
      return;
    }
    if (val == 0) {
      bloc.add(FilterCallFeed(user.id, CallFeedBlocFilterType.buy));
    }
    if (val == 1) {
      bloc.add(FilterCallFeed(user.id, CallFeedBlocFilterType.sell));
    }
  }

  initState() {
    super.initState();
    appModel = context.read();
    _destinationKeys =
        List<Key>.generate(5, (int index) => GlobalKey()).toList();
    _hideController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration)
          ..value = appModel.hideMainSideNav ? 0.0 : 1.0;
    NotificationsBloc notif = context.read();
    _notifSub = notif.notificationStream.listen((NotificationValue? value) =>
        InAppNotificationHelper.presentNotification(context, value));
    _orderType.value = widget.eventIndex;
    _orderType.addListener(_handleCallFilter);
    _hideNav = appModel.hideMainSideNav;
    appModel.addListener(_handleNavState);
    AppConfig config = context.read();
    if (config.isBeta && appModel.currentUser != null) {
      Wiredash.of(context)?.setUserProperties(
        userEmail: appModel.currentUser!.email,
        userId: appModel.currentUser!.id,
      );
    }
  }

  void _handleNavState() {
    if (_hideNav == appModel.hideMainSideNav) {
      return;
    }
    _hideNav = appModel.hideMainSideNav;
    if (_hideNav) {
      _hideController!.reverse();
    } else {
      _hideController!.forward();
    }
  }

  @override
  void didUpdateWidget(MainScaffold oldWidget) {
    if (widget.eventIndex != oldWidget.eventIndex) {
      _orderType.value = widget.eventIndex;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  String get currentPage => PageType.firstWhere((page) {
        return page == widget.page;
      });

  int get currentPageIndex =>
      PageType.indexWhere((page) => page.toLowerCase() == widget.page.toLowerCase());

  /// Attempt to change current page, this might not complete if user is currently editing
  Future<void> trySetCurrentPage(String t) async {
    appModel.selectedCall = null;
    if (t == 'me') {
      final me = appModel.profile?.username ?? 'me';
      context.go('/$me');
    } else {
      context.go('/${t}');
    }
  }

  Future<void> scanQr() async {
    try {
    } catch (e, s) {
      ErrorHandler.report(e, s);
    }
  }

  /// Change selected contact, this might not complete if user is currently editing
  Future<void> trySetSelectedCall(Call? value) async {
    if (value != null) {
      // RoutePageManager pageManager = context.read();
      // pageManager.navigateTo(CallDetailsPath(value.id!, call: value));
    }
  }

  @override
  void dispose() {
    appModel.removeListener(_handleNavState);
    _orderType.removeListener(_handleCallFilter);
    _notifSub?.cancel();
    _linkSub?.cancel();
    _hideController!.dispose();
    super.dispose();
    //unRegisterRouteObserver();
  }

  Widget build(BuildContext context) {
    return Provider.value(
      value: this,
      child: MainScaffoldView(this),
    );
  }
}
