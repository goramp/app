import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

const double _kBottomSheetMinHeight = 56.0;
const double _kMinFlingVelocity = 700.0;
const double _kCompleteFlingVelocity = 5000.0;

/// Controls a scrollable widget that is not fully visible on screen yet. While
/// the [top] value is between [minTop] and [maxTop], scroll events will drive
/// [top]. Once it has reached [minTop] or [maxTop], scroll events will drive
/// [offset]. The [top] value is guaranteed not to be clamped between
/// [minTop] and [maxTop].
///
/// This controller would typically be created and listened to by a parent
/// widget such as a [Positioned] or an [Align], and then either passed in
/// directly or used as a [PrimaryScrollController] by a [Scrollable] descendant
/// of that parent.
///
/// See also:
///
///  * [BottomSheetScrollPosition], which manages the positioning logic for
///    this controller.
///  * [PrimaryScrollController], which can be used to establish a
///    [SlideUpPanelScrollController] as the primary controller for
///    descendants.
class SlideUpPanelScrollController extends ScrollController {
  /// Creates a new [BottomSheetScrollController].
  ///
  /// The [top] and [minTop] parameters must not be null. If [maxTop]
  /// is provided as null, it will be defaulted to the
  /// [MediaQueryData.size.height].
  SlideUpPanelScrollController({
    double initialScrollOffset = 0.0,
    double maxTop = 0.0,
    double initialTop = 0.0,
    double? midTop,
    double minTop = 0.0,
    String? debugLabel,
    required TickerProvider vsync,
  })  : assert(minTop != null),
        assert(maxTop != null),
        _midTop = midTop,
        _minTop = minTop,
        _maxTop = maxTop,
        super(
          debugLabel: debugLabel,
          initialScrollOffset: initialScrollOffset,
        ) {
    // If the BottomSheet's child doesn't have a Scrollable widget in it that
    // inherits our PrimaryScrollController, it will never become visible.
    assert(() {
      SchedulerBinding.instance!.addPostFrameCallback((Duration duration) {
        assert(
          _position != null,
          'BottomSheets must be created with a scrollable widget that has primary set to true.\n\n'
          'If you have content that you do not wish to have scrolled beyond its viewable '
          'area, you should consider using a SingleChildScrollView and setting freeze to true. '
          'Otherwise, consider using a ListView or GridView.',
        );
      });
      return true;
    }());
    final top = initialTop != null ? math.max(initialTop, _minTop) : _minTop;
    _topAnimationController = AnimationController(
      value: top / maxTop,
      upperBound: 1.0,
      lowerBound: minTop / maxTop,
      vsync: vsync,
      duration: const Duration(milliseconds: 200),
      debugLabel: 'BottomSheetScrollPositoinTopAnimationController',
    )..addListener(notifyTopListeners);
  }

  void update(
      {double? midTop,
      double maxTop = 0.0,
      double minTop = 0.0,
      double initialTop = 0.0}) {
    assert(maxTop != null);
    assert(minTop != null);
    if (_midTop == midTop && _minTop == minTop && _maxTop == maxTop) {
      return;
    }
    _midTop = midTop;
    _minTop = minTop;
    _maxTop = maxTop;
    _position?.update(minTop: _minTop, maxTop: _maxTop, midTop: _midTop);
  }

  late AnimationController _topAnimationController;

  /// Calculates a top value based on a percentage of screen height defined by the
  /// [MediaQuery] associated with the provided [context].
  static double topFromInitialHeightPercentage(
      double initialHeightPercentage, double screenHeight, double minTop) {
    assert(initialHeightPercentage != null);
    assert(initialHeightPercentage >= 0.0 && initialHeightPercentage <= 1.0);
    final double initialTop = screenHeight * (1.0 - initialHeightPercentage);

    return math.max(initialTop, minTop);
  }

  BottomSheetScrollPosition? _position;

