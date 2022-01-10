import 'package:flutter/material.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:provider/provider.dart';
import '../../../models/index.dart';
import '../me/index.dart';

class TabDescription {
  final String title;
  final Widget label;
  final String key;
  final Widget icon;
  final Widget? activeIcon;
  final bool dummy;
  final Color? backgroudColor;
  const TabDescription(
    this.title,
    this.label,
    this.icon,
    this.key, {
    this.activeIcon,
    this.dummy = false,
    this.backgroudColor,
  });

  static String? tabTitle(BuildContext context, TabDescription tab) {
    switch (tab.key) {
      case 'home':
        return S.of(context).home;
      case 'savings':
        return S.of(context).savings;
      case 'wallet':
        return S.of(context).wallet;
      case 'create':
        return S.of(context).create;
      default:
        return tab.title;
    }
  }
}

const Tabs = [
  TabDescription(
    'Home',
    Text('Home'),
    Icon(Icons.home_outlined),
    'home',
    activeIcon: Icon(Icons.home_filled)
  ),
  TabDescription(
    "Savings",
    Text("savings"),
    Icon(Icons.savings_outlined),
    'savings',
    activeIcon: Icon(
      Icons.savings,
    ),
  ),
  TabDescription(
    "Wallet",
    Text("Wallet"),
    Icon(Icons.account_balance_wallet_outlined),
    'wallet',
    activeIcon: Icon(Icons.account_balance_wallet),
  ),
];

const DesktopTabs = [
  TabDescription(
    'Home',
    Text('Home'),
    Icon(Icons.watch_later_outlined),
    'home',
    activeIcon: Icon(Icons.watch_later),
  ),
  TabDescription(
    "Wallet",
    Text("Wallet"),
    Icon(Icons.account_balance_wallet_outlined),
    'wallet',
    activeIcon: Icon(Icons.account_balance_wallet),
  ),
  TabDescription(
    "Savings",
    Text("savings"),
    Icon(Icons.savings_outlined),
    'savings',
    activeIcon: Icon(
      Icons.savings,
    ),
  )
];

class ViewNavigatorObserver extends NavigatorObserver {
  ViewNavigatorObserver(this.onNavigation);

  final VoidCallback onNavigation;

  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onNavigation();
  }

  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onNavigation();
  }
}

class PopScoped extends StatelessWidget {
  final Widget child;
  const PopScoped(this.child);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: child,
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
    );
  }
}

class MeTab extends StatelessWidget {
  final VoidCallback? onNavigation;
  final TabController meTabController;
  const MeTab(this.meTabController, {this.onNavigation});
  @override
  Widget build(BuildContext context) {
    return MeWithUser(meTabController);
  }
}

class MeWithUser extends StatelessWidget {
  final TabController meTabController;
  const MeWithUser(this.meTabController);
  @override
  Widget build(BuildContext context) {
    MyAppModel model = Provider.of<MyAppModel>(
      context,
    );
    User? user = model.currentUser;
    if (user == null) return SizedBox.shrink();
    return Me();
  }
}
