// import 'package:flutter/material.dart';
// import 'package:goramp/models/index.dart';
// import 'package:goramp/widgets/pages/call_links/availability/edit_availability.dart';
// import 'package:goramp/widgets/pages/call_links/details/index.dart';
// import 'package:goramp/widgets/pages/call_links/pricing/add_price.dart';
// import 'package:goramp/widgets/pages/firebase_email_sigin_callback/index.dart';
// import 'package:provider/provider.dart';
// import 'app_config.dart';
// import 'widgets/index.dart';
// import './widgets/index.dart';
// import 'route_constants.dart';

// // Route<dynamic> _handleAuth(final Uri uri) {
// //   final mode = uri?.queryParameters['mode'];
// //   final actionCode = uri?.queryParameters['oobCode'];
// //   final continueUrl = uri?.queryParameters['continueUrl'];
// //   final lang = uri?.queryParameters['lang'];
// //   if (uri.path.startsWith(EmailCallbackRoute)) {
// //     return MaterialPageRoute(builder: (BuildContext context) {
// //       AppConfig config = Provider.of(context);
// //       final url = 'https://${config.webDomain}$uri';
// //       return FBEmailSignInCallback(
// //         actionCode!,
// //         mode!,
// //         url: url,
// //       );
// //     });
// //   }
// //   switch (mode) {
// //     case 'resetPassword':
// //       // Display reset password handler and UI.
// //       return MaterialPageRoute(builder: (BuildContext context) {
// //         return ChangePassword(actionCode!, lang: lang, continueUrl: continueUrl);
// //       });
// //     //handleResetPassword(auth, actionCode, continueUrl, lang);
// //     case 'recoverEmail':
// //       // Display email recovery handler and UI.
// //       // handleRecoverEmail(auth, actionCode, lang);
// //       return MaterialPageRoute(
// //           builder: (BuildContext context) => ResetPassword());
// //       break;
// //     case 'verifyEmail':
// //       // Display email verification handler and UI.
// //       // handleVerifyEmail(auth, actionCode, continueUrl, lang);
// //       return MaterialPageRoute(
// //           builder: (BuildContext context) => ResetPassword());
// //       break;
// //     default:
// //     // Error: invalid mode.
// //   }
// // }

// Route<dynamic> generateRoute(RouteSettings settings) {
//   String? path = settings.name;
//   // "/share?token=123456789"
//   final uri = Uri.tryParse(settings.name!);
//   final mode = uri?.queryParameters['mode'];
//   final actionCode = uri?.queryParameters['oobCode'];
//   if (mode != null && actionCode != null) {
//     //return _handleAuth(uri!);
//   }
//   switch (path) {
//     case MainRoute:
//       return MaterialPageRoute(
//         builder: (BuildContext context) {
//           return SecurePage(
//             MainScaffold(),
//           );
//         },
//       );
//     case WelcomeRoute:
//       return MaterialPageRoute(builder: (BuildContext context) => Welcome());
//     // case CallRoute:
//     //   CallScreenArguments args = settings.arguments;
//     //   return MaterialPageRoute(
//     //     fullscreenDialog: true,
//     //     builder: (context) {
//     //       return SecurePage(CallScreen(args));
//     //     },
//     //   );
//     // case OnBoardingRoute:
//     //   return MaterialPageRoute(
//     //     fullscreenDialog: true,
//     //     builder: (context) {
//     //       return OnBoarding();
//     //     },
//     //   );
//     case AddPriceRoute:
//       return MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) {
//           final args = settings.arguments as PriceInputArgument?;
//           return SecurePage(
//             AddPrice(),
//           );
//         },
//       );

