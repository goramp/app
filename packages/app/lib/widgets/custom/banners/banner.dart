import 'package:flutter/material.dart';

const String BANNER_ROUTE_NAME = "/bannerRoute";

typedef void BannerStatusCallback(BannerStatus? status);

/// Indicates if flushbar is going to start at the [TOP] or at the [BOTTOM]
enum BannerPosition { TOP, BOTTOM }

/// Indicates if flushbar will be attached to the edge of the screen or not
enum BannerStyle { FLOATING, GROUNDED }

/// Indicates the direction in which it is possible to dismiss
/// If vertical, dismiss up will be allowed if [BannerPosition.TOP]
/// If vertical, dismiss down will be allowed if [BannerPosition.BOTTOM]
enum BannerDismissDirection { HORIZONTAL, VERTICAL }

/// Indicates the animation status
/// [BannerStatus.SHOWING] Flushbar has stopped and the user can see it
/// [BannerStatus.DISMISSED] Flushbar has finished its mission and returned any pending values
/// [BannerStatus.IS_APPEARING] Flushbar is moving towards [BannerStatus.SHOWING]
/// [BannerStatus.IS_HIDING] Flushbar is moving towards [] [BannerStatus.DISMISSED]
enum BannerStatus { SHOWING, DISMISSED, IS_APPEARING, IS_HIDING }

void defaultBannerCallback(BannerStatus? status) {}

const BannerSettings defaultBannerSettings = const BannerSettings(
  aroundPadding: const EdgeInsets.all(0.0),
  animationDuration: const Duration(seconds: 1),
  onStatusChanged: defaultBannerCallback,
  forwardAnimationCurve: Curves.easeOut,
  reverseAnimationCurve: Curves.fastOutSlowIn,
  dismissDirection: BannerDismissDirection.VERTICAL,
  isDismissible: false,
  bannerPosition: BannerPosition.TOP,
);

@immutable
class BannerSettings {
  final BannerPosition bannerPosition;
  final BannerStatusCallback onStatusChanged;
  final Color overlayColor;
  final double overlayBlur;
  final bool isDismissible;
  final EdgeInsets aroundPadding;
  final BannerDismissDirection dismissDirection;
  final Duration animationDuration;
  final Curve forwardAnimationCurve;
  final Curve reverseAnimationCurve;
  final Duration? duration;

  const BannerSettings({
    this.bannerPosition = BannerPosition.TOP,
    this.onStatusChanged = defaultBannerCallback,
    this.overlayBlur = 0,
    this.overlayColor = Colors.transparent,
    this.isDismissible = true,
    this.aroundPadding = EdgeInsets.zero,
    this.dismissDirection = BannerDismissDirection.VERTICAL,
    this.animationDuration = const Duration(seconds: 1),
    this.forwardAnimationCurve = Curves.easeOut,
    this.reverseAnimationCurve = Curves.fastOutSlowIn,
    this.duration,
  });

  BannerSettings copyWith({
    BannerPosition? bannerPosition,
    BannerStatusCallback? onStatusChanged,
    Color? overlayColor,
    double? overlayBlur,
    bool? isDismissible,
    EdgeInsets? aroundPadding,
    BannerDismissDirection? dismissDirection,
    Duration? animationDuration,
    Curve? forwardAnimationCurve,
    Curve? reverseAnimationCurve,
    Duration? duration,
  }) {
    return BannerSettings(
      bannerPosition: bannerPosition ?? this.bannerPosition,
      onStatusChanged: onStatusChanged ?? this.onStatusChanged,
      overlayColor: overlayColor ?? this.overlayColor,
      overlayBlur: overlayBlur ?? this.overlayBlur,
      isDismissible: isDismissible ?? this.isDismissible,
      aroundPadding: aroundPadding ?? this.aroundPadding,
      dismissDirection: dismissDirection ?? this.dismissDirection,
      animationDuration: animationDuration ?? this.animationDuration,
      forwardAnimationCurve:
          forwardAnimationCurve ?? this.forwardAnimationCurve,
      reverseAnimationCurve:
          reverseAnimationCurve ?? this.reverseAnimationCurve,
      duration: duration ?? this.duration,
    );
  }
}
