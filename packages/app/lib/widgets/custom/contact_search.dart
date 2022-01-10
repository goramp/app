// // Copyright 2018 The Chromium Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'dart:ui';
// import '../../bloc/index.dart';
// import '../../models/index.dart';

// Future<T> showContactSearch<T>({
//   @required BuildContext context,
//   @required SearchDelegate<T> delegate,
//   String query = '',
// }) {
//   assert(delegate != null);
//   assert(context != null);
//   delegate.query = query ?? delegate.query;
//   return Navigator.of(context).push(_SearchPageRoute<T>(
//     delegate: delegate,
//   ));
// }

// abstract class SearchDelegate<T> {
//   Widget buildSuggestions(BuildContext context, List<ContactList> contacts);
//   Widget buildEmptyResult(BuildContext context, ContactSearchState state);
//   Widget buildResults(BuildContext context, ContactSearchState state);
//   Widget buildLoading(BuildContext context, ContactSearchState state);
//   Widget buildError(BuildContext context, ContactSearchState state);
//   bool isPicker();
//   Widget buildPickedItems(BuildContext context) {
//     return Container();
//   }

//   ThemeData appBarTheme(BuildContext context) {
//     assert(context != null);
//     final ThemeData theme = ThemeData.dark();
//     assert(theme != null);
//     return theme.copyWith(
//       primaryColor: Colors.white,
//       primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
//       primaryTextTheme: theme.textTheme,
//     );
//   }

//   String get query => _queryTextController.text;
//   set query(String value) {
//     assert(query != null);
//     _queryTextController.text = value;
//   }

//   close(BuildContext context, T result) async {
//     _focusNode.unfocus();
//     Navigator.of(context)
//       ..popUntil((Route<dynamic> route) => route == _route)
//       ..pop(result);
//   }

//   Animation<double> get transitionAnimation => _proxyAnimation;

//   final FocusNode _focusNode = FocusNode();

//   FocusNode get focusNode => _focusNode;

//   final TextEditingController _queryTextController = TextEditingController();

//   final ProxyAnimation _proxyAnimation =
//       ProxyAnimation(kAlwaysDismissedAnimation);

//   _SearchPageRoute<T> _route;
// }

// class _SearchPageRoute<T> extends PopupRoute<T> {
//   _SearchPageRoute({
//     @required this.delegate,
//   }) : assert(delegate != null) {
//     assert(
//         delegate._route == null,
//         'The ${delegate.runtimeType} instance is currently used by another active '
//         'search. Please close that search by calling close() on the SearchDelegate '
//         'before openening another search with the same delegate instance.',);
//     delegate._route = this;
//   }

//   final SearchDelegate<T> delegate;

//   @override
//   Color get barrierColor => Colors.black26;

//   @override
//   String get barrierLabel => null;

//   @override
//   bool get barrierDismissible => true;

//   @override
//   Duration get transitionDuration => const Duration(milliseconds: 300);

//   @override
//   bool get maintainState => false;

//   @override
//   Widget buildTransitions(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//     Widget child,
//   ) {
//     return FadeTransition(
//       opacity: animation,
//       child: child,
//     );
//   }

//   @override
//   Animation<double> createAnimation() {
//     final Animation<double> animation = super.createAnimation();
//     delegate._proxyAnimation.parent = animation;
//     return animation;
//   }

//   @override
//   Widget buildPage(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//   ) {
//     final UserBloc userBloc = Provider.of<UserBloc>(context);
//     return _SearchPage<T>(
//         delegate: delegate,
//         animation: animation,
//         user: userBloc.currentUserStream);
//   }

//   @override
//   void didComplete(T result) {
//     super.didComplete(result);
//     assert(delegate._route == this);
//     delegate._route = null;
//   }
// }

// class _SearchPage<T> extends StatefulWidget {
//   const _SearchPage({
//     this.delegate,
//     this.animation,
//     this.user,
//   });

//   final SearchDelegate<T> delegate;
//   final Animation<double> animation;
//   final Stream<User> user;

//   @override
//   State<StatefulWidget> createState() => _SearchPageState<T>();
// }

// class _SearchPageState<T> extends State<_SearchPage<T>> {
//   ContactSearchBloc _searchBloc;
//   bool _showDialPad = false;

//   @override
//   void initState() {
//     super.initState();
//     queryTextController.addListener(_onQueryChanged);
//     widget.animation.addStatusListener(_onAnimationStatusChanged);
//     widget.delegate._focusNode.addListener(_onFocusChanged);
//     _createBloc();
//   }

//   void _createBloc() {
//     _searchBloc = ContactSearchBloc(users: widget.user);
//   }

//   void _disposeBloc() {
//     _searchBloc.dispose();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     queryTextController.removeListener(_onQueryChanged);
//     widget.animation.removeStatusListener(_onAnimationStatusChanged);
//     widget.delegate._focusNode.removeListener(_onFocusChanged);
//     _disposeBloc();
//   }

//   void _onAnimationStatusChanged(AnimationStatus status) {
//     if (status != AnimationStatus.completed) {
//       return;
//     }
//     widget.animation.removeStatusListener(_onAnimationStatusChanged);
//     if (_searchBloc.state.value is ContactSearchNoTerm) {
//       FocusScope.of(context).requestFocus(widget.delegate._focusNode);
//     }
//   }

//   void _onFocusChanged() {
//     if (widget.delegate._focusNode.hasFocus &&
//         !(_searchBloc.state.value is ContactSearchNoTerm)) {
//       //  _searchBloc.onTextChanged.add('');
//     }
//   }