//     // case CallPreviewRoute:
//     //   CallPreviewArguments args = settings.arguments;
//     //   return MaterialPageRoute(
//     //     fullscreenDialog: true,
//     //     builder: (context) {
//     //       return SecurePage(CallPreview(
//     //         autoRecordingEnabled: args.autoRecordingEnabled,
//     //         onResult: args.onResult,
//     //       ));
//     //     },
//     //   );
//     //CallPreview
//     case CallLinksRoute:
//       return MaterialPageRoute(
//         builder: (context) {
//           final CallLinkPreviewArgs args =
//               settings.arguments as CallLinkPreviewArgs;
//           return AnonymousPage(
//             CallLinkPreview(
//               itemId: args.itemId,
//               item: args.item,
//               feedBloc: args.feedBloc,
//               isFavorite: args.isFavorite,
//             ),
//           );
//         },
//       );
//     case ScheduleRoute:
//       return MaterialPageRoute(
//         builder: (context) {
//           final FeedPreviewArgs<Call> args =
//               settings.arguments as FeedPreviewArgs<Call>;
//           return SecurePage(CallPreview(
//             args.itemId,
//             call: args.item,
//           ));
//         },
//       );
//     case ArchivePreviewRoute:
//       return MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => SecurePage(ArchivePreview(settings.arguments as RecordFeedArgs?)),
//       );
//     // case IncomingCallBackgroundRoute:
//     //   return MaterialPageRoute(
//     //     fullscreenDialog: true,
//     //     builder: (context) {
//     //       return const SecurePage(
//     //         IncomingCallBackgroundUI(),
//     //       );
//     //     },
//     //   );
//     // case AnswerCallBackgroundRoute:
//     //   return MaterialPageRoute(
//     //     fullscreenDialog: true,
//     //     builder: (context) {
//     //       return const SecurePage(AnswerCallBackgroundUI());
//     //     },
//     //   );
//     // case IncomingCallRoute:
//     //   return MaterialPageRoute(
//     //     fullscreenDialog: true,
//     //     builder: (context) {
//     //       return SecurePage(IncomingCallForegroundUI(settings.arguments));
//     //     },
//     //   );
//     case NewScheduleRoute:
//       return MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) => SecurePage(NewSchedule(settings.arguments as CallLink?)),
//       );
//     case SettingsRoute:
//       return MaterialPageRoute(
//           builder: (context) => const SecurePage(SettingsPage()));
//     // case TrimmerRoute:
//     //   return MaterialPageRoute(
//     //       fullscreenDialog: true,
//     //       builder: (context) => SecurePage(TrimmerPreview(settings.arguments)));
//     case EditAvailabilityRoute:
//       return MaterialPageRoute(
//         fullscreenDialog: true,
//         builder: (context) {
//           final args = settings.arguments as EditAvailabilityArgs;
//           return SecurePage(
//             EditAvailabilityPage(
//               //availability: args.availability,
//               duration: args.duration,
//               linkId: args.linkId,
//               eventName: args.eventName,
//               videoThumb: args.videoThumb,
//             ),
//           );
//         },
//       );
//     // case AvailabilitiesRoute:
//     //   return MaterialPageRoute(
//     //     fullscreenDialog: true,
//     //     builder: (context) {
//     //       final args = settings.arguments as AvailabilitiesArguement;
//     //       return SecurePage(
//     //         Availabilities(
//     //           event: args.event,
//     //           duration: args.duration,
//     //           linkId: args.linkId,
//     //           weeklyAvailabilities: args.weeklyAvailabilities,
//     //         ),
//     //       );
//     //     },
//     //   );
//     case EditProfileRoute:
//       return MaterialPageRoute(
//           builder: (BuildContext context) {
//             return SecurePage(EditProfile());
//           },
//           fullscreenDialog: true);
//     case RecordRoute:
//       return MaterialPageRoute(
//           builder: (BuildContext context) {
//             return SecurePage(
//               RecordView(
//                 isPicker: settings.arguments as bool?,
//               ),
//             );
//           },
//           fullscreenDialog: true);
//     // case NewCallLinkRoute:
//     //   return MaterialPageRoute(
//     //       builder: (BuildContext context) {
//     //         final args = settings.arguments as CallLinkArguement;
//     //         return SecurePage(NewCallLink(
//     //           videoAsset: args.videoAsset,
//     //           event: args.event,
//     //         ));
//     //       },
//     //       fullscreenDialog: true);
//     case SimpleRecordingListRoute:
//       return MaterialPageRoute(
//         builder: (BuildContext context) {
//           return SecurePage(SimpleRecordingList(settings.arguments as String?));
//         },
//       );
//     default:
//       return MaterialPageRoute(
//           builder: (BuildContext context) => UnknownScreen());
//   }
// }
