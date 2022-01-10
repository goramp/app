// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:goramp/bloc/index.dart';
// import 'package:goramp/widgets/custom/page_feed/call_feed_list_item.dart';
// import 'package:goramp/widgets/custom/scrolling/index.dart';
// import 'package:goramp/widgets/custom/search/search_bar.dart';
// import 'package:goramp/widgets/index.dart';
// import 'package:goramp/widgets/utils/index.dart';

// /// SEARCH RESULTS LIST
// /// Binds to notifications from the tmpSearchEngine using ListenableBuilder
// class SearchResults extends StatelessWidget {
//   final SearchBarState state;

//   const SearchResults(this.state, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
//     return LayoutBuilder(builder: (_, __) {
//       return BlocBuilder<SearchBloc, SearchState>(
//         bloc: state.searchBloc,
//         builder: (_, SearchState searchState) {
//           BuildUtils.getFutureSizeFromGlobalKey(
//               state.resultsKey, (size) => state.resultsHeight = size.height);
//           // int maxResults = 10;
//           final List<CallFeedListItem> items =
//               searchState.items.map((c) => CallFeedListItem(c)).toList();
//           return SingleChildScrollView(
//             child: Column(
//                 key: state.resultsKey,
//                 mainAxisSize: MainAxisSize.min,
//                 children: items),
//           );
//         },
//       );
//     });
//   }
// }