//   void _onQueryChanged() {
//     setState(() {
//       _searchBloc.onTextChanged.add(queryTextController.text);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     assert(debugCheckHasMaterialLocalizations(context));
//     final String searchFieldLabel =
//         MaterialLocalizations.of(context).searchFieldLabel;
//     String routeName;
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.iOS:
//         routeName = '';
//         break;
//       case TargetPlatform.android:
//       case TargetPlatform.macOS:
//       case TargetPlatform.fuchsia:
//         routeName = searchFieldLabel;
//     }

//     return Semantics(
//       explicitChildNodes: true,
//       scopesRoute: true,
//       namesRoute: true,
//       label: routeName,
//       child:
//           _buildBody(), // UniversalPlatform.isAndroid ? _buildBody(body) : _buildIos(body),
//     );
//   }

//   TextEditingController get queryTextController =>
//       widget.delegate._queryTextController;

//   List<Widget> buildActions(BuildContext context) {
//     return <Widget>[
//       queryTextController.text.isEmpty
//           ? Icon(null)
//           : IconButton(
//               tooltip: 'Clear',
//               icon: const Icon(Icons.clear),
//               onPressed: () {
//                 queryTextController.text = '';
//               },
//             )
//     ];
//   }

//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       tooltip: 'Back',
//       icon: AnimatedIcon(
//         icon: AnimatedIcons.menu_arrow,
//         progress: widget.delegate.transitionAnimation,
//       ),
//       onPressed: () async {
//         widget.delegate.close(context, null);
//       },
//     );
//   }

//   Widget _buildBody() {
//     final ThemeData theme = widget.delegate.appBarTheme(context);

//     final String searchFieldLabel = "Search by name or number";
//     return Scaffold(
//       backgroundColor: Colors.black54,
//       appBar: AppBar(
//         backgroundColor: theme.primaryColor,
//         iconTheme: theme.primaryIconTheme,
//         textTheme: theme.primaryTextTheme,
//         brightness: theme.primaryColorBrightness,
//         leading: buildLeading(context),
//         bottom: PreferredSize(
//             child: Divider(
//               height: 1.0,
//               color: Colors.white,
//             ),
//             preferredSize: Size(double.infinity, 1.0)),
//         title: TextField(
//           controller: queryTextController,
//           focusNode: widget.delegate._focusNode,
//           style: theme.textTheme.title.copyWith(color: Colors.white70),
//           textInputAction: TextInputAction.search,
//           keyboardType:
//               _showDialPad ? TextInputType.number : TextInputType.text,
//           onSubmitted: (String _) {
//             _searchBloc.onTextChanged.add(queryTextController.text);
//           },
//           decoration: InputDecoration(
//               border: InputBorder.none,
//               hintText: searchFieldLabel,
//               hintStyle:
//                   theme.textTheme.subhead.copyWith(color: theme.hintColor)),
//           cursorColor: Colors.white70,
//         ),
//         actions: buildActions(context),
//       ),
//       body: StreamBuilder<ContactSearchState>(
//         stream: _searchBloc.state,
//         builder:
//             (BuildContext context, AsyncSnapshot<ContactSearchState> snapshot) {
//           final state = snapshot.data;
//           bool loading = false;
//           Widget body;
//           if (state is ContactSearchEmpty) {
//             body = KeyedSubtree(
//               key: ValueKey<ContactSearchState>(state),
//               child: widget.delegate.buildEmptyResult(context, state),
//             );
//           } else if (state is ContactSearchError) {
//             body = KeyedSubtree(
//               key: ValueKey<ContactSearchState>(state),
//               child: widget.delegate.buildError(context, state),
//             );
//           } else if (state is ContactSearchPopulated) {
//             body = KeyedSubtree(
//               key: ValueKey<ContactSearchState>(state),
//               child: widget.delegate.buildResults(context, state),
//             );
//           } else if (state is ContactSearchNoTerm) {
//             body = KeyedSubtree(
//               key: ValueKey<ContactSearchState>(state),
//               child: StreamBuilder<List<ContactList>>(
//                 stream: _searchBloc.suggestions,
//                 builder: (BuildContext context,
//                     AsyncSnapshot<List<ContactList>> snapshot) {
//                   if (!snapshot.hasData) {
//                     return Container(
//                         constraints: BoxConstraints(maxHeight: 2.0),
//                         child: LinearProgressIndicator());
//                   }
//                   final contacts = snapshot.data;
//                   return widget.delegate.buildSuggestions(context, contacts);
//                 },
//               ),
//             );
//           } else if (state is ContactSearchLoading) {
//             loading = true;
//           } else {
//             return Container();
//           }

//           return GestureDetector(
//             onTap: () {
//               widget.delegate._focusNode.unfocus();
//             },
//             child: Stack(
//               children: <Widget>[
//                 IgnorePointer(
//                   ignoring: !loading,
//                   child: AnimatedOpacity(
//                     duration: Duration(milliseconds: 300),
//                     opacity: loading ? 1.0 : 0.0,
//                     child: Container(
//                         constraints: BoxConstraints(maxHeight: 2.0),
//                         child: LinearProgressIndicator()),
//                   ),
//                 ),
//                 NotificationListener<ScrollNotification>(
//                   onNotification: (ScrollNotification notification) {
//                     if (notification is ScrollStartNotification &&
//                         widget.delegate._focusNode.hasFocus) {
//                       widget.delegate._focusNode.unfocus();
//                     }
//                   },
//                   child: AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 300),
//                     child: body,
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
