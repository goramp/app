// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../bloc/index.dart';
import '../../models/index.dart';

//class FeedPage extends StatefulWidget {
//  const FeedPage({
//    this.delegate,
//    this.animation,
//    this.user,
//  });
//
//  final SearchDelegate<T> delegate;
//  final Animation<double> animation;
//  final Stream<User> user;
//
//  @override
//  State<StatefulWidget> createState() => _FeedPageState();
//}
//
//class _FeedPageState extends State<FeedPage> {
//  ContactSearchBloc _searchBloc;
//
//  @override
//  void initState() {
//    super.initState();
//    _createBloc();
//  }
//
//  void _createBloc() {
//    _searchBloc = ContactSearchBloc(users: widget.user);
//  }
//
//  void _disposeBloc() {
//    _searchBloc.dispose();
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    _disposeBloc();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    assert(debugCheckHasMaterialLocalizations(context));
//    final ThemeData theme = widget.delegate.appBarTheme(context);
//    final String searchFieldLabel =
//        MaterialLocalizations.of(context).searchFieldLabel;
//    String routeName;
//    switch (defaultTargetPlatform) {
//      case TargetPlatform.iOS:
//        routeName = '';
//        break;
//      case TargetPlatform.android:
//      case TargetPlatform.fuchsia:
//        routeName = searchFieldLabel;
//    }
//
//    return Semantics(
//      explicitChildNodes: true,
//      scopesRoute: true,
//      namesRoute: true,
//      label: routeName,
//      child:
//          _buildBody(), // UniversalPlatform.isAndroid ? _buildBody(body) : _buildIos(body),
//    );
//  }
//
//  Widget _buildBody() {
//    return StreamBuilder<ContactSearchState>(
//      stream: _searchBloc.state,
//      initialData: ContactSearchPopulated(),
//      builder:
//          (BuildContext context, AsyncSnapshot<ContactSearchState> snapshot) {
//        final state = snapshot.data;
//        Widget body;
//        if (state is ContactSearchEmpty) {
//          body = KeyedSubtree(
//            key: ValueKey<ContactSearchState>(state),
//            child: widget.delegate.buildEmptyResult(context, state),
//          );
//        } else if (state is ContactSearchError) {
//          body = KeyedSubtree(
//            key: ValueKey<ContactSearchState>(state),
//            child: widget.delegate.buildError(context, state),
//          );
//        } else if (state is ContactSearchPopulated) {
//          body = KeyedSubtree(
//            key: ValueKey<ContactSearchState>(state),
//            child: widget.delegate.buildResults(context, state),
//          );
//        } else {
//          return Container(
//              width: 40.0,
//              height: 40.0,
//              padding: EdgeInsets.all(24.0),
//              child: CircularProgressIndicator());
//        }
//        return AnimatedSwitcher(
//          duration: const Duration(milliseconds: 300),
//          child: body,
//        );
//      },
//    );
//  }
//}
