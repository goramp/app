import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:goramp/widgets/index.dart';
import '../custom_app_bar.dart';

/// Delegate for [showSearch] to define the content of the search page.
///
/// The search page always shows an [AppBar] at the top where users can
/// enter their search queries. The buttons shown before and after the search
/// query text field can be customized via [FeedSearchDelegate.leading] and
/// [FeedSearchDelegate.actions].
///
/// The body below the [AppBar] can either show suggested queries (returned by
/// [FeedSearchDelegate.buildSuggestions]) or - once the user submits a search  - the
/// results of the search as returned by [FeedSearchDelegate.buildResults].
///
/// [FeedSearchDelegate.query] always contains the current query entered by the user
/// and should be used to build the suggestions and results.
///
/// The results can be brought on screen by calling [FeedSearchDelegate.showResults]
/// and you can go back to showing the suggestions by calling
/// [FeedSearchDelegate.showSuggestions].
///
/// Once the user has selected a search result, [FeedSearchDelegate.close] should be
/// called to remove the search page from the top of the navigation stack and
/// to notify the caller of [showSearch] about the selected search result.
///
/// A given [FeedSearchDelegate] can only be associated with one active [showSearch]
/// call. Call [FeedSearchDelegate.close] before re-using the same delegate instance
/// for another [showSearch] call.
abstract class FeedSearchDelegate<T> {
  /// Constructor to be called by subclasses which may specify [searchFieldLabel], [keyboardType] and/or
  /// [textInputAction].
  ///
  /// {@tool snippet}
  /// ```dart
  /// class CustomSearchHintDelegate extends FeedSearchDelegate {
  ///   CustomSearchHintDelegate({
  ///     String hintText,
  ///   }) : super(
  ///     searchFieldLabel: hintText,
  ///     keyboardType: TextInputType.text,
  ///     textInputAction: TextInputAction.search,
  ///   );
  ///
  ///   @override
  ///   Widget buildLeading(BuildContext context) => Text("leading");
  ///
  ///   @override
  ///   Widget buildSuggestions(BuildContext context) => Text("suggestions");
  ///
  ///   @override
  ///   Widget buildResults(BuildContext context) => Text('results');
  ///
  ///   @override
  ///   List<Widget> buildActions(BuildContext context) => [];
  /// }
  /// ```
  /// {@end-tool}
  FeedSearchDelegate({
    this.searchFieldLabel,
    this.searchFieldStyle,
    this.keyboardType,
    this.textInputAction = TextInputAction.search,
  });

  /// Suggestions shown in the body of the search page while the user types a
  /// query into the search field.
  ///
  /// The delegate method is called whenever the content of [query] changes.
  /// The suggestions should be based on the current [query] string. If the query
  /// string is empty, it is good practice to show suggested queries based on
  /// sell queries or the current context.
  ///
  /// Usually, this method will return a [ListView] with one [ListTile] per
  /// suggestion. When [ListTile.onTap] is called, [query] should be updated
  /// with the corresponding suggestion and the results page should be shown
  /// by calling [showResults].
  Widget buildSuggestions(BuildContext context);

  /// The results shown after the user submits a search from the search page.
  ///
  /// The current value of [query] can be used to determine what the user
  /// searched for.
  ///
  /// This method might be applied more than once to the same query.
  /// If your [buildResults] method is computationally expensive, you may want
  /// to cache the search results for one or more queries.
  ///
  /// Typically, this method returns a [ListView] with the search results.
  /// When the user taps on a particular search result, [close] should be called
  /// with the selected result as argument. This will close the search page and
  /// communicate the result back to the initial caller of [showSearch].
  Widget buildResults(BuildContext context);

  Widget buildLeading(BuildContext context);

  /// Widgets to display after the search query in the [AppBar].
  ///
  /// If the [query] is not empty, this should typically contain a button to
  /// clear the query and show the suggestions again (via [showSuggestions]) if
  /// the results are currently shown.
  ///
  /// Returns null if no widget should be shown
  ///
  /// See also:
  ///
  ///  * [AppBar.actions], the intended use for the return value of this method.
  List<Widget> buildActions(BuildContext context);

