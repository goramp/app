// import 'package:flutter/rendering.dart';
// import 'package:flutter/material.dart';
// import 'contact_search.dart' as ContactSearch;
// import 'basic_search_delegate.dart';

// const double _kBackAppBarHeight = 46.0; // back layer (options) appbar height

// class SearchAppBar extends StatelessWidget {
//   SearchAppBar(
//       {Key key,
//       this.leading = const SizedBox(width: 56.0),
//       @required this.title,
//       this.trailing,
//       this.onSearch,
//       this.onClose})
//       : assert(onSearch != null),
//         assert(leading != null),
//         assert(title != null),
//         super(key: key);

//   final Widget leading;
//   final Widget title;
//   final Widget trailing;
//   final VoidCallback onSearch;
//   final VoidCallback onClose;
//   final BasicSearchDelegate _delegate = BasicSearchDelegate();

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> children = <Widget>[
//       Container(
//         alignment: Alignment.center,
//         width: 56.0,
//         child: leading,
//       ),
//       title
//     ];

//     if (trailing != null) {
//       children.add(
//         Container(
//           alignment: Alignment.center,
//           child: trailing,
//         ),
//       );
//     }

//     final ThemeData theme = Theme.of(context);

//     return IconTheme.merge(
//       data: theme.primaryIconTheme.copyWith(color: Colors.white54),
//       child: DefaultTextStyle(
//         style: theme.primaryTextTheme.title.copyWith(color: Colors.white54),
//         child: GestureDetector(
//           onTap: () async {
//             if (onSearch != null) {
//               onSearch();
//             }
//             await ContactSearch.showContactSearch<String>(
//               context: context,
//               delegate: _delegate,
//             );
//             if (onClose != null) {
//               onClose();
//             }
//           },
//           child: Container(
//             height: _kBackAppBarHeight,
//             child: Row(
//               children: children,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             ),
//             color: Colors.transparent,
//           ),
//         ),
//       ),
//     );
//   }
// }
