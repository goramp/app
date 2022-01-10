import 'dart:async';

import 'package:flutter/material.dart';

typedef PagedItemBuilder<T> = Widget Function(BuildContext context, int index, T data);
typedef PagedItemLoader<T> = Future<List<T>> Function(List<T> current);

class PagedListView<T> extends StatefulWidget {
  const PagedListView({
    Key? key,
    // ListView parameters
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.cacheExtent,
    // PagedListView specifics
    required this.itemBuilder,
    required this.itemLoader,
    this.loadingBuilder = defaultLoadingBuilder,
    this.separatorBuilder,
    this.initialData,
  }) : super(key: key);

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final double? cacheExtent;

  final PagedItemBuilder<T> itemBuilder;
  final PagedItemLoader<T> itemLoader;
  final IndexedWidgetBuilder loadingBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final List<T>? initialData;

  static Widget defaultLoadingBuilder(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  PagedListViewState<T> createState() => PagedListViewState<T>();
}

class PagedListViewState<T> extends State<PagedListView<T>> {
  bool _loading = false;
  bool _end = false;
  late List<T> _data;

  bool get isLoading => _loading;

  bool get hasFinished => _end;

  @override
  void initState() {
    super.initState();
    _data = widget.initialData ?? <T>[];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // ListView params passed-in
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemExtent: widget.itemExtent,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      cacheExtent: widget.cacheExtent,
      // PagedListView specifics
      itemCount: _data.length * (widget.separatorBuilder != null ? 2 : 1) + 1,
      itemBuilder: _itemBuilder as Widget Function(BuildContext, int),
    );
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    final int itemIndex = (widget.separatorBuilder != null) ? index ~/ 2 : index;
    if (itemIndex < _data.length) {
      return widget.separatorBuilder == null || index.isEven
          ? widget.itemBuilder(context, itemIndex, _data[itemIndex])
          : widget.separatorBuilder!(context, itemIndex);
    } else {
      if (!_end && !_loading) {
        tryLoadingMoreData();
      }
      return _loading ? widget.loadingBuilder(context, itemIndex) : null;
    }
  }

  void tryLoadingMoreData() async {
    if (!_loading) {
      _loading = true;
      await WidgetsBinding.instance!.endOfFrame;
      setState(() => _end = false);
      try {
        List<T> data = await widget.itemLoader(List.unmodifiable(_data));
        if (mounted && data != null) {
          setState(() => _data.addAll(data));
        }
        if (data == null) {
          _end = true;
        }
      } finally {
        setState(() => _loading = false);
      }
    }
  }
}