  /// The theme used to style the [AppBar].
  ///
  /// By default, a white theme is used.
  ///
  /// See also:
  ///
  ///  * [AppBar.backgroundColor], which is set to [ThemeData.primaryColor].
  ///  * [AppBar.iconTheme], which is set to [ThemeData.primaryIconTheme].
  ///  * [AppBar.textTheme], which is set to [ThemeData.primaryTextTheme].
  ///  * [AppBar.brightness], which is set to [ThemeData.primaryColorBrightness].
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }

  /// The current query string shown in the [AppBar].
  ///
  /// The user manipulates this string via the keyboard.
  ///
  /// If the user taps on a suggestion provided by [buildSuggestions] this
  /// string should be updated to that suggestion via the setter.
  String get query => _queryTextController.text;
  set query(String value) {
    assert(query != null);
    _queryTextController.text = value;
  }

  /// Transition from the suggestions returned by [buildSuggestions] to the
  /// [query] results returned by [buildResults].
  ///
  /// If the user taps on a suggestion provided by [buildSuggestions] the
  /// screen should typically transition to the page showing the search
  /// results for the suggested query. This transition can be triggered
  /// by calling this method.
  ///
  /// See also:
  ///
  ///  * [showSuggestions] to show the search suggestions again.
  void showResults(BuildContext context) {
    focusNode?.unfocus();
    currentBody = SearchBody.results;
  }

  /// Transition from showing the results returned by [buildResults] to showing
  /// the suggestions returned by [buildSuggestions].
  ///
  /// Calling this method will also put the input focus back into the search
  /// field of the [AppBar].
  ///
  /// If the results are currently shown this method can be used to go back
  /// to showing the search suggestions.
  ///
  /// See also:
  ///
  ///  * [showResults] to show the search results.
  void showSuggestions(BuildContext context) {
    assert(focusNode != null,
        'focusNode must be set by route before showSuggestions is called.');
    focusNode!.requestFocus();
    currentBody = SearchBody.suggestions;
  }

  /// Closes the search page and returns to the underlying route.
  ///
  /// The value provided for `result` is used as the return value of the call
  /// to [showSearch] that launched the search initially.
  void close(BuildContext context, T result) {
    currentBody = SearchBody.suggestions;
    focusNode?.unfocus();
  }

  /// The hint text that is shown in the search field when it is empty.
  ///
  /// If this value is set to null, the value of MaterialLocalizations.of(context).searchFieldLabel will be used instead.
  final String? searchFieldLabel;

  /// The style of the [searchFieldLabel].
  ///
  /// If this value is set to null, the value of the ambient [Theme]'s [ThemeData.inputDecorationTheme.hintStyle] will be used instead.
  final TextStyle? searchFieldStyle;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to the default value specified in [TextField].
  final TextInputType? keyboardType;

  /// The text input action configuring the soft keyboard to a particular action
  /// button.
  ///
  /// Defaults to [TextInputAction.search].
  final TextInputAction textInputAction;

  Animation<double> get transitionAnimation => _proxyAnimation;

  // The focus node to use for manipulating focus on the search page. This is
  // managed, owned, and set by the _SearchPageRoute using this delegate.
  FocusNode? focusNode;

  final TextEditingController _queryTextController = TextEditingController();

  TextEditingController get queryTextController => _queryTextController;

  final ProxyAnimation _proxyAnimation =
      ProxyAnimation(kAlwaysDismissedAnimation);

  final ValueNotifier<SearchBody> currentBodyNotifier =
      ValueNotifier<SearchBody>(SearchBody.suggestions);

  SearchBody get currentBody => currentBodyNotifier.value;
  set currentBody(SearchBody value) {
    currentBodyNotifier.value = value;
  }
}

/// Describes the body that is currently shown under the [AppBar] in the
/// search page.
enum SearchBody {
  /// Suggested queries are shown in the body.
  ///
  /// The suggested queries are generated by [FeedSearchDelegate.buildSuggestions].
  suggestions,

  /// Search results are currently shown in the body.
  ///
  /// The search results are generated by [FeedSearchDelegate.buildResults].
  results,
}

class FeedSearchPage<T> extends StatefulWidget {
  const FeedSearchPage({
    this.delegate,
  });

  final FeedSearchDelegate<T>? delegate;
  @override
  State<StatefulWidget> createState() => _SearchPageState<T>();
}

