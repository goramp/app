import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'banner.dart';

class BannerRoute<T> extends OverlayRoute<T> {
  BannerRoute({
    required this.theme,
    required this.bannerSettings,
    required this.builder,
    RouteSettings? settings,

  }) : super(settings: settings) {
    _configureAlignment(this.bannerSettings.bannerPosition);
    _onStatusChanged = bannerSettings.onStatusChanged;
  }

  _configureAlignment(BannerPosition bannerPosition) {
    switch (bannerSettings.bannerPosition) {
      case BannerPosition.TOP:
        {
          _initialAlignment = Alignment(-1.0, -2.0);
          _endAlignment = Alignment(-1.0, -1.0);
          break;
        }
      case BannerPosition.BOTTOM:
        {
          _initialAlignment = Alignment(-1.0, 2.0);
          _endAlignment = Alignment(-1.0, 1.0);
          break;
        }
    }
  }

  BannerSettings bannerSettings;
  Builder builder;

  final ThemeData theme;

  Future<T> get completed => _transitionCompleter.future;
  final Completer<T> _transitionCompleter = Completer<T>();

  late BannerStatusCallback _onStatusChanged;
  Alignment? _initialAlignment;
  Alignment? _endAlignment;
  bool _wasDismissedBySwipe = false;

  Timer? _timer;

  bool get opaque => false;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    List<OverlayEntry> overlays = [];

