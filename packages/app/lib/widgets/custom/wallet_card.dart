import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/generated/l10n.dart';

const _kCurrency = 18.0;
const kCarouselItemMargin = 16.0;
const _horizontalPadding = 32.0;
const _horizontalDesktopPadding = 32.0;
const _desktopCardsPerPage = 2;

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    required this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int? itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int>? onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 6.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 16.0;

  Widget _buildDot(BuildContext context, int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    final theme = Theme.of(context);
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: theme.colorScheme.secondary,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected!(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(
          itemCount!, (index) => _buildDot(context, index)),
    );
  }
}

class _DesktopPageButton extends StatelessWidget {
  const _DesktopPageButton({
    Key? key,
    this.isEnd = false,
    this.onTap,
  }) : super(key: key);

  final bool isEnd;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final buttonSize = 32.0;
    final padding = _horizontalDesktopPadding - buttonSize / 2;
    return ExcludeSemantics(
      child: Align(
        alignment: isEnd
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: Container(
          width: buttonSize,
          height: buttonSize,
          margin: EdgeInsetsDirectional.only(
            start: isEnd ? 0 : padding,
            end: isEnd ? padding : 0,
          ),
          child: Tooltip(
            message: isEnd
                ? MaterialLocalizations.of(context).nextPageTooltip
                : MaterialLocalizations.of(context).previousPageTooltip,
            child: Material(
              color: Colors.black.withOpacity(0.5),
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: Icon(
                  isEnd
                      ? CupertinoIcons.chevron_right
                      : CupertinoIcons.chevron_left,
                  size: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WalletDesktopCarousel extends StatefulWidget {
  const WalletDesktopCarousel({Key? key, this.children}) : super(key: key);

  final List<Widget>? children;

  @override
  WalletDesktopCarouselState createState() => WalletDesktopCarouselState();
}

class WalletDesktopCarouselState extends State<WalletDesktopCarousel> {
  static const cardPadding = 8.0;
  ScrollController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Widget _builder(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: cardPadding,
      ),
      child: widget.children![index],
    );
  }

  @override
  Widget build(BuildContext context) {
    // var showPreviousButton = false;
    // var showNextButton = true;
    // // Only check this after the _controller has been attached to the ListView.
    // if (_controller!.hasClients) {
    //   showPreviousButton = _controller!.offset > 0;
    //   showNextButton =
    //       _controller!.offset < _controller!.position.maxScrollExtent;
    // }
    return LayoutBuilder(builder: (context, constriaint) {
      final totalWidth = constriaint.biggest.width -
          (_horizontalDesktopPadding - cardPadding) * 2;
      final itemWidth = totalWidth / _desktopCardsPerPage;
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalDesktopPadding - cardPadding,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const _SnappingScrollPhysics(),
              controller: _controller,
              itemExtent: itemWidth,
              itemCount: widget.children!.length,
              itemBuilder: (context, index) => _builder(index),
              shrinkWrap: widget.children!.length == 1,
            ),
          ),
          // if (showPreviousButton)
          //   _DesktopPageButton(
          //     onTap: () {
          //       _controller!.animateTo(
          //         _controller!.offset - itemWidth,
          //         duration: const Duration(milliseconds: 200),
          //         curve: Curves.easeInOut,
          //       );
          //     },
          //   ),
          // if (showNextButton)
          //   _DesktopPageButton(
          //     isEnd: true,
          //     onTap: () {
          //       _controller!.animateTo(
          //         _controller!.offset + itemWidth,
          //         duration: const Duration(milliseconds: 200),
          //         curve: Curves.easeInOut,
          //       );
          //     },
          //   ),
        ],
      );
    });
  }
}

/// Scrolling physics that snaps to the new item in the [WalletDesktopCarousel].
class _SnappingScrollPhysics extends ScrollPhysics {
  const _SnappingScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  _SnappingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SnappingScrollPhysics(parent: buildParent(ancestor));
  }

  double _getTargetPixels(
    ScrollMetrics position,
    Tolerance tolerance,
    double velocity,
  ) {
    final itemWidth = position.viewportDimension / _desktopCardsPerPage;
    var item = position.pixels / itemWidth;
    if (velocity < -tolerance.velocity) {
      item -= 0.5;
    } else if (velocity > tolerance.velocity) {
      item += 0.5;
    }
    return min(
      item.roundToDouble() * itemWidth,
      position.maxScrollExtent,
    );
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final tolerance = this.tolerance;
    final target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => true;
}

class WalletCarousel extends StatefulWidget {
  const WalletCarousel({
    Key? key,
    this.children,
  }) : super(key: key);

  final List<Widget>? children;

  @override
  WalletCarouselState createState() => WalletCarouselState();
}

class WalletCarouselState extends State<WalletCarousel>
    with SingleTickerProviderStateMixin {
  PageController? _controller;
  int _currentPage = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      // The viewPortFraction is calculated as the width of the device minus the
      // padding.
      final width = MediaQuery.of(context).size.width;
      final padding = (_horizontalPadding * 2) - (kCarouselItemMargin * 2);
      _controller = PageController(
        initialPage: _currentPage,
        viewportFraction: (width - padding) / width,
      );
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Widget builder(int index) {
    final carouselCard = AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        double value;
        if (_controller!.position.haveDimensions) {
          value = _controller!.page! - index;
        } else {
          // If haveDimensions is false, use _currentPage to calculate value.
          value = (_currentPage - index).toDouble();
        }
        // We want the peeking cards to be 160 in height and 0.38 helps
        // achieve that.
        value = (1 - (value.abs() * .38)).clamp(0, 1).toDouble();
        value = Curves.easeOut.transform(value);

        return Center(
          child: Transform(
            transform: Matrix4.diagonal3Values(1.0, value, 1.0),
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: widget.children![index],
    );

    return carouselCard;
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      // Makes integration tests possible.
      key: const ValueKey('studyDemoList'),
      onPageChanged: (value) {
        setState(() {
          _currentPage = value;
        });
      },
      controller: _controller,
      itemCount: widget.children!.length,
      itemBuilder: (context, index) => builder(index),
      allowImplicitScrolling: true,
    );
  }
}
