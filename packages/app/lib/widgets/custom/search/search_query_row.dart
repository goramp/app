// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:goramp/bloc/index.dart';
// import 'package:goramp/widgets/custom/search/search_bar.dart';
// import 'package:goramp/widgets/index.dart';

// class SearchQueryRow extends StatelessWidget {
//   final SearchBarState state;

//   const SearchQueryRow(this.state, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SearchBloc, SearchState>(
//       bloc: state.searchBloc,
//       builder: (_, SearchState searchState) {
//         bool isLoading = searchState.isSearching;
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             HSpace(Insets.m),
//             SizedBox(
//               height: state.widget.closedHeight,
//               width: state.widget.closedHeight,
//               child: IconButton(
//                 icon: Icon(Icons.search),
//                 onPressed: state.handleSearchIconPressed,
//                 visualDensity: VisualDensity.compact,
//                 padding: EdgeInsets.zero,
//                 splashRadius: state.widget.closedHeight! / 2,
//               ),
//             ),
//             HSpace(Insets.m),
//             Expanded(
//               child: StyledSearchTextInput(
//                 contentPadding: EdgeInsets.zero,
//                 hintText: "Search home",
//                 key: state.textKey,
//                 onChanged: state.handleSearchChanged,
//                 // Disabled because this callback has different behavior on web for some reason,
//                 // the hook is now in the states _handleRawKeyPressed method
//                 //onFieldSubmitted: (s) => state.handleSearchSubmitted(),
//                 onEditingCancel: state.cancel,
//                 onFocusChanged: state.handleFocusChanged,
//                 onFocusCreated: state.handleTextFocusCreated,
//               ),
//             ),
//             Container(
//               //constraints: BoxConstraints(maxWidth: 72),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   if (isLoading) ...{
//                     const FeedLoader(
//                       size: 18,
//                       strokeWidth: 2.0,
//                     )
//                   },
//                   if (state.hasQuery) ...{
//                     SizedBox(
//                       height: state.widget.closedHeight,
//                       width: state.widget.closedHeight,
//                       child: IconButton(
//                         icon: Icon(Icons.close),
//                         onPressed: state.clearSearch,
//                         visualDensity: VisualDensity.compact,
//                         padding: EdgeInsets.zero,
//                         splashRadius: state.widget.closedHeight! / 2,
//                       ),
//                     ),
//                   }
//                 ],
//               ),
//             ),
//             HSpace(Insets.m),
//           ],
//         );
//       },
//     );
//   }
// }
