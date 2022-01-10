import 'dart:async';
import 'package:flutter/material.dart';
import 'banner.dart';
import 'banner_route.dart';

class NotificationBannerController<T> {
  final BannerSettings settings;
  final NotificationBanner banner;

  NotificationBannerController({
    Key? key,
    String? title,
    String? message,
    Text? titleText,
    Text? messageText,
    Widget? icon,
    Widget? mainButton,
    Color backgroundColor = const Color(0xFF303030),
    double borderRadius = 4.0,
    BoxShadow? boxShadow,
    bool showProgessText = true,
    TextStyle? progressTextStyle,
    required BannerSettings settings,
    BannerStyle? bannerStyle,
    ValueChanged<NotificationBanner>? onTap,
    bool shouldIconPulse = true,
  })  : banner = NotificationBanner(
          key: key,
          title: title,
          message: message,
          titleText: titleText,
          messageText: messageText,
          icon: icon,
          mainButton: mainButton,
          backgroundColor: backgroundColor,
          boxShadow: boxShadow,
          borderRadius: borderRadius,
          bannerPosition: settings.bannerPosition,
          bannerStyle: bannerStyle,
          onTap: onTap,
          shouldIconPulse: shouldIconPulse,
        ),
        this.settings = settings != null ? settings : defaultBannerSettings;

  BannerRoute<T?>? _bannerRoute;

  /// Show the flushbar. Kicks in [BannerStatus.IS_APPEARING] state followed by [BannerStatus.SHOWING]
  Future<T?> show(BuildContext context) async {
    _bannerRoute = showBanner<T>(
      context: context,
      builder: Builder(
        builder: (BuildContext context) => GestureDetector(
          child: banner,
          onTap: banner.onTap != null
              ? () {
                  banner.onTap!(banner);
                }
              : null,
        ),
      ),
      settings: settings,
    ) as BannerRoute<T?>?;

    return await Navigator.of(context, rootNavigator: false).push(_bannerRoute as Route<T>);
  }

  /// Dismisses the flushbar causing is to return a future containing [result].
  /// When this future finishes, it is guaranteed that Flushbar was dismissed.
  Future<T?> dismiss([T? result]) async {
    // If route was never initialized, do nothing
    if (_bannerRoute == null) {
      return null;
    }

    if (_bannerRoute!.isCurrent) {
      _bannerRoute!.navigator!.pop(result);
      return _bannerRoute!.completed;
    } else if (_bannerRoute!.isActive) {
      // removeRoute is called every time you dismiss a Flushbar that is not the top route.
      // It will not animate back and listeners will not detect BannerStatus.IS_HIDING or BannerStatus.DISMISSED
      // To avoid this, always make sure that Flushbar is the top route when it is being dismissed
      _bannerRoute!.navigator!.removeRoute(_bannerRoute!);
    }

    return null;
  }

  /// Checks if the flushbar is visible
  bool isShowing() {
    return _bannerRoute?.currentStatus == BannerStatus.SHOWING;
  }

  /// Checks if the flushbar is dismissed
  bool isDismissed() {
    return _bannerRoute?.currentStatus == BannerStatus.DISMISSED;
  }
}

class NotificationBanner<T extends Object> extends StatefulWidget {
  final String? title;
  final Text? titleText;
  final Text? messageText;
  final String? message;
  final Widget? icon;
  final Widget? mainButton;
  final Color backgroundColor;
  final double borderRadius;
  final BoxShadow? boxShadow;
  final BannerStyle? bannerStyle;
  final BannerPosition bannerPosition;
  final ValueChanged<NotificationBanner>? onTap;
  final bool shouldIconPulse;

  NotificationBanner({
    Key? key,
    this.title,
    this.titleText,
    this.message,
    this.messageText,
    this.backgroundColor = const Color(0xFF303030),
    this.borderRadius = 4.0,
    this.boxShadow,
    this.bannerPosition = BannerPosition.TOP,
    this.icon,
    this.mainButton,
    this.bannerStyle,
    this.onTap,
    this.shouldIconPulse = true,
  }) : assert(shouldIconPulse != null);

