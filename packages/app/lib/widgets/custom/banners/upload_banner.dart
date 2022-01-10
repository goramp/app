// import 'dart:async';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'banner.dart';
// import 'banner_route.dart';
// import '../../../bloc/index.dart';

// class UploadBannerController<T> {
//   final BannerSettings settings;
//   final UploadBanner banner;

//   UploadBannerController(
//     EventPostUploading uploading, {
//     Key key,
//     Color progressBackgroundColor,
//     Color progressValueColor,
//     Color backgroundColor = const Color(0xFF303030),
//     double borderRadius = 4.0,
//     BoxShadow boxShadow,
//     bool showProgessText = true,
//     TextStyle progressTextStyle,
//     BannerSettings settings,
//   })  : banner = UploadBanner(
//           uploading,
//           key: key,
//           progressBackgroundColor: progressBackgroundColor == null
//               ? progressBackgroundColor
//               : Colors.transparent,
//           backgroundColor: backgroundColor,
//           boxShadow: boxShadow,
//           borderRadius: borderRadius,
//           showProgessText: showProgessText,
//           progressTextStyle: progressTextStyle,
//           bannerPosition: settings.bannerPosition,
//         ),
//         this.settings = settings != null ? settings : defaultBannerSettings;

//   BannerRoute<T> _bannerRoute;

//   /// Show the flushbar. Kicks in [BannerStatus.IS_APPEARING] state followed by [BannerStatus.SHOWING]
//   Future<T> show(BuildContext context) async {
//     _bannerRoute = showBanner<T>(
//       context: context,
//       builder: Builder(builder: (BuildContext context) => banner),
//       settings: settings,
//     );

//     return await Navigator.of(context, rootNavigator: false).push(_bannerRoute);
//   }

//   /// Dismisses the flushbar causing is to return a future containing [result].
//   /// When this future finishes, it is guaranteed that Flushbar was dismissed.
//   Future<T> dismiss([T result]) async {
//     // If route was never initialized, do nothing
//     if (_bannerRoute == null) {
//       return null;
//     }

//     if (_bannerRoute.isCurrent) {
//       _bannerRoute.navigator.pop(result);
//       return _bannerRoute.completed;
//     } else if (_bannerRoute.isActive) {
//       // removeRoute is called every time you dismiss a Flushbar that is not the top route.
//       // It will not animate back and listeners will not detect BannerStatus.IS_HIDING or BannerStatus.DISMISSED
//       // To avoid this, always make sure that Flushbar is the top route when it is being dismissed
//       _bannerRoute.navigator.removeRoute(_bannerRoute);
//     }

//     return null;
//   }

//   /// Checks if the flushbar is visible
//   bool isShowing() {
//     return _bannerRoute?.currentStatus == BannerStatus.SHOWING;
//   }

//   /// Checks if the flushbar is dismissed
//   bool isDismissed() {
//     return _bannerRoute?.currentStatus == BannerStatus.DISMISSED;
//   }
// }

// class UploadBanner<T extends Object> extends StatefulWidget {
//   final Color progressBackgroundColor;
//   final Color progressValueColor;
//   final Color backgroundColor;
//   final double borderRadius;
//   final BoxShadow boxShadow;
//   final bool showProgessText;
//   final BannerPosition bannerPosition;
//   final TextStyle progressTextStyle;

//   UploadBanner(
//     this.uploading, {
//     Key key,
//     this.progressBackgroundColor,
//     this.progressValueColor,
//     this.backgroundColor = const Color(0xFF303030),
//     this.borderRadius = 4.0,
//     this.boxShadow,
//     this.showProgessText = true,
//     this.bannerPosition = BannerPosition.TOP,
//     this.progressTextStyle,
//   });
//   @override
//   _UploadBannerState createState() => _UploadBannerState();
// }

// class _UploadBannerState extends State<UploadBanner>
//     with TickerProviderStateMixin {
//   AnimationController _fadeController;
//   Animation<double> _fadeAnimation;
//   final double _initialOpacity = 0;
//   final double _finalOpacity = 1.0;
//   BoxShadow _boxShadow;
//   final Duration _fadeAnimationDuration = Duration(milliseconds: 300);

//   @override
//   void initState() {
//     super.initState();

//     if (widget.boxShadow != null) {
//       _boxShadow = widget.boxShadow;
//     }
//     _configureFadeAnimation();
//   }

//   @override
//   void dispose() {
//     _fadeController?.dispose();
//     super.dispose();
//   }

//   void _configureFadeAnimation() {
//     _fadeController =
//         AnimationController(vsync: this, duration: _fadeAnimationDuration);
//     _fadeAnimation = Tween(begin: _initialOpacity, end: _finalOpacity).animate(
//       CurvedAnimation(
//         parent: _fadeController,
//         curve: Curves.linear,
//       ),
//     );
//     _fadeController.forward();
//   }

//   List<BoxShadow> _getBoxShadowList() {
//     if (_boxShadow != null) {
//       return [_boxShadow];
//     } else {
//       return null;
//     }
//   }

//   Widget _getProgress() {
//     return StreamBuilder<TaskSnapshot>(
//       stream: widget.uploading.uploadTask.snapshotEvents,
//       builder: (BuildContext context, AsyncSnapshot<TaskSnapshot> snapshot) {
//         double progress = 0;
//         String progressText = "";
//         if (snapshot.hasData) {
//           final TaskSnapshot taskSnapshot = snapshot.data;

//           if (taskSnapshot.totalBytes != null &&
//               taskSnapshot.totalBytes > 0 &&
//               taskSnapshot.bytesTransferred != null &&
//               taskSnapshot.bytesTransferred > 0) {
//             progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
//             int percent = ((progress * 100) + 0.5).toInt();
//             if (percent > 0) {
//               progressText = "$percent%";
//             }
//           }
//         }
//         return CircularPercentIndicator(
//           radius: 30.0,
//           lineWidth: 3.0,
//           percent: progress,
//           progressColor: Theme.of(context).colorScheme.primary,
//           backgroundColor: Colors.white.withOpacity(0.38),
//           center: Text(
//             progressText,
//             style: widget.progressTextStyle ??
//                 TextStyle(fontSize: 8.0, color: Colors.white),
//           ),
//         );
//       },
//     );
//   }

//   Widget _getBar(BuildContext context) {
//     int width = widget.uploading?.callLinkPost?.callLink?.video?.width;
//     int height = widget.uploading?.callLinkPost?.callLink?.video?.height ?? 0;
//     double aspectRatio = 1.0;
//     if (height > 0) {
//       aspectRatio = width / height;
//     }
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Container(
//           decoration: BoxDecoration(
//             color: widget.backgroundColor,
//             boxShadow: _getBoxShadowList(),
//             borderRadius: BorderRadius.circular(4.0),
//             image: DecorationImage(
//               image: NetworkImage(
//                   widget.uploading.callLinkPost.callLink.video.thumbnail.url),
//               fit: BoxFit.cover,
//             ),
//           ),
//           width: 60.0,
//           child: Stack(
//             children: <Widget>[
//               AspectRatio(
//                 aspectRatio: aspectRatio,
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: _getProgress(),
//                 ),
//               ),
//             ],
//           )),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       minimum: widget.bannerPosition == BannerPosition.BOTTOM
//           ? EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
//           : EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
//       bottom: widget.bannerPosition == BannerPosition.BOTTOM,
//       top: widget.bannerPosition == BannerPosition.TOP,
//       left: false,
//       right: false,
//       child: _getBar(context),
//     );
//   }
// }