class _SearchPageState<T> extends State<FeedSearchPage<T>> {
  // This node is owned, but not hosted by, the search page. Hosting is done by
  // the text field.
  FocusNode focusNode = FocusNode();
  ValueNotifier<bool> _hasElevation = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    widget.delegate!._queryTextController.addListener(_onQueryChanged);
    widget.delegate!.currentBodyNotifier.addListener(_onSearchBodyChanged);
    focusNode.addListener(_onFocusChanged);
    widget.delegate!.focusNode = focusNode;
    _requestInitialFocus();
  }

  @override
  void dispose() {
    super.dispose();
    widget.delegate!._queryTextController.removeListener(_onQueryChanged);
    widget.delegate!.currentBodyNotifier.removeListener(_onSearchBodyChanged);
    widget.delegate!.focusNode = null;
    focusNode.dispose();
  }

  void _requestInitialFocus() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (!focusNode.hasFocus &&
          widget.delegate!.currentBody == SearchBody.suggestions) {
        FocusScope.of(context).requestFocus(focusNode);
      }
    });
  }

  @override
  void didUpdateWidget(FeedSearchPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.delegate != oldWidget.delegate) {
      oldWidget.delegate!._queryTextController.removeListener(_onQueryChanged);
      widget.delegate!._queryTextController.addListener(_onQueryChanged);
      oldWidget.delegate!.currentBodyNotifier
          .removeListener(_onSearchBodyChanged);
      widget.delegate!.currentBodyNotifier.addListener(_onSearchBodyChanged);
      oldWidget.delegate!.focusNode = null;
      widget.delegate!.focusNode = focusNode;
    }
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus &&
        widget.delegate!.currentBody != SearchBody.suggestions) {
      widget.delegate!.showSuggestions(context);
    }
  }

  void _onQueryChanged() {
    setState(() {
      // rebuild ourselves because query changed.
    });
  }

  void _onSearchBodyChanged() {
    setState(() {
      // rebuild ourselves because search body changed.
    });
  }

  bool _onScroll(ScrollNotification notification) {
    if ((notification.metrics.pixels > 0)) {
      if (!_hasElevation.value) {
        _hasElevation.value = true;
      }
    } else if ((notification.metrics.pixels <= 0)) {
      if (_hasElevation.value) {
        _hasElevation.value = false;
      }
    }
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        if (userScroll.metrics.axis != Axis.vertical) {
          return false;
        }
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            focusNode.unfocus();
            break;
          case ScrollDirection.reverse:
            focusNode.unfocus();
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  double get maxWidth {
    final desktopMaxWidth = 500.0 + 100.0 * (cappedTextScale(context) - 1);
    return desktopMaxWidth;
  }

  Widget _buildTextWidget() {
    final ThemeData theme = widget.delegate!.appBarTheme(context);

    final radius = const BorderRadius.all(Radius.circular(6.0));
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;

    //showSearch(context: context, delegate: delegate)
    return Material(
      elevation: 2.0,
      color: isDark ? theme.dividerColor : Colors.grey[300],
      borderRadius: radius,
      child: Container(
        height: 40.0,
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: EdgeInsets.only(left: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: EditableText(
                controller: widget.delegate!._queryTextController,
                focusNode: focusNode,
                textInputAction: widget.delegate!.textInputAction,
                keyboardType: widget.delegate!.keyboardType,
                cursorColor: theme.cursorColor,
                backgroundCursorColor: theme.cursorColor,
                style: theme.textTheme.headline6!,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [...widget.delegate!.buildActions(context)],
            ),
          ],
        ),
      ),
    );
    // return TextField(
    //   controller: widget.delegate._queryTextController,
    //   focusNode: focusNode,
    //   style: theme.textTheme.headline6,
    //   textInputAction: widget.delegate.textInputAction,
    //   keyboardType: widget.delegate.keyboardType,
    //   onSubmitted: (String _) {
    //     widget.delegate.showResults(context);
    //   },
    //   decoration: InputDecoration(hintText: searchFieldLabel),
    // );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = widget.delegate!.appBarTheme(context);
    final String searchFieldLabel = widget.delegate!.searchFieldLabel ??
        MaterialLocalizations.of(context).searchFieldLabel;

    Widget? body;
    switch (widget.delegate!.currentBody) {
      case SearchBody.suggestions:
        body = KeyedSubtree(
          key: const ValueKey<SearchBody>(SearchBody.suggestions),
          child: widget.delegate!.buildSuggestions(context),
        );
        break;
      case SearchBody.results:
        body = KeyedSubtree(
          key: const ValueKey<SearchBody>(SearchBody.results),
          child: widget.delegate!.buildResults(context),
        );
        break;
    }
    String? routeName;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        routeName = '';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        routeName = searchFieldLabel;
    }
// Scaffold(
//           appBar: AppBar(
//             leading: widget.delegate.buildLeading(context),
//             title: TextField(
//               controller: widget.delegate._queryTextController,
//               focusNode: focusNode,
//               style: theme.textTheme.headline6,
//               textInputAction: widget.delegate.textInputAction,
//               keyboardType: widget.delegate.keyboardType,
//               onSubmitted: (String _) {
//                 widget.delegate.showResults(context);
//               },
//               decoration: InputDecoration(hintText: searchFieldLabel),
//             ),
//             actions: widget.delegate.buildActions(context),
//             bottom: widget.delegate.buildBottom(context),
//           ),
//           body: AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             child: body,
//           ),
//         )
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: Semantics(
        explicitChildNodes: true,
        scopesRoute: true,
        namesRoute: true,
        label: routeName,
        child: Scaffold(
          appBar: ElevatedAppBar(
            _hasElevation,
            leading: widget.delegate!.buildLeading(context),
            middle: TextField(
              controller: widget.delegate!._queryTextController,
              focusNode: focusNode,
              style: theme.textTheme.headline6,
              textInputAction: widget.delegate!.textInputAction,
              keyboardType: widget.delegate!.keyboardType,
              onSubmitted: (String _) {
                widget.delegate!.showResults(context);
              },
              decoration: InputDecoration(
                hintText: searchFieldLabel,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            actions: widget.delegate!.buildActions(context),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                child: body,
                constraints: BoxConstraints(maxWidth: maxWidth),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
