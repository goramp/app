// import 'dart:ui';
// import 'dart:io';
// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:recase/recase.dart';
// import 'package:flutter/foundation.dart' as foundation;
// import '../../widgets/index.dart';

// import '../../models/index.dart';
// import '../../services/index.dart';
// import '../helpers/index.dart';
// import '../utils/index.dart';
// import '../../utils/index.dart';
// import '../custom/platform_adaptive.dart';
// import '../../app_config.dart';
// import '../../route_constants.dart';

// bool get _isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

// class PaymentButton extends StatefulWidget {
//   final CallLink event;
//   final Call booking;
//   final VoidCallback onCall;
//   PaymentButton(
//       {required this.event, required this.booking, required this.onCall})
//       : assert(event != null),
//         assert(booking != null),
//         assert(onCall != null);

//   @override
//   State<StatefulWidget> createState() {
//     return _PaymentButtonState();
//   }
// }

// class _PaymentButtonState extends State<PaymentButton> {
//   ValueNotifier<bool> _loading = ValueNotifier<bool>(false);

//   Future<bool> _showLowBalanceAlert() async {
//     final ThemeData theme = Theme.of(context);
//     final TextStyle dialogTextStyle =
//         theme.textTheme.subhead!.copyWith(color: theme.textTheme.caption!.color);
//     final TextStyle? dialogTitleTextStyle = theme.textTheme.title;

//     return await (showDialog<bool>(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Low Credit!', style: dialogTitleTextStyle),
//               content: Text(
//                   'You do not have enough credit to schedule this event.',
//                   style: dialogTextStyle),
//               actions: <Widget>[
//                 FlatButton(
//                     child: const Text('Cancel'),
//                     // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: kMediumBorderRadius),
//                     onPressed: () {
//                       Navigator.of(context).pop(
//                           false); // Pops the confirmation dialog but not the page.
//                     }),
//                 FlatButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: kMediumBorderRadius),
//                     child: const Text('Get Credits'),
//                     onPressed: () {
//                       NavigationService navigationService =
//                           Provider.of(context, listen: false);
//                       navigationService.navigateTo(CreditsRoute);
//                     })
//               ],
//             );
//           },
//         ) as FutureOr<bool>?) ??
//         false;
//   }

//   Widget _buildLoader() {
//     return SizedBox(
//       width: 24,
//       height: 24,
//       child: PlatformCircularProgressIndicator(
//           Theme.of(context).colorScheme.secondary),
//     );
//   }

//   Widget _buildDetails() {
//     ThemeData theme = Theme.of(context);
//     final NumberFormat formatter = NumberFormat.simpleCurrency(
//         decimalDigits: 2, locale: Localizations.localeOf(context).toString());
//     String priceText = widget.event.isFree
//         ? "FREE"
//         : formatter.format(widget.event.total / 100);
//     final priceStyle = Theme.of(context).textTheme.title!.copyWith(
//         fontWeight: FontWeight.bold,
//         color: theme.colorScheme.onPrimary,
//         fontSize: widget.event.isFree ? 16 : 20);
//     final labelStyle = Theme.of(context).textTheme.button!.copyWith(
//           color: theme.colorScheme.onPrimary,
//           fontWeight: FontWeight.bold,
//         );
//     if (widget.event.isFree) {
//       return Text("BOOK NOW", style: labelStyle);
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Text("Call", style: labelStyle),
//         SizedBox(
//           width: 8.0,
//         ),
//         Container(
//           padding: EdgeInsets.only(left: 16.0, right: 16.0),
//           height: double.infinity,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
//             borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(100),
//                 bottomRight: Radius.circular(100)),
//           ),
//           child: Text(
//             priceText,
//             style: priceStyle,
//           ),
//         ),
//       ],
//     );
//   }

//   void _showGetCredit() async {
//     NavigationService navigationService =
//         Provider.of<NavigationService>(context);
//     navigationService.navigateTo(CreditsRoute);
//   }

//   void _showError({String? title, String? message}) {
//     NotificationHelper.showErrorLight(context,
//         title: title, description: message);
//   }