  @override
  _NotificationBannerState createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner>
    with TickerProviderStateMixin {
  AnimationController? _fadeController;
  late Animation<double> _fadeAnimation;
  late bool _isTitlePresent;
  final Widget _emptyWidget = SizedBox(width: 0.0, height: 0.0);
  final double _initialOpacity = 1.0;
  final double _finalOpacity = 0.4;
  BoxShadow? _boxShadow;
  final Duration _pulseAnimationDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();

    _isTitlePresent = (widget.title != null || widget.titleText != null);

    if (widget.boxShadow != null) {
      _boxShadow = widget.boxShadow;
    }
    if (widget.icon != null && widget.shouldIconPulse) {
      _configurePulseAnimation();
    }
  }

  @override
  void dispose() {
    _fadeController?.dispose();
    super.dispose();
  }

  void _configurePulseAnimation() {
    _fadeController =
        AnimationController(vsync: this, duration: _pulseAnimationDuration);
    _fadeAnimation = Tween(begin: _initialOpacity, end: _finalOpacity).animate(
      CurvedAnimation(
        parent: _fadeController!,
        curve: Curves.linear,
      ),
    );

    _fadeController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _fadeController!.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        _fadeController!.forward();
      }
    });

    _fadeController!.forward();
  }

  List<BoxShadow?>? _getBoxShadowList() {
    if (_boxShadow != null) {
      return [_boxShadow];
    } else {
      return null;
    }
  }

  Widget _getBar() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        boxShadow: _getBoxShadowList() as List<BoxShadow>?,
        borderRadius: widget.bannerStyle == BannerStyle.FLOATING
            ? BorderRadius.circular(widget.borderRadius)
            : BorderRadius.only(
                bottomLeft: Radius.circular(widget.borderRadius),
                bottomRight: Radius.circular(widget.borderRadius)),
      ),
      child: Material(
        color: Colors.transparent,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: _getAppropriateRowLayout() as List<Widget>),
      ),
    );
  }

  Widget? _getIcon() {
    if (widget.icon != null && widget.icon is Icon) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: widget.icon,
      );
    } else if (widget.icon != null) {
      return widget.icon;
    } else {
      return _emptyWidget;
    }
  }

  Text? _getTitleText() {
    return widget.titleText != null
        ? widget.titleText
        : Text(
            widget.title ?? "",
            maxLines: 2,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          );
  }

  Text _getDefaultNotificationText() {
    return Text(
      widget.message ?? "",
      style: TextStyle(fontSize: 14.0, color: Colors.white),
    );
  }

  List<Widget?> _getAppropriateRowLayout() {
    return <Widget?>[
      Expanded(
        flex: 1,
        child: Container(
          padding: const EdgeInsets.only(
              top: 12.0, left: 12.0, right: 12.0, bottom: 12.0),
          child: Row(
            children: <Widget>[
              if (widget.icon != null)
                ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 40.0, height: 40.0),
                    child: _getIcon()),
              if (widget.icon != null)
                SizedBox(
                  width: 12.0,
                ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (_isTitlePresent) _getTitleText()!,
                    if (widget.message != null || widget.messageText != null)
                      widget.messageText ?? _getDefaultNotificationText()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      if (widget.mainButton != null) widget.mainButton,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      heightFactor: 1.0,
      child: Material(
        color: widget.bannerStyle == BannerStyle.FLOATING
            ? Colors.transparent
            : widget.backgroundColor,
        child: SafeArea(
          minimum: widget.bannerPosition == BannerPosition.BOTTOM
              ? EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom)
              : EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
          bottom: widget.bannerPosition == BannerPosition.BOTTOM,
          top: widget.bannerPosition == BannerPosition.TOP,
          left: false,
          right: false,
          child: _getBar(),
        ),
      ),
    );
  }
}