  /// The position at which the top of the controlled widget should be displayed.
  ///
  /// When this value reaches [minTop], the controller will allow the content of
  /// the child to scroll.
  double get top => _topAnimationController.value * _maxTop;
  double get value => _topAnimationController.value;

  double? _midTop;

  /// The minimum allowable value for [top].
  double _minTop;

  double get minTop => _minTop;

  /// The maximum allowable value for [top].
  double _maxTop;
  double get maxTop => _maxTop;

  /// The [AnimationStatus] of the [AnimationController] for the [top].
  AnimationStatus get animationStatus => _topAnimationController.status;

  /// Animate the [top] value to [maxTop].
  Future<Null>? dismiss() {
    return _position?.dismiss();
  }

  Future<Null>? halfOpen() {
    return _position?.halfOpen();
  }

  /// Animate the [top] value to [maxTop].
  Future<Null>? show() {
    return _position?.show();
  }

  void addDeltaToTop(double delta) {
    _position?._addDeltaToTop(delta);
  }

  void onExtDragStart(DragStartDetails details) {
    // _position?._handleDragStart(details);
  }

  void onExtDragEnd(DragEndDetails details) {
    _position?._handleDragEnd(details);
  }

  void onExtDragUpdate(DragUpdateDetails details) {
    _position?._handleDragUpdate(details);
  }

  @override
  BottomSheetScrollPosition createScrollPosition(ScrollPhysics physics,
      ScrollContext context, ScrollPosition? oldPosition) {
    _position = BottomSheetScrollPosition(
        physics: physics,
        context: context,
        minTop: _minTop,
        maxTop: _maxTop,
        midTop: _midTop,
        oldPosition: oldPosition,
        animateIn: (oldPosition != null || _position != null) ? false : true,
        topAnimationController: _topAnimationController);
    return _position!;
  }

  // NotificationCallback handling for top.

  List<VoidCallback>? _topListeners = <VoidCallback>[];

  /// Register a closure to be called when [top] changes.
  ///
  /// Listeners looking for changes to the [offset] should use [addListener].
  /// This method must not be called after [dispose] has been called.
  void addTopListener(VoidCallback callback) {
    _topListeners!.add(callback);
  }

  /// Remove a previously registered closure from the list of closures that are
  /// notified when [top] changes.
  ///
  /// If the given listener is not registered, the call is ignored.
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// If a listener had been added twice, and is removed once during an
  /// iteration (i.e. in response to a notification), it will still be called
  /// again. If, on the other hand, it is removed as many times as it was
  /// registered, then it will no longer be called. This odd behavior is the
  /// result of the [ChangeNotifier] not being able to determine which listener
  /// is being removed, since they are identical, and therefore conservatively
  /// still calling all the listeners when it knows that any are still
  /// registered.
  ///
  /// This surprising behavior can be unexpectedly observed when registering a
  /// listener on two separate objects which are both forwarding all
  /// registrations to a common upstream object.
  void removeTopListener(VoidCallback callback) {
    // if we're disposed, this might already be null.
    _topListeners?.remove(callback);
  }

  /// Call all the registered listeners to [top] changes.
  ///
  /// Call this method whenever [top] changes, to notify any clients the
  /// object may have. Listeners that are added during this iteration will not
  /// be visited. Listeners that are removed during this iteration will not be
  /// visited after they are removed.
  ///
  /// Exceptions thrown by listeners will be caught and reported using
  /// [FlutterError.reportError].
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// Surprising behavior can result when reentrantly removing a listener (i.e.
  /// in response to a notification) that has been registered multiple times.
  /// See the discussion at [removeTopListener].
  void notifyTopListeners() {
    if (_topListeners != null) {
      final List<VoidCallback> localListeners =
          List<VoidCallback>.from(_topListeners!);
      for (VoidCallback listener in localListeners) {
        try {
          if (_topListeners!.contains(listener)) {
            listener();
          }
        } catch (exception, stack) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: exception,
              stack: stack,
              library: 'widgets library',
              context: ErrorDescription(
                  'while dispatching notifications for $runtimeType'),
              informationCollector: () sync* {
                yield ErrorDescription(
                    'The $runtimeType sending notification was:');
              },
            ),
          );
        }
      }
    }
  }

  @override
  bool operator ==(other) =>
      other is SlideUpPanelScrollController && other.hashCode == hashCode;

  @override
  int get hashCode => _midTop.hashCode ^ _maxTop.hashCode ^ _minTop.hashCode;

  bool _disposed = false;
  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _topListeners = null;
      _topAnimationController.dispose();
      super.dispose();
    }
  }

  @override
  void debugFillDescription(List<String> description) {
    super.debugFillDescription(description);
    description.add('minTop: $_minTop');
    description.add('midTop: $_midTop');
    description.add('top: $top');
    description.add('maxTop: $_maxTop');
  }
}

