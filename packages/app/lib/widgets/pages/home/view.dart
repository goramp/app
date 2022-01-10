import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/home/index.dart';
import 'package:provider/provider.dart';
import 'package:goramp/generated/l10n.dart';
import '../../../bloc/index.dart';

class _HeaderWrap extends StatelessWidget {
  final Widget child;
  final bool hasElevation;
  final double height;
  _HeaderWrap(this.child, {this.hasElevation = false, this.height = 56.0});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      child: SafeArea(
        child: SizedBox(
          height: height,
          child: child,
        ),
      ),
      duration: Durations.fast,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: hasElevation
            ? theme.appBarTheme.color
            : theme.colorScheme.background,
        border: Border(
          bottom: hasElevation
              ? BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5, // One physical pixel.
                  style: BorderStyle.solid,
                )
              : BorderSide.none,
        ),
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate({required this.currencies, this.controller, this.isScrolled = false});

  final List<String> currencies;
  final TabController? controller;
  final bool isScrolled;
  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  void _tap(BuildContext context, int index) {
      context.go('/home/${currencies[index]}');
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Widget tab = TabBar(
      controller: controller,
      key: PageStorageKey<Type>(TabBar),
      indicatorColor: Theme.of(context).colorScheme.primary,
      onTap: (index) => _tap(context, index),
      tabs: currencies
          .map(
            (currency) => Tab(
              text: currency.toUpperCase(),
            ),
          )
          .toList(),
    );
    return Material(
      color: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      // elevation: isScrolled || (shrinkOffset > maxExtent - minExtent) ? 4.0 : 0,
      child: tab
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return oldDelegate.controller != controller;
  }
}

class HomeView extends WidgetView<Home, HomeState> {
  HomeView(HomeState state) : super(state);

  Widget _buildBody(int selection, BuildContext context,
      {Widget? toggleFilter}) {
    return CallFeedList(
      state.bloc,
      widget.title,
      controller: state.scrollController,
      emptyText: S.of(context).nothing_here,
      key: PageStorageKey("schedule_feed"),
      selection: selection,
      scheduleFilter: toggleFilter,
    );
  }

  // List<Widget> _buildHeaderSlivers(
  //     BuildContext context, bool innerBoxIsScrolled) {
  //   return <Widget>[
  //       SliverOverlapAbsorber(
  //         handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
  //         sliver: SliverSafeArea(
  //           top: false,
  //           bottom: false,
  //           sliver: SliverToBoxAdapter(
  //             child: scheduleFilter,
  //           ),
  //         ),
  //       ),
  //     SliverOverlapAbsorber(
  //       handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
  //       sliver: SliverSafeArea(
  //         top: false,
  //         bottom: false,
  //         sliver: SliverPersistentHeader(
  //           pinned: true,
  //           delegate: _HeaderDelegate(isScrolled: innerBoxIsScrolled),
  //         ),
  //       ),
  //     ),
  //   ];
  // }

  Widget _buildToggleBar(BuildContext context, int index) {
    return CallToggleBar(
      (int? sel) {
        MyAppModel appModel = context.read();
        if (appModel.currentUser == null) {
          return;
        }
        widget.orderTypeFilter!.value = sel ?? 0;
        var stream = 'buy';
        switch (widget.orderTypeFilter!.value) {
          case 0:
            stream = 'buy';
            break;
          case 1:
            stream = 'sell';
            break;
        }
        PagenavigationHelper.savings(context, stream);
      },
      selection: index,
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Container(
      // color: Theme.of(context).appBarTheme.color,
      child: SafeArea(
        top: false,
        bottom: true,
        child: ValueListenableBuilder(
          builder: (_, int val, __) {
            return _buildBody(
              val,
              context,
              toggleFilter: ValueListenableBuilder(
                valueListenable: widget.orderTypeFilter!,
                builder: (context, int val, __) {
                  return _buildToggleBar(context, val);
                },
              ),
            );
          },
          valueListenable: widget.orderTypeFilter!,
        ),
      ),
    );
  }

  Widget _desktopLayout(BuildContext context) {
    Widget content = ValueListenableBuilder(
      builder: (_, int val, __) {
        return _buildBody(
          val,
          context,
          toggleFilter: ValueListenableBuilder(
            valueListenable: widget.orderTypeFilter!,
            builder: (context, int val, __) {
              return _buildToggleBar(context, val);
            },
          ),
        );
      },
      valueListenable: widget.orderTypeFilter!,
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDisplayDesktop(context);
    return Selector<MyAppModel, bool>(
      selector: (context, appStore) => appStore.onSearchPage,
      builder: (context, onSearchPage, child) {
        return isDesktop ? _desktopLayout(context) : _buildMobileLayout(context);
      },
    );
  }
}
