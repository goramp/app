import 'package:flutter/material.dart';
import 'package:goramp/widgets/index.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../bloc/index.dart';

const _kTabBarHeightXs = 300.0;
const _kTabBarHeight = 256.0;

class FeedPreviewArgs<T> {
  final T? item;
  final ValueNotifier<int>? page;
  final BaseFeedBloc<T>? feedBloc;
  final String? itemId;
  FeedPreviewArgs(this.itemId, {this.page, this.feedBloc, this.item});
}

abstract class FeedPreview<T> extends StatefulWidget {
  final ValueChanged<T>? onChanged;
  final List<T> items;
  final int? initialIndex;
  FeedPreview(
      {Key? key,
      required this.items,
      this.initialIndex = 0,
      this.onChanged,})
      : super(key: key);
}

abstract class FeedPreviewState<Y extends FeedPreview, T> extends State<Y>
    with TickerProviderStateMixin {
  late PageController _pageController;
  PageController get pageController => _pageController;
  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: widget.initialIndex ?? 0);
    // _pageController.addListener(_handlePageChange);
  }

  dispose() {
    super.dispose();
    _pageController.dispose();
  }

  // _handlePageChange() {
  //   widget.page.value =
  //       _pageController.position.haveDimensions && _pageController.page != null
  //           ? _pageController.page.round()
  //           : _pageController.initialPage;
  // }

  int get currentPage => _pageController.position.haveDimensions
      ? _pageController.page!.round()
      : 0;

  bool hasNext() {
    return widget.items.isNotEmpty ? currentPage < widget.items.length - 1 : false;
  }

  bool hasPrevious() {
    return widget.items.isNotEmpty ? currentPage > 0 : false;
  }

  void next() {
    if (_pageController.position.haveDimensions) {
      _pageController.nextPage(
          curve: Curves.fastOutSlowIn, duration: Durations.fast);
    }
  }

  void previous() {
    if (_pageController.position.haveDimensions) {
      _pageController.previousPage(
          curve: Curves.fastOutSlowIn, duration: Durations.fast);
    }
  }

  Widget buildItemDetail(T item);

  Widget build(
    BuildContext context,
  ) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemCount: widget.items.length,
      physics: isDisplayDesktop(context) ? ClampingScrollPhysics() : null,
      onPageChanged: widget.onChanged,
      itemBuilder: (BuildContext context, int index) {
        return Provider.value(
          value: this,
          child: buildItemDetail(widget.items[index]),
        );
      },
    );
  }

  double get tabHeight {
    return MediaQueryHelper.isLargeScreen(context)
        ? _kTabBarHeightXs
        : _kTabBarHeight;
  }

  Widget _buildCloseButton(BuildContext context) {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: IconButton(
        color: Colors.white,
        icon: IconS(
          MdiIcons.closeCircle,
          shadows: ICON_SHADOW,
        ),
        iconSize: 32.0,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildClose(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget buildFetchError(BuildContext context);

  Widget buildError(BuildContext context) {
    return SafeArea(
      child: buildFetchError(context),
    );
  }

  Widget buildLoader(BuildContext context) {
    return const FeedLoader();
  }
}