/// A scroll position that manages scroll activities for
/// [BottomSheetScrollController], which delegates its [top]
/// member to this class.
///
/// This class is a concrete subclass of [ScrollPosition] logic that handles a
/// single [ScrollContext], such as a [Scrollable]. An instance of this class
/// manages [ScrollActivity] instances, which changes the
/// [BottomSheetScrollController.top] or visible content offset in the
/// [Scrollable]'s [Viewport].
///
/// See also:
///
///  * [BottomSheetScrollController], which uses this as its [ScrollPosition].
class BottomSheetScrollPosition extends ScrollPositionWithSingleContext {
  /// Creates a new [BottomSheetScrollPosition].
  ///
  /// The [top], [notifier], and [minTop] parameters must not be null.  If [maxTop]
  /// is null, it will be defaulted to [double.maxFinite].
  BottomSheetScrollPosition({
    double minTop = 0.0,
    double? midTop,
    required double maxTop,
    ScrollPosition? oldPosition,
    required ScrollPhysics physics,
    required ScrollContext context,
    required this.topAnimationController,
    this.animateIn = false,
  })  : assert(topAnimationController != null),
        assert(minTop != null),
        assert(maxTop != null),
        assert(minTop > 0 || maxTop > 0),
        assert(context != null),
        assert(animateIn != null),
        _minTop = minTop,
        _maxTop = maxTop,
        _midTop = midTop,
        super(
          physics: physics,
          context: context,
          initialPixels: 0.0,
          oldPosition: oldPosition,
        ) {
    if (animateIn) topAnimationController.animateTo(top / maxTop);
  }

  void update({double minTop = 0.0, double? midTop, required double maxTop}) {
    assert(minTop != null);
    assert(maxTop != null);
    assert(minTop > 0 || maxTop > 0);
    this._midTop = midTop;
    this._minTop = minTop;
    this._maxTop = maxTop;
  }

  /// Whether the [top] will be animated initially.
  final bool animateIn;

  /// The current vertical offset.
  double get top => topAnimationController.value * _maxTop;

  /// The minimum allowable vertical offset.
  double _minTop;

  /// The maximum allowable vertical offset.
  double _maxTop;

  /// The mid allowable vertical offset.
  double? _midTop;

  VoidCallback? _dragCancelCallback;
  VoidCallback? _holdCancelCallback;

  // Tracks whether a drag down can affect the [top].
  bool _canScrollDown = false;

  // Tracks whether a fling down can affect the [top].
  bool _canFlingDown = false;

  AnimationController? _ballisticController;
  AnimationController topAnimationController;

  _handleDragUpdate(DragUpdateDetails details) {
    this._addDeltaToTop(details.delta.dy);
  }

