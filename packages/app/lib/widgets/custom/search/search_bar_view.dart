// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:goramp/widgets/custom/content_underlay.dart';
// import 'package:goramp/widgets/custom/search/search_bar.dart';
// import 'package:goramp/widgets/custom/search/search_query_row.dart';
// import 'package:goramp/widgets/custom/search/search_result.dart';
// import 'package:goramp/widgets/index.dart';
// import 'package:styled_widget/styled_widget.dart';

// class SearchBarView extends WidgetView<SearchBar, SearchBarState> {
//   SearchBarView(SearchBarState state, {Key? key}) : super(state, key: key);

//   bool get isOpen => state.isOpen;

//   KeyEventResult _handleKeyPress(FocusNode node, RawKeyEvent evt) {
//     if (evt is RawKeyDownEvent) {
//       if (evt.logicalKey == LogicalKeyboardKey.escape) {
//         state.cancel();
//         return KeyEventResult.handled;
//       }
//     }
//     return KeyEventResult.ignored;
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget underlay = ContentUnderlay(
//       isActive: isOpen,
//       // color: Colors.white30,
//     );

//     double? barHeight = state.widget.closedHeight;
//     double topPadding = Insets.m;
//     final desktopMaxWidth = 500.0 + 100.0 * (cappedTextScale(context) - 1);
//     return FocusScope(
//       onKey: _handleKeyPress,
//       child: Stack(
//         children: <Widget>[
//           /// Clickable underlay, closes on press
//           underlay.gestures(onTap: state.cancel),

//           /// Wrap content in an animated card, this will handle open and closing animations
//           _AnimatedSearchCard(
//             state,
//             // Content Column
//             width: desktopMaxWidth,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 // Search Box
//                 Container(
//                   height: barHeight,
//                   child: SearchQueryRow(state),
//                 ),
//                 SearchResults(state)
//                     .opacity(isOpen ? 1 : 0, animate: true)
//                     .animate(Durations.fast, Curves.easeOut)
//                     .expanded()
//               ],
//             ),
//           ).padding(vertical: Insets.m),

//           /// Animated Search Underline
//           if (state.isOpen && state.resultsHeight > 0) ...{
//             Divider(
//               height: 1.0,
//               thickness: 0.7,
//             )
//                 .padding(top: topPadding + barHeight!)
//                 .constrained(width: desktopMaxWidth)
//                 .alignment(Alignment.topCenter)
//           },
//         ],
//       ),
//     );
//   }
// }

// /// Handles the transition from open and closed, the content is a Column, contains the SearchBox, and SearchResults
// class _AnimatedSearchCard extends StatelessWidget {
//   final Widget? child;
//   final SearchBarState searchBar;
//   final double width;
//   const _AnimatedSearchCard(this.searchBar,
//       {Key? key, this.child, this.width = 0})
//       : super(key: key);

//   bool get isOpen => searchBar.isOpen;

//   bool get hasQuery => searchBar.hasQuery;

//   @override
//   Widget build(BuildContext context) {
//     double openHeight =
//         min(searchBar.widget.closedHeight! + searchBar.resultsHeight, 600);
//     final radius = const Radius.circular(6.0);
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     Color closedColor = theme.colorScheme.background;
//     Color openColor = isDark
//         ? Color.alphaBlend(Colors.white.withOpacity(0.24), Color(0xff121212))
//         : theme.colorScheme.surface;
//     return Align(
//       alignment: Alignment.topCenter,
//       child: Material(
//         elevation: isOpen ? 2.0 : 0,
//         borderRadius: BorderRadius.all(radius),
//         color: isOpen ? openColor : closedColor,
//         child: Container(
//           width: width,
//           height: isOpen ? openHeight : searchBar.widget.closedHeight,
//           child: child,
//         ),
//       ),
//     );
//   }
// }
