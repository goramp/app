// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:goramp/bloc/index.dart';
// import 'package:goramp/models/index.dart';
// import 'package:goramp/widgets/custom/content_underlay.dart';
// import 'package:goramp/widgets/custom/search/search_bar_view.dart';
// import 'package:goramp/widgets/custom/search/search_result.dart';
// import 'package:goramp/widgets/index.dart';
// import 'package:provider/provider.dart';
// import 'package:styled_widget/styled_widget.dart';

// class SearchBar extends StatefulWidget {
//   final ValueChanged? onSchedulePressed;
//   final VoidCallback? onSearchSubmitted;
//   final double? closedHeight;
//   final bool? narrowMode;
//   final double? topPadding;
//   final SearchBloc? searchBloc;

//   const SearchBar({
//     Key? key,
//     this.closedHeight,
//     this.onSchedulePressed,
//     this.onSearchSubmitted,
//     this.narrowMode,
//     this.topPadding,
//     this.searchBloc,
//   }) : super(key: key);

//   @override
//   SearchBarState createState() => SearchBarState();
// }

// class SearchBarState extends State<SearchBar> {
//   final GlobalKey<StyledSearchTextInputState> textKey = GlobalKey();

//   final GlobalKey<StyledSearchTextInputState> resultsKey = GlobalKey();

//   OverlayEntry? _overlayEntry;
//   FocusNode? textFocusNode;
//   @override
//   void initState() {
//     RawKeyboard.instance.addListener(_handleRawKeyPressed);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     RawKeyboard.instance.removeListener(_handleRawKeyPressed);
//     super.dispose();
//   }

//   bool _open = false;
//   bool get isOpen => _open;

//   double _resultsHeight = 0;

//   double get resultsHeight => _resultsHeight;

//   final LayerLink layerLink = LayerLink();

//   set resultsHeight(double height) {
//     if (_resultsHeight != height) setState(() => _resultsHeight = height);
//   }

//   SearchBloc? get searchBloc => widget.searchBloc;

//   bool get hasQuery => searchBloc!.hasQuery;

//   set isOpen(bool value) {
//     if (_open == value) return;
//     // When we open up, make a copy of the current search settings to work with
//     if (value == true) {
//       // Put the focus in the text field to start
//       textFocusNode?.requestFocus();
//     } else {
//       // Unfocus textNode when closing
//       textFocusNode!.unfocus();
//     }
//     textKey?.currentState?.text = searchBloc!.query ?? "";
//     setState(() {
//       _open = value;
//     });
//     //searchBloc.add(SearchOpen(open: value));
//   }

//   void cancel() => isOpen = false;

//   void handleSearchChanged(String value) =>
//       searchBloc!.add(SearchQuery(query: value, enforceMinQueryLenth: false));

//   // Expand when we get focus
//   void handleFocusChanged(bool value) {
//     if (value || !hasQuery) {
//       isOpen = value;
//     }
//   }

//   void handleSearchSubmitted() {
//     /// Copy the tmp values back into the main search engine, triggering a rebuild in the main list,
//     save();
//     widget.onSearchSubmitted?.call();
//     isOpen = false;
//   }

//   void handleSchedulePressed(Call c) async {
//     MainScaffoldState scaffold = context.read();
//     clearQueryString();
//     handleSearchSubmitted();
//     Future.microtask(() => scaffold.trySetSelectedCall(c));
//   }

//   void handleTagPressed(String tag) {
//     clearQueryString();
//     handleSearchSubmitted();
//   }

//   void _handleRawKeyPressed(RawKeyEvent evt) {
//     if (evt is RawKeyDownEvent) {
//       if (evt.logicalKey == LogicalKeyboardKey.keyK && evt.isControlPressed) {
//         isOpen = true;
//       } else if (textFocusNode!.hasFocus &&
//           evt.logicalKey == LogicalKeyboardKey.enter) {
//         handleSearchSubmitted();
//       } else if (textFocusNode!.hasFocus &&
//           evt.logicalKey == LogicalKeyboardKey.backspace) {
//         if (textKey != null &&
//             textKey.currentState != null &&
//             textKey.currentState!.text.isEmpty) {
//           // final tl = widget.searchBloc.tagList;
//           // final cl = widget.searchBloc.filterContactList;
//           // if (cl.isNotEmpty) {
//           //   widget.searchBloc.removeFilterContact(cl.last);
//           // } else if (tl.isNotEmpty) {
//           //   widget.searchBloc.removeTag(tl.last);
//           // }
//         }
//       }
//     }
//   }

//   void handleTextFocusCreated(FocusNode node) {
//     textFocusNode = node;
//   }

//   void handleSearchIconPressed() => textFocusNode?.requestFocus();

//   void clearQueryString() {
//     handleSearchChanged("");
//     textKey?.currentState?.text = "";
//     textFocusNode!.requestFocus();
//   }

//   void clearSearch() {
//     handleSearchChanged("");
//     textKey?.currentState?.text = "";
//     if (!isOpen)
//       save();
//     else
//       textFocusNode!.requestFocus();
//   }

//   void save() {
//     // widget.searchBloc.copyFrom(widget.searchBloc);
//   }

//   @override
//   Widget build(BuildContext context) => SearchBarView(this);
// }