//   void process() async {
//     try {
//       if (_loading.value) {
//         return;
//       }
//       _loading.value = true;
//       print("process");
//       double credits = 0;
//       if (credits < widget.event.total) {
//         bool getCredit = await _showLowBalanceAlert();
//         if (getCredit) {
//           _showGetCredit();
//         }
//       } else {
//         final config = Provider.of<AppConfig>(context, listen: false);
//         print("start schedule");
//         await CallService.schedule(config.baseApiUrl, widget.booking);
//         if (widget.onCall != null) {
//           widget.onCall();
//         }
//       }
//     } on UnavailableException catch (error) {
//       print("buy error: ${error.message}");
//       _showError(
//           message:
//               "Unfortunately, the selected time is currently unavailable. Please select a different time.");
//     } on LowCreditException catch (error) {
//       print("buy error: ${error.message}");
//       _showError(
//           message:
//               "Sorry, you do not have enough credit to schedule this event.");
//     } on SocketException catch (error) {
//       print('error ${error}');
//       _showError(message: CONNECTION_ERROR_MESSAGE);
//     } on HandshakeException catch (error) {
//       _showError(message: CONNECTION_ERROR_MESSAGE);
//       print('error ${error}');
//     } catch (error, stacktrace) {
//       _showError(message: StringResources.DEFAULT_ERROR_TITLE2);
//       print("failed with error: $error");
//       ErrorHandler.report(error, stacktrace);
//     } finally {
//       _loading.value = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
//       elevation: 0,
//       textStyle: theme.textTheme.button!.copyWith(fontWeight: FontWeight.bold),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//       ),
//     );
//     return Container(
//       height: 36.0,
//       child: ValueListenableBuilder(
//         valueListenable: _loading,
//         builder: (BuildContext context, bool loading, Widget? child) {
//           return AnimatedSwitcher(
//               duration: kThemeAnimationDuration,
//               child: loading ? _buildLoader() : child);
//         },
//         child: ElevatedButton(
//           //padding: EdgeInsets.only(left: 16.0),
//           style: raisedButtonStyle,
//           child: _buildDetails(),
//           onPressed: process,
//         ),
//       ),
//     );
//   }
// }

// class EventPaymentModal extends StatelessWidget {
//   final CallLink event;
//   final Call booking;
//   final ScrollController? controller;
//   final VoidCallback? onGetCredit;
//   final VoidCallback? onConfirm;
//   EventPaymentModal(this.event, this.booking,
//       {this.controller, this.onGetCredit, this.onConfirm});

//   Widget _buildThumbnail() {
//     return Container(
//       height: 40.0,
//       alignment: Alignment.centerRight,
//       child: Image(
//         image: CachedNetworkImageProvider(event?.video?.thumbnail?.url!),
//         fit: BoxFit.contain,
//       ),
//     );
//   }

//   double rightFontSize(BuildContext context) {
//     if (MediaQueryHelper.isLargeScreen(context)) {
//       return 15;
//     }
//     return 14;
//   }

//   double leftFontSize(BuildContext context) {
//     if (MediaQueryHelper.isLargeScreen(context)) {
//       return 13;
//     }
//     return 12;
//   }

//   Widget _buildPublisherInfo(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(top: 4.0),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: Text(
//               "@${event?.hostUsername ?? ''}",
//               style:
//                   Theme.of(context).textTheme.caption!.copyWith(fontSize: 12.0),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEventTitle(
//     BuildContext context,
//   ) {
//     return Text(
//       ReCase(event?.title ?? '').titleCase,
//       style: Theme.of(context).textTheme.title!.copyWith(
//           fontWeight: FontWeight.bold, fontSize: rightFontSize(context)),
//       maxLines: 2,
//       // textAlign: TextAlign.left,
//       overflow: TextOverflow.ellipsis,
//     );
//   }

//   Widget _buildEventDuration(
//     BuildContext context,
//   ) {
//     return Text(
//       '${event?.duration?.inMinutes} mins' ?? '',
//       style: Theme.of(context)
//           .textTheme
//           .title!
//           .copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
//       maxLines: 1,
//       overflow: TextOverflow.ellipsis,
//     );
//   }

//   _buildDetailRowLeft(BuildContext context) {
//     return _buildThumbnail();
//   }

//   _buildDetailRowRight(BuildContext context) {
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [_buildEventTitle(context), _buildPublisherInfo(context)]);
//   }

//   _buildDetailRow(BuildContext context) {
//     return _buildRow(
//         context, _buildDetailRowLeft(context), _buildDetailRowRight(context));
//   }

//   _buildDurationRow(BuildContext context) {
//     return _buildRow(
//       context,
//       Text(
//         "DURATION",
//         style: Theme.of(context).textTheme.caption!.copyWith(
//             fontSize: leftFontSize(context), fontWeight: FontWeight.w100),
//         textAlign: TextAlign.right,
//       ),
//       _buildEventDuration(context),
//     );
//   }

//   _buildCallRow(BuildContext context) {
//     DateTime date = booking.scheduledAt!;
//     return _buildRow(
//       context,
//       Text(
//         "DATE",
//         style: Theme.of(context).textTheme.caption!.copyWith(
//             fontSize: leftFontSize(context), fontWeight: FontWeight.w100),
//         textAlign: TextAlign.right,
//       ),
//       Text(
//         DateFormat('EEEE, MMM d, yyyy').format(date),
//         style: Theme.of(context).textTheme.title!.copyWith(
//             fontWeight: FontWeight.bold, fontSize: rightFontSize(context)),
//         textAlign: TextAlign.left,
//       ),
//     );
//   }

