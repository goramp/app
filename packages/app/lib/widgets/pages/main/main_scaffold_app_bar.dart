import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:goramp/widgets/index.dart';

class MainScaffoldAppBar extends WidgetView<MainScaffold, MainScaffoldState>
    implements PreferredSizeWidget {
  MainScaffoldAppBar(MainScaffoldState state)
      : this.preferredSize = Size.fromHeight(kToolbarHeight),
        super(state);

  final Size preferredSize;

  Widget _buildMaterialAppBar(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return AppBar(
      backgroundColor: colorScheme.background,
      brightness: Theme.of(context).colorScheme.brightness,
      // title: SearchBar(
      //     key: state.searchBarKey,
      //     closedHeight: 40.0,
      //     onSchedulePressed: (c) => state.trySetSelectedCall(c),
      //     searchBloc: BlocProvider.of<SearchBloc>(context)),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMaterialAppBar(context);
  }
}
