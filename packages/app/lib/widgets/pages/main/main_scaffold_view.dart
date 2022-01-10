import 'package:flutter/material.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/main/main_scaffold_tab.dart';
import 'package:sized_context/sized_context.dart';
import 'package:provider/provider.dart';
import 'bottom_bar.dart';

const kSnackInset = EdgeInsets.fromLTRB(0, 0.0, 0, kToolbarHeight);

class _MainDrawerContainer extends StatelessWidget {
  final Widget child;
  const _MainDrawerContainer(this.child);
  @override
  Widget build(BuildContext context) {
    double detailsPanelWidth = 400;
    if (context.widthInches > 8) {
      //Panel size gets a little bigger as the screen size grows
      detailsPanelWidth += (context.widthInches - 8) * 12;
    }
    return Container(
      width: detailsPanelWidth,
      child: Drawer(
        child: child,
      ),
    );
  }
}

class MainScaffoldView extends WidgetView<MainScaffold, MainScaffoldState> {
  MainScaffoldView(MainScaffoldState state) : super(state);

  void _handleSelection(int index) {
    state.trySetCurrentPage(PageType[index]);
  }

  Widget _buildNavigationBar(BuildContext context) { 
    return KNavigationBar(
      _handleSelection,
      state.currentPageIndex,
    );
  }

  Widget _buildTabs(BuildContext context) {
    // return Router(
    //   routerDelegate: state.routerDelegate!,
    //   backButtonDispatcher: state.backButtonDispatcher,
    // );
    return MainScaffoldTab(state);
  }


  Widget _buildDesktopStack(BuildContext context) {
    final contentStack = FocusTraversalGroup(child: _buildTabs(context));
    Call? selectedContact =
        context.select<MyAppModel, Call?>((model) => model.selectedCall);

    final isTablet = isDisplaySmallDesktop(context);
    return Provider.value(
      /// Provide the currently selected contact to all views below this
      value: selectedContact,
      child: FocusTraversalGroup(
        child: Row(
          children: [
            ClipRect(
              child: SizeTransition(
                axis: Axis.horizontal,
                sizeFactor: state.hideBottomNavigationController!,
                axisAlignment: -1.0,
                child: KNavigationBar(
                  _handleSelection,
                 state.currentPageIndex,
                  extended: !isTablet,
              ),
            ),),
            const VerticalDivider(thickness: 0.7, width: 1),
            Expanded(
              child: contentStack,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMobileStack(BuildContext context) {
    return _buildTabs(context);
  }

  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDesktop = isDisplayDesktop(context);
    return Theme(
      data: theme, //.copyWith(appBarTheme: _buildAppBarTheme(themeData)),
      child: Scaffold(
        key: state.scaffoldKey,
        //endDrawer: isDesktop ? _buildDrawer(context) : null,
        onEndDrawerChanged: (open) {
          if (!open) {
            state.trySetSelectedCall(null);
          }
          MyAppModel model = context.read();
          model.hideMainSideNav = open;
        },
        drawerEnableOpenDragGesture: false,
        endDrawerEnableOpenDragGesture: false,
        drawer: null,
        onDrawerChanged: null,
        body: isDesktop
            ? _buildDesktopStack(context)
            : _buildMobileStack(context),
        bottomNavigationBar: isDisplayDesktop(context)
            ? null
            : ClipRect(
                child: SizeTransition(
                  sizeFactor: state.hideBottomNavigationController!,
                  axisAlignment: -1.0,
                  child: _buildNavigationBar(context),
                ),
              ),
      ),
    );
  }
}