  _handleDragEnd(DragEndDetails details) {
    if (topAnimationController.isAnimating ||
        topAnimationController.status == AnimationStatus.completed) return;
    // final double flingVelocity = details.velocity.pixelsPerSecond.dy / _maxTop;
    // final minPoint = _minTop / _maxTop;
    // final mid = (1 - minPoint) / 2 + minPoint;
    // if (flingVelocity < 0.0) {
    //   _topAnimationController.fling(velocity: math.min(-2.0, flingVelocity));
    // } else if (flingVelocity > 0.0) {
    //   _topAnimationController.fling(velocity: math.max(2.0, flingVelocity));
    // } else {
    //   //lets snap here
    //   _topAnimationController.fling(
    //       velocity: _topAnimationController.value > mid ? 2.0 : -2.0);
    // }
    handleVelocity(-details.velocity.pixelsPerSecond.dy);
  }

  // Ensure that top stays between _minTop and _maxTop, and update listeners
  void _addDeltaToTop(double delta) {
    topAnimationController.value += delta / _maxTop;
  }

  /// Animate the [top] value to [maxTop].
  Future<Null>? dismiss() {
    topAnimationController.forward();
    return null;
  }

  /// Animate the [top] value to [maxTop].
  Future<Null>? halfOpen() {
    topAnimationController.animateTo(_midTop! / _maxTop, curve: Curves.easeOut);
    ;
    return null;
  }

  /// Animate the [top] value to [minTop].
  Future<Null>? show() {
    topAnimationController.reverse();
    return null;
  }

  Future<Null>? toggle() {
    if (topAnimationController.status == AnimationStatus.completed) {
      topAnimationController.reverse();
    } else if (topAnimationController.status == AnimationStatus.dismissed) {
      topAnimationController.forward();
    }
    return null;
  }

  @override
  void absorb(ScrollPosition other) {
    // Need to make sure these get reset -
    // notice this can be an issue when toggling between iOS and Android physics.
    _canFlingDown = false;
    _canScrollDown = false;
    super.absorb(other);
  }

  @override
  void applyUserOffset(double delta) {
    if (top <= _minTop) {
      // <= because of iOS bounce overscroll
      if (pixels <= 0.0 && _canScrollDown) {
        _addDeltaToTop(delta);
        _canScrollDown = false;
      } else {
        if (pixels <= 0.0) {
          _canScrollDown = true;
        }
        super.applyUserOffset(delta);
      }
    } else {
      _addDeltaToTop(delta);
    }
  }

  @override
  double get minScrollExtent {
    // This prevents the physics simulation from thinking it shouldn't be
    // doing anything when a user flings down from top <= minTop.
    return _canFlingDown ? super.minScrollExtent + .01 : super.minScrollExtent;
  }

  @override
  double get maxScrollExtent {
    // SingleChildScrollView will mess us up by reporting that it has no more
    // scroll extent, but we still may want to move it up or down.
    return super.maxScrollExtent != null
        ? super.maxScrollExtent + .01
        : MediaQuery.of(context.storageContext).size.height;
  }

  @override
  void goBallistic(double velocity) async {
    if (topAnimationController.isAnimating ||
        topAnimationController.status == AnimationStatus.completed) {
      super.goBallistic(velocity);
      return;
    }
    if (top <= _minTop || top >= _maxTop) {
      super.goBallistic(velocity);
      return;
    }

    // Scrollable expects that we will dispose of its current _dragCancelCallback
    _dragCancelCallback?.call();
    _dragCancelCallback = null;
    _holdCancelCallback?.call();
    _holdCancelCallback = null;

    await handleVelocity(velocity);

    // if (flingVelocity < 0.0) {
    //   _topAnimationController.fling(velocity: math.max(2.0, -flingVelocity));
    // } else if (velocity > 0.0) {
    //   _topAnimationController.fling(velocity: math.min(-2.0, -flingVelocity));
    // } else {
    //   final minPoint = _minTop / _maxTop;
    //   final mid = (1 - minPoint) / 2 + minPoint;
    //   _topAnimationController.fling(
    //       velocity: _topAnimationController.value > mid ? 2.0 : -2.0);
    // }
    super.goBallistic(0);
  }

