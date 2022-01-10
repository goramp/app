import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/me/me.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:goramp/widgets/pages/home/index.dart';

class MainScaffoldTab extends WidgetView<MainScaffold, MainScaffoldState> {
  MainScaffoldTab(MainScaffoldState state) : super(state);

  @override
  Widget build(BuildContext context) {
    // var currentPage =
    //     context.select<MyAppModel, PageType?>((value) => value.currentMainPage);
    final currentPage = state.currentPage;
    Widget body;
    final defaultPage = KeyedSubtree(
      key: ValueKey(currentPage),
      child: Home(
        S.of(context).home,
        orderTypeFilter: state.orderType,
      ),
    );
    if (currentPage == 'home') {
      body = defaultPage;
    }
    else if (currentPage == 'savings') {
      body = KeyedSubtree(
        key: ValueKey(currentPage),
        child: Me(
          index: state.widget.profileIndex ?? 0,
        ),
      );
    } else if (currentPage == 'wallet') {
      body = KeyedSubtree(
        key: ValueKey(currentPage),
        child: Wallets(
          onClose: null,
          index: state.widget.walletIndex ?? 0,
        ),
      );
    } else {
      body = defaultPage;
    }
    return PageTransitionSwitcher(
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
          fillColor: Theme.of(context).colorScheme.background,
        );
      },
      child: body,
    );
  }
}