    if (bannerSettings.overlayBlur > 0.0) {
      overlays.add(
        OverlayEntry(
            builder: (BuildContext context) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: bannerSettings.overlayBlur,
                    sigmaY: bannerSettings.overlayBlur),
                child: Container(
                  constraints: BoxConstraints.expand(),
                  color: bannerSettings.overlayColor,
                ),
              );
            },
            maintainState: false,
            opaque: opaque),
      );
    }

    overlays.add(
      OverlayEntry(
          builder: (BuildContext context) {
            final Widget annotatedChild = Semantics(
              child: AlignTransition(
                alignment: _animation!,
                child: bannerSettings.isDismissible
                    ? _getDismissibleUploadBanner(builder)
                    : Padding(
                        padding: bannerSettings.aroundPadding, child: builder),
              ),
              focused: true,
              scopesRoute: true,
              explicitChildNodes: true,
            );
            return theme != null
                ? Theme(data: theme, child: annotatedChild)
                : annotatedChild;
          },
          maintainState: false,
          opaque: opaque),
    );

    return overlays;
  }

  /// This string is a workaround until Dismissible supports a returning item
  String dismissibleKeyGen = "";

  Widget _getDismissibleUploadBanner(Widget child) {
    return Dismissible(
      direction: _getDismissDirection(),
      resizeDuration: null,
      key: Key(dismissibleKeyGen),
      onDismissed: (_) {
        dismissibleKeyGen += "1";
        _cancelTimer();
        _wasDismissedBySwipe = true;

        if (isCurrent) {
          navigator!.pop();
        } else {
          navigator!.removeRoute(this);
        }
      },
      child: Padding(
        padding: bannerSettings.aroundPadding,
        child: child,
      ),
    );
  }

  DismissDirection _getDismissDirection() {
    if (bannerSettings.dismissDirection == BannerDismissDirection.HORIZONTAL) {
      return DismissDirection.horizontal;
    } else {
      if (bannerSettings.bannerPosition == BannerPosition.TOP) {
        return DismissDirection.up;
      } else {
        return DismissDirection.down;
      }
    }
  }

  @override
  bool get finishedWhenPopped =>
      _controller!.status == AnimationStatus.dismissed;

  /// The animation that drives the route's transition and the previous route's
  /// forward transition.
  Animation<Alignment>? get animation => _animation;
  Animation<Alignment>? _animation;

  /// The animation controller that the route uses to drive the transitions.
  ///
  /// The animation itself is exposed by the [animation] property.
  @protected
  AnimationController? get controller => _controller;
  AnimationController? _controller;

  /// Called to create the animation controller that will drive the transitions to
  /// this route from the previous one, and back to the previous route from this
  /// one.
  AnimationController createAnimationController() {
    assert(!_transitionCompleter.isCompleted,
        'Cannot reuse a $runtimeType after disposing it.');
    assert(bannerSettings.animationDuration != null &&
        bannerSettings.animationDuration >= Duration.zero);
    return AnimationController(
      duration: bannerSettings.animationDuration,
      debugLabel: debugLabel,
      vsync: navigator!,
    );
  }

  /// Called to create the animation that exposes the current progress of
  /// the transition controlled by the animation controller created by
  /// [createAnimationController()].
  Animation<Alignment> createAnimation() {
    assert(!_transitionCompleter.isCompleted,
        'Cannot reuse a $runtimeType after disposing it.');
    assert(_controller != null);
    return AlignmentTween(begin: _initialAlignment, end: _endAlignment).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: bannerSettings.forwardAnimationCurve,
        reverseCurve: bannerSettings.reverseAnimationCurve,
      ),
    );
  }

  T? _result;
  BannerStatus? currentStatus;

  //copy of `routes.dart`
  void _handleStatusChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.completed:
        currentStatus = BannerStatus.SHOWING;
        _onStatusChanged(currentStatus);
        if (overlayEntries.isNotEmpty) overlayEntries.first.opaque = opaque;

        break;
      case AnimationStatus.forward:
        currentStatus = BannerStatus.IS_APPEARING;
        _onStatusChanged(currentStatus);
        break;
      case AnimationStatus.reverse:
        currentStatus = BannerStatus.IS_HIDING;
        _onStatusChanged(currentStatus);
        if (overlayEntries.isNotEmpty) overlayEntries.first.opaque = false;
        break;
      case AnimationStatus.dismissed:
        assert(!overlayEntries.first.opaque);
        // We might still be the current route if a subclass is controlling the
        // the transition and hits the dismissed status. For example, the iOS
        // back gesture drives this animation to the dismissed status before
        // popping the navigator.
        currentStatus = BannerStatus.DISMISSED;
        _onStatusChanged(currentStatus);

        if (!isCurrent) {
          navigator!.finalizeRoute(this);
          assert(overlayEntries.isEmpty);
        }
        break;
    }
    changedInternalState();
  }

  @override
  void install() {
    assert(!_transitionCompleter.isCompleted,
        'Cannot install a $runtimeType after disposing it.');
    _controller = createAnimationController();
    assert(_controller != null,
        '$runtimeType.createAnimationController() returned null.');
    _animation = createAnimation();
    assert(_animation != null, '$runtimeType.createAnimation() returned null.');
    super.install();
  }

  @override
  TickerFuture didPush() {
    assert(_controller != null,
        '$runtimeType.didPush called before calling install() or after calling dispose().');
    assert(!_transitionCompleter.isCompleted,
        'Cannot reuse a $runtimeType after disposing it.');
    _animation!.addStatusListener(_handleStatusChanged);
    _configureTimer();
    return _controller!.forward();
  }

  @override
  void didReplace(Route<dynamic>? oldRoute) {
    assert(_controller != null,
        '$runtimeType.didReplace called before calling install() or after calling dispose().');
    assert(!_transitionCompleter.isCompleted,
        'Cannot reuse a $runtimeType after disposing it.');
    if (oldRoute is BannerRoute) _controller!.value = oldRoute._controller!.value;
    _animation!.addStatusListener(_handleStatusChanged);
    super.didReplace(oldRoute);
  }

  @override
  bool didPop(T? result) {
    assert(_controller != null,
        '$runtimeType.didPop called before calling install() or after calling dispose().');
    assert(!_transitionCompleter.isCompleted,
        'Cannot reuse a $runtimeType after disposing it.');

    _result = result;
    _cancelTimer();

    if (_wasDismissedBySwipe) {
      Timer(Duration(milliseconds: 200), () {
        _controller!.reset();
      });

      _wasDismissedBySwipe = false;
    } else {
      _controller!.reverse();
    }

    return super.didPop(result);
  }

  void _configureTimer() {
    if (bannerSettings.duration != null) {
      if (_timer != null && _timer!.isActive) {
        _timer!.cancel();
      }
      _timer = Timer(bannerSettings.duration!, () {
        if (this.isCurrent) {
          navigator!.pop();
        } else if (this.isActive) {
          navigator!.removeRoute(this);
        }
      });
    } else {
      if (_timer != null) {
        _timer!.cancel();
      }
    }
  }

  void _cancelTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  /// Whether this route can perform a transition to the given route.
  ///
  /// Subclasses can override this method to restrict the set of routes they
  /// need to coordinate transitions with.
  bool canTransitionTo(BannerRoute<dynamic> nextRoute) => true;

  /// Whether this route can perform a transition from the given route.
  ///
  /// Subclasses can override this method to restrict the set of routes they
  /// need to coordinate transitions with.
  bool canTransitionFrom(BannerRoute<dynamic> previousRoute) => true;

  @override
  void dispose() {
    assert(!_transitionCompleter.isCompleted,
        'Cannot dispose a $runtimeType twice.');
    _controller?.dispose();
    _transitionCompleter.complete(_result);
    super.dispose();
  }

  /// A short description of this route useful for debugging.
  String get debugLabel => '$runtimeType';

  @override
  String toString() => '$runtimeType(animation: $_controller)';
}

BannerRoute showBanner<T>(
    {required BuildContext context, required Builder builder, required BannerSettings settings}) {
  assert(builder != null);
  assert(settings != null);

  return BannerRoute<T>(
    builder: builder,
    theme: Theme.of(context),
    settings: RouteSettings(name: BANNER_ROUTE_NAME),
    bannerSettings: settings,
  );
}