  Future<void> handleVelocity(double velocity) async {
    final double flingVelocity = velocity / _maxTop;
    final double completeFlingVelocity = _kCompleteFlingVelocity / _maxTop;
    final double minFlingVelocity = _kMinFlingVelocity / _maxTop;
    if (flingVelocity.abs() > completeFlingVelocity) {
      topAnimationController.fling(velocity: -flingVelocity);
    } else {
      if (_midTop != null) {
        final mid = _midTop! / _maxTop;
        if (flingVelocity.abs() > minFlingVelocity) {
          topAnimationController.fling(velocity: -flingVelocity);
          if (topAnimationController.value > mid) {
            await _flingWithBallisticController(topAnimationController.value,
                mid, topAnimationController.upperBound, -flingVelocity);
          } else {
            await _flingWithBallisticController(topAnimationController.value,
                topAnimationController.lowerBound, mid, -flingVelocity);
          }
        } else {
          if (topAnimationController.value >
              (topAnimationController.upperBound + mid) / 2) {
            // _topAnimationController.animateTo(
            //     _topAnimationController.upperBound,
            //     curve: Curves.easeOut);
            await _flingWithBallisticController(
                topAnimationController.value,
                mid,
                topAnimationController.upperBound,
                math.max(2, flingVelocity));
          } else if (topAnimationController.value >
              (topAnimationController.lowerBound + mid) / 2) {
            //_topAnimationController.animateTo(mid, curve: Curves.easeOut);
            if (topAnimationController.value >=
                    (topAnimationController.lowerBound + mid) / 2 &&
                topAnimationController.value <= mid) {
              await _flingWithBallisticController(
                  topAnimationController.value,
                  (topAnimationController.lowerBound + mid) / 2,
                  mid,
                  math.max(2, flingVelocity));
            } else {
              await _flingWithBallisticController(
                  topAnimationController.value,
                  mid,
                  (topAnimationController.upperBound + mid) / 2,
                  math.min(-2, flingVelocity));
            }
          } else {
            // _topAnimationController.animateTo(
            //     _topAnimationController.lowerBound,
            //     curve: Curves.easeOut);

            await _flingWithBallisticController(
                topAnimationController.value,
                topAnimationController.lowerBound,
                mid,
                math.min(-2, flingVelocity));
          }
        }
      } else {
        if (flingVelocity.abs() > minFlingVelocity) {
          topAnimationController.fling(velocity: -flingVelocity);
        } else {
          final minPoint = _minTop / _maxTop;
          final mid = (1 - minPoint) / 2 + minPoint;
          topAnimationController.fling(
              velocity: topAnimationController.value > mid ? 2.0 : -2.0);
        }
      }
    }
  }

  Future<void> _flingWithBallisticController(
      double value, double min, double max, double velocity) {
    final Completer<void> completer = Completer<void>();
    _ballisticController = AnimationController(
      value: value,
      upperBound: max,
      lowerBound: min,
      vsync: context.vsync,
      duration: const Duration(milliseconds: 200),
      debugLabel: 'BoundBottomSheetScrollPositoinTopAnimationController',
    );
    void _tick() {
      if (_ballisticController == null) {
        return;
      }
      topAnimationController.value = _ballisticController!.value;
    }

    _ballisticController!
      ..addListener(_tick)
      ..fling(velocity: velocity).whenCompleteOrCancel(() {
        _ballisticController?.dispose();
        _ballisticController = null;
        completer.complete();
      });
    return completer.future;
  }

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    // Save this so we can call it later if we have to [goBallistic] on our own.
    _dragCancelCallback = dragCancelCallback;
    return super.drag(details, dragCancelCallback);
  }

  @override
  ScrollHoldController hold(VoidCallback holdCancelCallback) {
    _holdCancelCallback = holdCancelCallback;
    return super.hold(holdCancelCallback);
  }

  bool _disposed = false;

  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _ballisticController?.dispose();
      _ballisticController = null;
      super.dispose();
    }
  }
}