//   _buildPriceRow(BuildContext context) {
//     TimeOfDay time = booking.scheduledTime;
//     final localization = MaterialLocalizations.of(context);
//     return _buildRow(
//       context,
//       Text(
//         "TIME",
//         style: Theme.of(context).textTheme.caption!.copyWith(
//             fontSize: leftFontSize(context), fontWeight: FontWeight.w100),
//         textAlign: TextAlign.right,
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text(
//             IntervalHelper.formatTime(localization, time, capitalize: true),
//             style: Theme.of(context).textTheme.title!.copyWith(
//                 fontWeight: FontWeight.bold, fontSize: rightFontSize(context)),
//           ),
//           if (!event.isFree) _buildPaymentButton(context)
//         ],
//       ),
//     );
//   }

//   _buildPaymentButton(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return CupertinoButton(
//       minSize: 24.0,
//       padding: EdgeInsets.zero,
//       onPressed: onGetCredit,
//       child: Row(
//         children: <Widget>[
//           Icon(
//             MdiIcons.circleMultiple,
//             color: theme.colorScheme.secondary,
//             size: 14,
//           ),
//           //const Icon(MdiIcons.chevronDown, color: Colors.black54),
//           SizedBox(
//             width: 2.0,
//           ),
//           // BlocBuilder(
//           //   bloc: Provider.of<IAPCreditsBloc>(context),
//           //   builder: (BuildContext context, IAPCreditsState state) {
//           //     final NumberFormat formatter = NumberFormat.simpleCurrency(
//           //       decimalDigits: 2,
//           //       locale: Localizations.localeOf(context).toString(),
//           //     );
//           //     double credits = 0;
//           //     if (state is IAPCreditsLoaded && state.credit != null) {
//           //       credits = state.credit.availableBalance / 100;
//           //     }
//           //     return Text(
//           //       formatter.format(credits),
//           //       style: Theme.of(context).textTheme.caption.copyWith(
//           //           fontSize: leftFontSize(context),
//           //           color: theme.colorScheme.secondary),
//           //       textAlign: TextAlign.right,
//           //     );
//           //   },
//           // ),
//           Icon(
//             MdiIcons.chevronDown,
//             color: theme.colorScheme.secondary,
//             size: 18,
//           ),
//         ],
//       ),
//     );
//   }

//   _buildButtonRow(BuildContext context) {
//     return SafeArea(
//       bottom: true,
//       child: Container(
//         padding: EdgeInsets.all(12.0),
//         alignment: Alignment.center,
//         child: PaymentButton(
//           booking: booking,
//           event: event,
//           onCall: onConfirm!,
//         ),
//       ),
//     );
//   }

//   _buildRow(BuildContext context, Widget left, Widget right) {
//     return Container(
//       padding: EdgeInsets.all(12.0),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: left,
//             flex: 1,
//           ),
//           SizedBox(
//             width: 12.0,
//           ),
//           Expanded(child: right, flex: 3),
//         ],
//       ),
//     );
//   }

//   Widget _buildContent(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     final divider = const Divider(
//       height: 0.5,
//       indent: 16.0,
//     );
//     return IntrinsicHeight(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Container(
//               padding: EdgeInsets.all(12.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     'Confirm',
//                     style: theme.textTheme.title!
//                         .copyWith(fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.right,
//                   ),
//                   TextButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     child: Text(
//                       "Cancel",
//                     ),
//                   )
//                 ],
//               )),
//           Divider(
//             height: 0.5,
//           ),
//           _buildDetailRow(context),
//           if (_isIOS) divider,
//           _buildDurationRow(context),
//           if (_isIOS) divider,
//           _buildCallRow(context),
//           if (_isIOS) divider,
//           _buildPriceRow(context),
//           if (_isIOS) divider,
//           Expanded(
//             child: _buildButtonRow(context),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AdaptiveBackground(
//       //intensity: 12,
//       color: Theme.of(context).bottomAppBarColor,
//       child: LayoutBuilder(
//           builder: (BuildContext context, BoxConstraints viewportConstraints) {
//         // return SingleChildScrollView(
//         //   controller: controller,
//         //   child: ConstrainedBox(
//         //     constraints: BoxConstraints(
//         //       minHeight: viewportConstraints.maxHeight,
//         //     ),
//         //     child: Container(
//         //       decoration: BoxDecoration(
//         //         color: Colors.grey.shade200.withOpacity(0.5),
//         //         // borderRadius: BorderRadius.only(
//         //         //   topRight: Radius.circular(20.0),
//         //         //   topLeft: Radius.circular(20.0),
//         //         // ),
//         //       ),
//         //       child: _buildContent(context),
//         //     ),
//         //   ),
//         // );
//         return _buildContent(context);
//       }),
//     );
//   }
// }
